#pragma once

#include <QObject>
#include <QVariant>
#include <qqmlintegration.h>

class ThemeFiles : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    using QObject::QObject;

    Q_INVOKABLE QVariantMap sources() const;
    Q_INVOKABLE bool validColor(const QString &color) const;
};
