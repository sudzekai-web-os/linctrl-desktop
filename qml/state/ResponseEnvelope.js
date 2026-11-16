.pragma library

function read(status, response, transportError) {
    if ((status === 204 || status === 205) && !response.hasBody)
        return { data: null, error: "" }

    const json = response.json
    if (status >= 200 && status < 300 && json && json.success === true && "data" in json)
        return { data: json.data, error: "" }

    const message = json && json.success === false && json.error && json.error.message
    return { data: null, error: message || transportError
        || (status ? qsTr("Запрос завершился ошибкой (HTTP %1).").arg(status) : qsTr("Сервер недоступен.")) }
}
