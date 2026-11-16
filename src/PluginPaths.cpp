#include "PluginPaths.h"

#include <QDir>

namespace PluginPaths
{
    bool inside(const QString &root, const QString &path)
    {
        return !root.isEmpty() && path.startsWith(root + "/");
    }

    bool relativeFile(const QString &path)
    {
        return !path.isEmpty() && !QDir::isAbsolutePath(path)
            && !path.contains(':') && !path.contains('\\')
            && !path.split('/').contains("..");
    }
}
