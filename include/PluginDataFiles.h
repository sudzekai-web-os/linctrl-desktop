#pragma once

#include <QString>

namespace PluginDataFiles
{
    QString readText(const QString &id, const QString &path);
    bool writeText(const QString &id, const QString &path, const QString &text);
}
