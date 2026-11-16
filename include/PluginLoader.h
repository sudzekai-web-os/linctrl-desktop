#pragma once

#include <QVariant>

class QQmlEngine;

namespace PluginLoader
{
    QVariantMap load(QQmlEngine *engine, const QVariantMap &plugin);
}
