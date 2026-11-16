pragma Singleton
import QtQuick

QtObject {
    id: root
    enum Stage { SelectServer, SignIn, Workspace }

    property int stage: StartupFlow.SelectServer
    property var server: ({})
    readonly property string endpoint: server.endpoint || ""
    property string message: ""

    function initialize() {
        const session = DesktopNetwork.restore()
        if (session.expiresAt && ServerCatalog.contains(session.server)) {
            server = session.server
            AccountSession.activate(session)
            stage = StartupFlow.Workspace
        } else {
            AccountSession.clear()
        }
    }

    function chooseServer(server) {
        root.server = server
        message = ""
        stage = StartupFlow.SignIn
    }

    function enterWorkspace() {
        message = ""
        stage = StartupFlow.Workspace
    }

    function switchServer() {
        leaveServer(StartupFlow.SelectServer)
    }

    function disconnectServer() {
        leaveServer(StartupFlow.Workspace)
    }

    function leaveServer(destination) {
        SignInState.reset()
        server = {}
        message = AccountSession.clear() ? "" : qsTr("Не удалось удалить сохранённую сессию.")
        stage = destination
    }

    property Connections accountEvents: Connections {
        target: AccountSession
        function onExpired(message) {
            SignInState.reset()
            root.message = message
            root.stage = StartupFlow.SignIn
        }
    }
}
