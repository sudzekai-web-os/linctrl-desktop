#include "PluginDataFiles.h"
#include "AppData.h"
#include "PluginPaths.h"

#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QSaveFile>

using PluginPaths::inside;
using PluginPaths::relativeFile;

static QString dataFile(const QString &id, const QString &path)
{
    if (!relativeFile(path) || QDir::cleanPath(path) == ".")
        return {};

    const auto root = QDir(AppData::directory()).filePath("plugin-data/" + id);
    const auto candidate = QDir(root).absoluteFilePath(QDir::cleanPath(path));
    if (!inside(root, candidate))
        return {};

    // Reject links in the writable path before creating directories or opening files.
    auto current = QFileInfo(candidate);
    while (inside(AppData::directory(), current.absoluteFilePath()))
    {
        if (current.isSymLink() || current.isJunction())
            return {};
        current = QFileInfo(current.absolutePath());
    }

    return candidate;
}

QString PluginDataFiles::readText(const QString &id, const QString &path)
{
    QFile file(dataFile(id, path));
    return file.open(QIODevice::ReadOnly) ? QString::fromUtf8(file.readAll()) : QString{};
}

bool PluginDataFiles::writeText(const QString &id, const QString &path, const QString &text)
{
    const auto target = dataFile(id, path);
    if (target.isEmpty() || !QDir().mkpath(QFileInfo(target).absolutePath()))
        return false;

    const auto bytes = text.toUtf8();
    QSaveFile file(target);
    return file.open(QIODevice::WriteOnly) && file.write(bytes) == bytes.size() && file.commit();
}
