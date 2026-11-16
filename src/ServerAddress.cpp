#include "ServerAddress.h"

#include <QHostAddress>
#include <QRegularExpression>

QString ServerAddress::normalize(const QString &input)
{
    auto host = input.trimmed();
    if (host.startsWith('[') && host.endsWith(']'))
        host = host.mid(1, host.size() - 2);

    QHostAddress ip;
    if (ip.setAddress(host))
        return ip.toString();

    static const QRegularExpression domain(
        QStringLiteral(R"(^(?=.{1,253}$)(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)*[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.?$)"),
        QRegularExpression::CaseInsensitiveOption);
    return domain.match(host).hasMatch() ? host.toLower() : QString{};
}

QUrl ServerAddress::url(const QVariantMap &server, const QString &path)
{
    QUrl url;
    url.setScheme(server.value("secure").toBool() ? "https" : "http");
    url.setHost(server.value("address").toString());
    const auto port = server.value("port").toInt();
    if (port > 0)
        url.setPort(port);
    url.setPath(path);
    return url;
}

QUrl ServerAddress::requestUrl(const QVariantMap &server, const QString &path)
{
    const auto relative = QUrl::fromEncoded(path.toUtf8(), QUrl::StrictMode);
    static const QRegularExpression route(QStringLiteral(R"(^/(?:[A-Za-z0-9_-][A-Za-z0-9_.-]*/)*[A-Za-z0-9_-][A-Za-z0-9_.-]*$)"));
    static const QRegularExpression systemctlRoute(QStringLiteral(R"(^/systemctl/services/[A-Za-z0-9][A-Za-z0-9_.@:-]*\.service(?:/(?:start|stop|restart))?$)"));
    const auto routePath = relative.path();
    if (!relative.isValid() || !relative.isRelative() || !relative.authority().isEmpty() || relative.hasFragment()
        || (!route.match(routePath).hasMatch() && !systemctlRoute.match(routePath).hasMatch()))
        return {};

    auto target = ServerAddress::url(server, relative.path());
    target.setQuery(relative.query(QUrl::FullyEncoded), QUrl::StrictMode);
    return target;
}
