#include "PluginCatalog.h"
#include "PluginPaths.h"

#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QRegularExpression>
#include <QSet>

using PluginPaths::inside;
using PluginPaths::relativeFile;

PluginCatalog::Result PluginCatalog::scan(const QString &directory)
{
    const auto error = QDir().mkpath(directory) ? QString{} : QCoreApplication::translate("PluginCatalog", "Не удалось создать папку плагинов.");
    QVariantMap entries;

    const QStringList locations{
        directory,
        QDir::current().absoluteFilePath("plugins"),
        QDir(QCoreApplication::applicationDirPath()).filePath("plugins")
    };
    QSet<QString> visited;
    QSet<QString> ids;
    QVariantList items;
    static const QRegularExpression validId(QStringLiteral(R"(^[a-z0-9][a-z0-9._-]{0,79}$)"));

    for (const auto &location : locations)
    {
        const auto root = QDir(location).canonicalPath();
        if (root.isEmpty() || visited.contains(root))
            continue;

        visited.insert(root);
        for (const auto &package : QDir(root).entryInfoList({"*.linctrl"}, QDir::Dirs, QDir::Name))
        {
            const auto folder = package.canonicalFilePath();
            if (!inside(root, folder))
                continue;

            const auto manifestPath = QFileInfo(QDir(folder).filePath("manifest.json")).canonicalFilePath();
            QFile manifest(manifestPath);
            if (!inside(folder, manifestPath) || !manifest.open(QIODevice::ReadOnly))
                continue;

            const auto metadata = QJsonDocument::fromJson(manifest.readAll()).object();
            const auto id = metadata.value("id").toString();
            const auto name = metadata.value("name").toString().trimmed();
            const auto entry = metadata.value("entry").toString();
            const auto entryFile = QFileInfo(QDir(folder).filePath(entry));
            const auto canonicalEntry = entryFile.canonicalFilePath();
            if (!validId.match(id).hasMatch() || name.isEmpty() || ids.contains(id)
                || metadata.value("apiVersion").toInt(1) != 1 || !relativeFile(entry)
                || entryFile.suffix() != "qml" || !entryFile.isFile() || !inside(folder, canonicalEntry))
            {
                qWarning() << "Skipping invalid or duplicate plugin" << folder;
                continue;
            }

            QStringList libraries;
            bool validLibraries = true;
            const auto dependencies = metadata.value("libraries");
            if (!dependencies.isUndefined() && !dependencies.isArray())
                validLibraries = false;

            for (const auto &dependency : dependencies.toArray())
            {
                const auto path = dependency.toString();
                const auto file = QFileInfo(QDir(folder).filePath(path));
                if (!relativeFile(path) || !file.isFile() || !inside(folder, file.canonicalFilePath()))
                {
                    validLibraries = false;
                    break;
                }

                libraries.append(file.canonicalFilePath());
            }

            if (!validLibraries)
            {
                qWarning() << "Skipping plugin with invalid dependencies" << folder;
                continue;
            }

            ids.insert(id);
            entries.insert(id, QVariantMap{{"folder", folder}, {"entry", QUrl::fromLocalFile(canonicalEntry)},
                {"libraries", libraries}});
            items.append(QVariantMap{{"id", id}, {"name", name}, {"summary", metadata.value("summary").toString()}});
        }
    }

    return {entries, items, error};
}
