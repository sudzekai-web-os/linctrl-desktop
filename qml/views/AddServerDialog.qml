import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

AppDialog {
    id: root
    signal serverAdded()
    property string message: ""

    title: "Добавить сервер"
    preferredWidth: 424

    function submit() {
        message = ServerCatalog.add(address.text, port.text, secure.checked)
        if (!message) {
            root.serverAdded()
            root.close()
        }
    }

    onOpened: {
        root.message = ""
        address.clear()
        port.clear()
        secure.checked = false
        address.forceActiveFocus()
    }
    onClosed: root.message = ""


    contentItem: ColumnLayout {
        spacing: 8

        AppText { text: "Домен или IP" }
        AppField {
            id: address
            Layout.fillWidth: true
            placeholderText: "server.example.com"
            onAccepted: root.submit()
        }

        AppText {
            Layout.topMargin: 4
            text: "Порт (необязательно)"
        }
        AppField {
            id: port
            Layout.fillWidth: true
            placeholderText: secure.checked ? "443" : "5199"
            inputMethodHints: Qt.ImhDigitsOnly
            onAccepted: root.submit()
        }

        CheckBox { id: secure; text: "HTTPS" }

        AppText {
            Layout.fillWidth: true
            visible: text.length > 0
            text: root.message
            color: Theme.palette.accent
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight
            Layout.topMargin: 8

            DefaultButton {
                text: "Отмена"
                onClicked: root.close()
            }
            DefaultButton {
                primary: true
                enabled: address.text.trim().length > 0
                text: "Добавить"
                onClicked: root.submit()
            }
        }
    }
}
