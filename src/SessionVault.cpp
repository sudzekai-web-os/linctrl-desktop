#include "SessionVault.h"
#include "AppData.h"

#include <QJsonDocument>

#ifdef Q_OS_WIN
#include <windows.h>
#include <wincrypt.h>

namespace
{
    QByteArray protect(const QByteArray &input, bool encrypt)
    {
        DATA_BLOB source{static_cast<DWORD>(input.size()),
            reinterpret_cast<BYTE *>(const_cast<char *>(input.constData()))};
        DATA_BLOB result{};
        const auto success = encrypt
            ? CryptProtectData(&source, nullptr, nullptr, nullptr, nullptr, CRYPTPROTECT_UI_FORBIDDEN, &result)
            : CryptUnprotectData(&source, nullptr, nullptr, nullptr, nullptr, CRYPTPROTECT_UI_FORBIDDEN, &result);
        if (!success)
            return {};

        const QByteArray output(reinterpret_cast<const char *>(result.pbData), result.cbData);
        SecureZeroMemory(result.pbData, result.cbData);
        LocalFree(result.pbData);
        return output;
    }
}
#endif

QJsonObject SessionVault::read()
{
#ifdef Q_OS_WIN
    const auto encrypted = QByteArray::fromBase64(AppData::read("authentication").value("protected").toString().toLatin1());
    if (!encrypted.isEmpty())
        return QJsonDocument::fromJson(protect(encrypted, false)).object();
#endif
    return {};
}

bool SessionVault::write(const QJsonObject &session)
{
#ifdef Q_OS_WIN
    if (!session.isEmpty())
    {
        const auto encrypted = protect(QJsonDocument(session).toJson(QJsonDocument::Compact), true);
        return !encrypted.isEmpty()
            && AppData::write("authentication", {{"protected", QString::fromLatin1(encrypted.toBase64())}});
    }
#endif
    return AppData::write("authentication", {});
}
