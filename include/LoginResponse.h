#pragma once

#include <QJsonObject>

struct LoginResponse
{
    QString token;
    qint64 expiresAt = 0;
    QJsonObject profile;
    QString error;

    static LoginResponse read(int status, const QByteArray &body);
};
