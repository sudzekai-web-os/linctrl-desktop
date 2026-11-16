#include "ThemeFiles.h"


#include <QColor>
#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QJsonDocument>
#include <QJsonObject>
#include <QSettings>
#include <QStandardPaths>

namespace
{
    const QString BuiltinDirectory = QStringLiteral(":/qt/qml/linctrl/styles");

    QVariantMap readStyle(const QString &path)
    {
        if (path.isEmpty())
            return {};

        QFile file(path);
        if (!file.open(QIODevice::ReadOnly))
            return {};
        return QJsonDocument::fromJson(file.readAll()).object().toVariantMap();
    }

    void collectStyles(QVariantList &styles, const QString &path, bool overrideBuiltin = false)
    {
        const QDir directory(path);
        for (const auto &file : directory.entryList({"*.json"}, QDir::Files, QDir::Name))
        {
            const auto filePath = directory.filePath(file);
            const auto id = overrideBuiltin ? BuiltinDirectory + "/" + file : filePath;
            styles.append(QVariantMap{{"id", id}, {"document", readStyle(filePath)}});
        }
    }
}

QVariantMap ThemeFiles::sources() const
{
    QVariantList styles;
    collectStyles(styles, BuiltinDirectory);
    const auto installed = QDir(QCoreApplication::applicationDirPath()).filePath("styles");
    const auto local = QDir::current().absoluteFilePath("styles");
    collectStyles(styles, installed, true);
    if (local != installed)
        collectStyles(styles, local, true);
    collectStyles(styles, QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation) + "/styles");

    QSettings settings;
    const QString mode = settings.value("appearance/theme").toInt() == 1 ? "dark" : "light";
    const auto legacyPath = settings.value("appearance/file").toString();
    return {{"styles", styles}, {"mode", mode}, {"legacyPath", legacyPath}, {"legacy", readStyle(legacyPath)}, {"legacyName", QFileInfo(legacyPath).completeBaseName()}, {"legacySelection", settings.value("appearance/style")}};
}

bool ThemeFiles::validColor(const QString &color) const
{
    return QColor::isValidColorName(color);
}
