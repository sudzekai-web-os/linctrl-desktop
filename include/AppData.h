#pragma once

#include <QJsonObject>
#include <QString>

namespace AppData
{
    QString directory();
    QJsonObject read(const QString &block);
    bool write(const QString &block, const QJsonObject &value);
}
