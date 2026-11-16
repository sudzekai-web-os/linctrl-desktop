import QtQuick
import QtQuick.Layouts
import linctrl

Item {
    QtObject {
        id: viewModel

        property int result: 0
        property bool saveFailed: false

        Component.onCompleted: {
            const saved = Number(Plugins.readText("example.dice", "last-roll.txt"))
            if (Number.isInteger(saved) && saved >= 1 && saved <= 6)
                result = saved
        }

        function roll() {
            result = 1 + Math.floor(Math.random() * 6)
            saveFailed = !Plugins.writeText("example.dice", "last-roll.txt", String(result))
        }
    }

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 24
        spacing: 16

        SectionHeading {
            title: "Кубик"
        }

        AppCard {
            Layout.fillWidth: true
            implicitHeight: panel.implicitHeight + 32

            ColumnLayout {
                id: panel
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                AppText {
                    text: viewModel.result ? "Последний бросок: " + viewModel.result : "Бросков пока нет"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                }
                DefaultButton {
                    primary: true
                    text: "Бросить кубик"
                    onClicked: viewModel.roll()
                }
                AppText {
                    visible: viewModel.saveFailed
                    text: "Не удалось сохранить результат."
                    color: Theme.palette.accent
                }
            }
        }
    }
}
