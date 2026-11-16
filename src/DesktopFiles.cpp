#include "DesktopFiles.h"

#include <QFile>
#include <QFileInfo>
#include <QSaveFile>

namespace
{
    constexpr qint64 transferLimit = 8 * 1024 * 1024;
}

QVariantMap DesktopFiles::read(const QUrl &url) const
{
    const auto path = url.toLocalFile();
    QFile file(path);
    if (!url.isLocalFile() || !QFileInfo(path).isFile() || !file.open(QIODevice::ReadOnly))
        return {{"error", tr("Не удалось открыть локальный файл.")}};

    if (file.size() > transferLimit)
        return {{"error", tr("Файл превышает 8 МиБ.")}};

    const auto bytes = file.read(transferLimit + 1);
    if (bytes.size() > transferLimit)
        return {{"error", tr("Файл превышает 8 МиБ.")}};
    if (file.error() != QFile::NoError)
        return {{"error", tr("Не удалось прочитать локальный файл.")}};

    return {{"name", QFileInfo(path).fileName()}, {"content", QString::fromLatin1(bytes.toBase64())}};
}

QString DesktopFiles::save(const QUrl &url, const QString &content) const
{
    const auto decoded = QByteArray::fromBase64Encoding(content.toLatin1(), QByteArray::AbortOnBase64DecodingErrors);
    if (!url.isLocalFile() || !decoded || decoded.decoded.size() > transferLimit)
        return tr("Не удалось подготовить файл к сохранению.");

    QSaveFile file(url.toLocalFile());
    if (!file.open(QIODevice::WriteOnly) || file.write(decoded.decoded) != decoded.decoded.size() || !file.commit())
        return tr("Не удалось сохранить локальный файл.");

    return {};
}
