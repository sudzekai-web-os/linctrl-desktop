#include "ResponseEnvelope.h"

#include <QJsonDocument>
#include <QJsonObject>

ResponseEnvelope ResponseEnvelope::read(int status, const QByteArray &body)
{
    if ((status == 204 || status == 205) && body.isEmpty())
        return {true, QJsonValue::Null, {}};

    const auto document = QJsonDocument::fromJson(body);
    if (!document.isObject())
        return {};

    const auto envelope = document.object();
    const auto success = envelope.value("success");
    if (status >= 200 && status < 300 && success.isBool() && success.toBool() && envelope.contains("data"))
        return {true, envelope.value("data"), {}};

    if (status >= 400 && success.isBool() && !success.toBool())
        return {false, {}, envelope.value("error").toObject().value("message").toString()};

    return {};
}
