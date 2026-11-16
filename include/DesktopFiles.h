#pragma once

#include <QObject>
#include <QUrl>
#include <QVariantMap>

class DesktopFiles final : public QObject
{
    Q_OBJECT

public:
    using QObject::QObject;

    Q_INVOKABLE QVariantMap read(const QUrl &url) const;
    Q_INVOKABLE QString save(const QUrl &url, const QString &content) const;
};
