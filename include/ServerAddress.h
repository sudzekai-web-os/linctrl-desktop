#pragma once

#include <QUrl>
#include <QVariant>

namespace ServerAddress
{
    QString normalize(const QString &input);
    QUrl url(const QVariantMap &server, const QString &path);
    QUrl requestUrl(const QVariantMap &server, const QString &path);
}
