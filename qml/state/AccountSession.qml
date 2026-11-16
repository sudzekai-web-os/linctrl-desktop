pragma Singleton
import QtQuick
import "AccountLogic.js" as Logic

QtObject {
    id: root

    property var profile: ({})
    readonly property string name: profile.name || qsTr("Локальный пользователь")
    readonly property string role: Logic.roleLabel(profile.role)
    readonly property string userId: profile.userId || ""
    readonly property int roleId: profile.roleId || 0
    readonly property bool authenticated: (profile.expiresAt || 0) > 0
    readonly property bool administrator: authenticated && roleId === 1

    signal expired(string message)

    function activate(session) {
        profile = session
        expiryTimer.interval = Math.min(2147483647, Math.max(1, session.expiresAt * 1000 - Date.now()))
        expiryTimer.restart()
    }

    function clear() {
        expiryTimer.stop()
        profile = {}
        return DesktopNetwork.clear()
    }

    function expire() {
        if (authenticated)
            expired(clear() ? qsTr("Срок действия сессии истёк. Войдите снова.")
                            : qsTr("Не удалось удалить сохранённую сессию."))
    }

    property Timer expiryTimer: Timer {
        onTriggered: root.expire()
    }
}
