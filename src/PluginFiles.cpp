#include "PluginFiles.h"
#include "AppData.h"
#include "PluginCatalog.h"
#include "PluginDataFiles.h"
#include "PluginLoader.h"

#include <QDir>
#include <QJsonObject>
#include <QQmlEngine>

PluginFiles *PluginFiles::create(QQmlEngine *engine, QJSEngine *)
{
    return new PluginFiles(engine);
}

PluginFiles::PluginFiles(QQmlEngine *engine)
    : m_engine(engine)
{
}

QString PluginFiles::directory() const
{
    return QDir(AppData::directory()).filePath("plugins");
}

QString PluginFiles::appDataDirectory() const
{
    return AppData::directory();
}

QVariantMap PluginFiles::find(const QString &id) const
{
    return m_entries.value(id).toMap();
}

QVariantMap PluginFiles::scan()
{
    auto result = PluginCatalog::scan(directory());
    m_entries = result.entries;
    return {{"items", result.items}, {"error", result.error}};
}

QVariantMap PluginFiles::load(const QString &id)
{
    return enabled(id) ? PluginLoader::load(m_engine, find(id)) : QVariantMap{};
}

bool PluginFiles::enabled(const QString &id) const
{
    return m_entries.contains(id) && AppData::read("plugins").value("enabled").toObject().value(id).toBool();
}

QString PluginFiles::readText(const QString &id, const QString &path) const
{
    return enabled(id) ? PluginDataFiles::readText(id, path) : QString{};
}

bool PluginFiles::writeText(const QString &id, const QString &path, const QString &text) const
{
    return enabled(id) && PluginDataFiles::writeText(id, path, text);
}
