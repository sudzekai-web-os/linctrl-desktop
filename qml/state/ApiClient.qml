pragma Singleton
import QtQuick

QtObject {
    id: root

    signal requestFinished(string id, int status, var response, string error)

    function request(method, path, body) {
        if (!AccountSession.authenticated)
            return ""
        if (AccountSession.profile.expiresAt * 1000 <= Date.now()) {
            AccountSession.expire()
            return ""
        }
        return DesktopNetwork.request(method, path, body || {})
    }

    property Connections networkEvents: Connections {
        target: DesktopNetwork
        function onResponseFinished(id, status, response, error) {
            root.requestFinished(id, status, response, error)
            if (status === 401)
                AccountSession.expire()
        }
    }
}
