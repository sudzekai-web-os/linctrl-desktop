#include "DesktopStorage.h"
#include "AppData.h"

#include <QJsonObject>

QVariantMap DesktopStorage::read(const QString &block) const
{
    if (block == "servers" || block == "plugins" || block == "appearance")
        return AppData::read(block).toVariantMap();
    return {};
}

bool DesktopStorage::write(const QString &block, const QVariantMap &value) const
{
    return (block == "servers" || block == "plugins" || block == "appearance") && AppData::write(block, QJsonObject::fromVariantMap(value));
}
