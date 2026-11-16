#include "PluginLoader.h"

#include <QCoreApplication>
#include <QDir>
#include <QFileInfo>
#include <QLibrary>
#include <QQmlEngine>

QVariantMap PluginLoader::load(QQmlEngine *engine, const QVariantMap &plugin)
{
    if (plugin.isEmpty() || !engine)
        return {};
    const auto libraries = plugin.value("libraries").toStringList();
    for (const auto &path : libraries)
    {
        QLibrary library(path);
        library.setLoadHints(QLibrary::PreventUnloadHint);
        if (!library.load())
        {
            const auto error = QCoreApplication::translate("PluginLoader", "Не удалось загрузить библиотеку %1.").arg(QFileInfo(path).fileName());
            qWarning() << error << library.errorString();
            return {{"error", error}};
        }
    }

    const auto imports = QDir(plugin.value("folder").toString()).filePath("imports");
    if (QDir(imports).exists())
        engine->addImportPath(imports);

    return {{"entry", plugin.value("entry")}};
}
