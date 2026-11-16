.pragma library

function errorText(status, message) {
    if (message)
        return message
    switch (status) {
    case 401: return qsTr("Неверный логин или пароль либо учётная запись недоступна.")
    case 403: return qsTr("Учётная запись заблокирована.")
    case 429: return qsTr("Слишком много попыток входа. Повторите позже.")
    case 0: return qsTr("Не удалось подключиться к выбранному серверу.")
    default: return qsTr("Сервер не подтвердил вход (HTTP %1).").arg(status)
    }
}
