#include "NetworkSession.h"
#include "SessionVault.h"

#include <QDateTime>
#include <QJsonDocument>

QVariantMap NetworkSession::restore()
{
    const auto saved = SessionVault::read();
    return activate(saved.value("server").toObject().toVariantMap(), saved.value("accessToken").toString(),
        saved.value("expiresAt").toInteger(), saved.value("username").toString(), saved);
}

QVariantMap NetworkSession::activate(const QVariantMap &server, const QString &token, qint64 expiresAt, const QString &login, const QJsonObject &profile)
{
    const auto segments = token.toLatin1().split('.');
    if (server.isEmpty() || segments.size() != 3 || segments.at(2).isEmpty())
        return {};

    const auto payload = QByteArray::fromBase64(segments.at(1), QByteArray::Base64UrlEncoding | QByteArray::AbortOnBase64DecodingErrors);
    const auto claims = QJsonDocument::fromJson(payload).object();
    const auto expiry = qMin(expiresAt, claims.value("exp").toInteger());
    if (expiry <= QDateTime::currentSecsSinceEpoch())
        return {};

    m_token = token;
    m_server = server;
    m_expiresAt = expiry;

    const auto role = claims.value("role").toString();
    const auto legacyRoleId = role == "Administrator" ? 1 : role == "User" ? 2 : role == "Viewer" ? 4 : 0;
    const auto userId = profile.value("id").toInteger(
        profile.value("userId").toInteger(claims.value("sub").toString().toLongLong()));
    return {{"server", server}, {"expiresAt", expiry}, {"name", profile.value("username").toString(claims.value("name").toString(login))},
        {"role", role}, {"roleId", profile.value("roleId").toInt(legacyRoleId)},
        {"userId", userId > 0 ? QString::number(userId) : QString{}}};
}

bool NetworkSession::save(const QVariantMap &profile) const
{
    return SessionVault::write({{"server", QJsonObject::fromVariantMap(m_server)}, {"accessToken", m_token},
        {"expiresAt", m_expiresAt}, {"username", profile.value("name").toString()},
        {"userId", profile.value("userId").toString().toLongLong()}, {"roleId", profile.value("roleId").toInt()}});
}

bool NetworkSession::valid() const
{
    return !m_token.isEmpty() && m_expiresAt > QDateTime::currentSecsSinceEpoch();
}

void NetworkSession::reset()
{
    m_token.clear();
    m_server.clear();
    m_expiresAt = 0;
}

bool NetworkSession::clear()
{
    reset();
    return SessionVault::write({});
}
