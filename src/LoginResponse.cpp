#include "LoginResponse.h"
#include "ResponseEnvelope.h"

#include <QDateTime>
#include <limits>

LoginResponse LoginResponse::read(int status, const QByteArray &body)
{
    const auto envelope = ResponseEnvelope::read(status, body);
    const auto profile = envelope.data.toObject();
    const auto seconds = profile.value("expiresIn").toInteger();

    if (status != 200 || !envelope.success
        || profile.value("tokenType").toString().compare("Bearer", Qt::CaseInsensitive) != 0
        || seconds <= 0 || seconds > std::numeric_limits<int>::max())
        return {{}, 0, {}, envelope.error};

    return {profile.value("token").toString(), QDateTime::currentSecsSinceEpoch() + seconds, profile, {}};
}
