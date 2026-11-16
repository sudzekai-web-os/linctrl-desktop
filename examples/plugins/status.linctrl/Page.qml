import QtQuick
import QtQuick.Layouts
import linctrl

Item {
    id: root

    property string message: ""

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 24
        spacing: 12

        SectionHeading {
            title: "Состояние подключения"
            description: Session.endpoint || "Работа без сервера"
        }

        DefaultButton {
            text: "Сохранить адрес"
            enabled: Session.endpoint.length > 0
            onClicked: {
                root.message = Plugins.writeText("example.status", "server.txt", Session.endpoint)
                    ? "Адрес сохранён." : "Не удалось сохранить адрес."
            }
        }

        AppText {
            Layout.fillWidth: true
            text: root.message
        }
    }
}
