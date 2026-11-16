#pragma once

#include <QJsonObject>
#include <QVariant>

class NetworkSession
{
public:
    QVariantMap restore();
    QVariantMap activate(const QVariantMap &server, const QString &token, qint64 expiresAt,
        const QString &login, const QJsonObject &profile);
    bool save(const QVariantMap &profile) const;
    void reset();
    bool clear();

    bool valid() const;
    const QVariantMap &server() const { return m_server; }
    const QString &token() const { return m_token; }

private:
    QVariantMap m_server;
    QString m_token;
    qint64 m_expiresAt = 0;
};
