#include "DesktopNetwork.h"
#include "ApiResponse.h"
#include "LoginResponse.h"
#include "ServerAddress.h"

#include <QJsonDocument>
#include <QNetworkReply>
#include <QUuid>

DesktopNetwork::DesktopNetwork(QObject *parent)
    : QObject(parent)
{
    m_network.setTransferTimeout(15000);
}

QString DesktopNetwork::normalizeHost(const QString &input) const
{
    return ServerAddress::normalize(input);
}

QVariantMap DesktopNetwork::restore()
{
    return m_session.restore();
}

QString DesktopNetwork::login(const QVariantMap &server, const QString &username, const QString &password)
{
    auto url = ServerAddress::url(server, "/auth/login");
    if (!url.isValid() || url.host().isEmpty())
        return {};

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setAttribute(QNetworkRequest::RedirectPolicyAttribute, QNetworkRequest::ManualRedirectPolicy);
    const auto generation = m_generation;
    const auto id = QUuid::createUuid().toString(QUuid::WithoutBraces);
    auto reply = m_network.post(request, QJsonDocument(QJsonObject{
        {"username", username}, {"password", password}}).toJson(QJsonDocument::Compact));
    connect(reply, &QNetworkReply::finished, this, [this, reply, id, generation, server, username] {
        reply->deleteLater();
        if (generation != m_generation)
            return;

        const auto status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        const auto response = LoginResponse::read(status, reply->readAll());
        QVariantMap session;
        auto error = response.error;
        if (!response.token.isEmpty() && reply->error() == QNetworkReply::NoError)
        {
            session = m_session.activate(server, response.token, response.expiresAt, username, response.profile);
            if (!session.isEmpty() && !m_session.save(session))
            {
                m_session.reset();
                session.clear();
                error = tr("Не удалось сохранить сессию.");
            }
        }
        emit loginFinished(id, status, session, error);
    });
    return id;
}

QString DesktopNetwork::request(const QString &method, const QString &path, const QVariantMap &body)
{
    if (!m_session.valid() || (method != "GET" && method != "POST" && method != "PUT" && method != "DELETE" && method != "PATCH"))
        return {};

    const auto url = ServerAddress::requestUrl(m_session.server(), path);
    if (url.isEmpty())
        return {};

    QNetworkRequest request(url);
    request.setAttribute(QNetworkRequest::RedirectPolicyAttribute, QNetworkRequest::ManualRedirectPolicy);
    request.setRawHeader("Authorization", "Bearer " + m_session.token().toUtf8());
    if (!body.isEmpty())
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    const auto generation = m_generation;
    const auto id = QUuid::createUuid().toString(QUuid::WithoutBraces);
    if (path.startsWith("/docker/images/build?") || path.startsWith("/docker/images/pull?")
        || (path.startsWith("/docker/containers/") && path.endsWith("/exec")))
        request.setTransferTimeout(310000);

    const auto payload = body.isEmpty() ? QByteArray{} : QJsonDocument(QJsonObject::fromVariantMap(body)).toJson(QJsonDocument::Compact);
    auto reply = m_network.sendCustomRequest(request, method.toLatin1(), payload);
    connect(reply, &QNetworkReply::finished, this, [this, reply, id, generation] {
        reply->deleteLater();
        if (generation != m_generation)
            return;

        const auto status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        const auto response = ApiResponse::read(reply->readAll(),
            reply->header(QNetworkRequest::ContentTypeHeader).toString());
        emit responseFinished(id, status, response, status == 0 ? reply->errorString() : QString{});
    });
    return id;
}

bool DesktopNetwork::clear()
{
    ++m_generation;
    for (auto reply : m_network.findChildren<QNetworkReply *>())
        if (reply->isRunning())
            reply->abort();

    return m_session.clear();
}
