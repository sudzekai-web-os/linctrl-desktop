#pragma once

#include <QString>

namespace PluginPaths
{
    bool inside(const QString &root, const QString &path);
    bool relativeFile(const QString &path);
}
