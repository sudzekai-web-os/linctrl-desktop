#pragma once

#include "NetworkSession.h"
#include <QNetworkAccessManager>
#include <QVariant>
#include <qqmlintegration.h>

class DesktopNetwork : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit DesktopNetwork(QObject *parent = nullptr);
    Q_INVOKABLE QString normalizeHost(const QString &input) const;
    Q_INVOKABLE QVariantMap restore();
    Q_INVOKABLE QString login(const QVariantMap &server, const QString &username, const QString &password);
    Q_INVOKABLE QString request(const QString &method, const QString &path, const QVariantMap &body);
    Q_INVOKABLE bool clear();

signals:
    void loginFinished(const QString &id, int status, const QVariantMap &session, const QString &error);
    void responseFinished(const QString &id, int status, const QVariantMap &response, const QString &error);

private:

    QNetworkAccessManager m_network;
    NetworkSession m_session;
    quint64 m_generation = 0;
};
