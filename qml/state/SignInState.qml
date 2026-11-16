pragma Singleton
import QtQuick
import "SignInLogic.js" as Logic

QtObject {
    id: root

    property string pending: ""
    property string message: ""
    readonly property bool busy: pending !== ""

    function reset() {
        pending = ""
        message = ""
    }

    function submit(login, password) {
        if (busy || StartupFlow.stage !== StartupFlow.SignIn)
            return

        if (!login.trim() || !password) {
            message = qsTr("Введите логин и пароль.")
            return
        }

        StartupFlow.message = ""
        message = ""
        pending = DesktopNetwork.login(StartupFlow.server, login.trim(), password)
        if (!pending)
            message = Logic.errorText(0, "")
    }

    property Connections networkEvents: Connections {
        target: DesktopNetwork
        function onLoginFinished(id, status, session, error) {
            if (id !== root.pending)
                return

            root.pending = ""
            if (session.expiresAt) {
                AccountSession.activate(session)
                StartupFlow.enterWorkspace()
            } else {
                root.message = Logic.errorText(status, error)
            }
        }
    }
}
