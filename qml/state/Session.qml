pragma Singleton
import QtQuick
import "ResponseEnvelope.js" as Envelope

QtObject {
    id: root

    readonly property string endpoint: StartupFlow.endpoint
    readonly property string address: StartupFlow.server.address || ""
    readonly property int port: StartupFlow.server.port || 0
    readonly property string name: AccountSession.name
    readonly property string role: AccountSession.role
    readonly property string userId: AccountSession.userId
    readonly property int roleId: AccountSession.roleId
    readonly property bool authenticated: AccountSession.authenticated
    readonly property bool administrator: AccountSession.administrator

    signal requestFinished(string id, int status, var data, string error)

    function request(method, path, body) {
        return ApiClient.request(method, path, body)
    }

    property Connections apiEvents: Connections {
        target: ApiClient
        function onRequestFinished(id, status, response, error) {
            const result = Envelope.read(status, response, error)
            root.requestFinished(id, status, result.data, result.error)
        }
    }
}
