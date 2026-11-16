import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: credentials
    spacing: 12

    function submit() {
        if (!SignInState.busy) {
            SignInState.submit(login.text, password.text)
            password.clear()
        }
    }

    AppField {
        id: login
        Layout.fillWidth: true
        placeholderText: "Логин"
        onAccepted: password.forceActiveFocus()
    }

    AppField {
        id: password
        Layout.fillWidth: true
        placeholderText: "Пароль"
        echoMode: TextInput.Password
        onAccepted: credentials.submit()
    }

    RowLayout {
        DefaultButton {
            primary: true
            enabled: !SignInState.busy
            text: SignInState.busy ? "Вход…" : "Войти"
            onClicked: credentials.submit()
        }
        DefaultButton {
            text: "Другой сервер"
            onClicked: StartupFlow.switchServer()
        }
    }
}
