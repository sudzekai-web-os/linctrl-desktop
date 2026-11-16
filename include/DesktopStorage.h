#pragma once

#include <QObject>
#include <QVariant>
#include <qqmlintegration.h>

class DesktopStorage : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    using QObject::QObject;
    Q_INVOKABLE QVariantMap read(const QString &block) const;
    Q_INVOKABLE bool write(const QString &block, const QVariantMap &value) const;
};
