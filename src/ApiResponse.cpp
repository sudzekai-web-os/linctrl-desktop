#include "ApiResponse.h"

#include <QJsonValue>

QVariantMap ApiResponse::read(const QByteArray &body, const QString &contentType)
{
    QVariantMap response{{"body", body}, {"hasBody", !body.isEmpty()}, {"contentType", contentType}};
    const auto mediaType = contentType.section(';', 0, 0).trimmed().toLower();

    if (mediaType == "application/json" || mediaType.endsWith("+json"))
    {
        const auto json = QJsonValue::fromJson(body);
        if (!json.isUndefined())
            response.insert("json", json.toVariant());
    }
    else if (mediaType.startsWith("text/"))
    {
        response.insert("text", QString::fromUtf8(body));
    }

    return response;
}
