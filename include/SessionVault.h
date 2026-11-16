#pragma once

#include <QJsonObject>

namespace SessionVault
{
    QJsonObject read();
    bool write(const QJsonObject &session);
}
