#include "AppData.h"

#include <QDir>
#include <QFile>
#include <QJsonDocument>
#include <QSaveFile>
#include <QStandardPaths>

namespace
{
    QString filePath()
    {
        return QDir(AppData::directory()).filePath("appdata.json");
    }

    QJsonObject readDocument()
    {
        QFile file(filePath());
        if (!file.open(QIODevice::ReadOnly))
            return {};

        return QJsonDocument::fromJson(file.readAll()).object();
    }
}

QString AppData::directory()
{
    return QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
}

QJsonObject AppData::read(const QString &block)
{
    return readDocument().value(block).toObject();
}

bool AppData::write(const QString &block, const QJsonObject &value)
{
    if (!QDir().mkpath(directory()))
        return false;

    auto document = readDocument();
    document.insert(block, value);
    const auto bytes = QJsonDocument(document).toJson();
    QSaveFile file(filePath());
    return file.open(QIODevice::WriteOnly)
        && file.setPermissions(QFileDevice::ReadOwner | QFileDevice::WriteOwner)
        && file.write(bytes) == bytes.size()
        && file.commit();
}
