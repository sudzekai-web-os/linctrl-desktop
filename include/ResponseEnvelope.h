#pragma once

#include <QByteArray>
#include <QJsonValue>
#include <QString>

struct ResponseEnvelope
{
    bool success = false;
    QJsonValue data;
    QString error;

    static ResponseEnvelope read(int status, const QByteArray &body);
};
