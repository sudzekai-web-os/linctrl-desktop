#pragma once

#include <QVariant>

namespace PluginCatalog
{
    struct Result
    {
        QVariantMap entries;
        QVariantList items;
        QString error;
    };

    Result scan(const QString &directory);
}
