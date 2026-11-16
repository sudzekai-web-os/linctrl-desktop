import QtQuick

QtObject {
    id: root

    property string pending: ""
    property string error: ""
    property var callback: null
    readonly property bool busy: pending !== ""

    function send(method, path, body, completed) {
        if (busy)
            return false

        error = ""
        pending = ApiClient.request(method, path, body)
        if (!pending) {
            error = qsTr("Войдите на сервер, чтобы выполнить запрос.")
            return false
        }

        callback = completed || null
        return true
    }

    property Connections apiEvents: Connections {
        target: ApiClient
        function onRequestFinished(id, status, response, transportError) {
            if (id !== root.pending)
                return

            const completed = root.callback
            const result = ResponseEnvelope.read(status, response, transportError)
            root.pending = ""
            root.callback = null
            root.error = result.error
            if (!result.error && completed)
                completed(result.data)
        }
    }

    property Connections accountEvents: Connections {
        target: AccountSession
        function onAuthenticatedChanged() {
            if (!AccountSession.authenticated) {
                root.pending = ""
                root.callback = null
            }
        }
    }
}
