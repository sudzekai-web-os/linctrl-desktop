.pragma library

function roleLabel(role) {
    switch (role) {
    case "Administrator": return qsTr("Администратор")
    case "User": return qsTr("Пользователь")
    case "Viewer": return qsTr("Наблюдатель")
    default: return qsTr("Гость")
    }
}
