#pragma once

#include <QObject>
#include <QPointer>
#include <QUrl>
#include <QVariant>
#include <qqmlintegration.h>

class QQmlEngine;
class QJSEngine;

class PluginFiles : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_PROPERTY(QString directory READ directory CONSTANT)
    Q_PROPERTY(QString appDataDirectory READ appDataDirectory CONSTANT)

public:
    static PluginFiles *create(QQmlEngine *engine, QJSEngine *);
    QString directory() const;
    QString appDataDirectory() const;

    Q_INVOKABLE QVariantMap scan();
    Q_INVOKABLE QVariantMap load(const QString &id);
    Q_INVOKABLE QString readText(const QString &id, const QString &path) const;
    Q_INVOKABLE bool writeText(const QString &id, const QString &path, const QString &text) const;

private:
    explicit PluginFiles(QQmlEngine *engine);
    QVariantMap find(const QString &id) const;
    bool enabled(const QString &id) const;

    QPointer<QQmlEngine> m_engine;
    QVariantMap m_entries;
};
