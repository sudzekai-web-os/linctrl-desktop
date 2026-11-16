.pragma library

function sameServer(first, second) {
    return first.address === second.address && Number(first.port || 0) === Number(second.port || 0)
        && Boolean(first.secure) === Boolean(second.secure)
}

function add(catalog, network, storage, address, input, secure) {
    const host = network.normalizeHost(address)
    if (!host)
        return qsTr("Введите домен или IP-адрес без протокола.")

    const text = input.trim()
    const port = text ? Number(text) : 0
    if (text && (!/^[0-9]+$/.test(text) || !Number.isInteger(port) || port < 1 || port > 65535))
        return qsTr("Порт должен быть числом от 1 до 65535.")

    const endpoint = (secure ? "https://" : "") + (host.includes(":") ? "[" + host + "]" : host)
        + (port ? ":" + port : "")
    const server = { address: host, port: port, secure: Boolean(secure), endpoint: endpoint }
    if (catalog.contains(server))
        return qsTr("Этот сервер уже добавлен.")

    const servers = [...catalog.items, server]
    if (!storage.write("servers", { items: servers }))
        return qsTr("Не удалось сохранить сервер.")

    catalog.items = servers
    return ""
}
