#pragma once

#include <QVariant>

namespace ApiResponse
{
    QVariantMap read(const QByteArray &body, const QString &contentType);
}
