import QtQuick
import QtQuick.Controls.Basic

Row {
    id: root
    required property Window window
    function maximizeButton() { return captionButtons.itemAt(1) }
    anchors.right: parent.right
    height: parent.height

    Repeater {
        id: captionButtons
        model: ["Свернуть", "Развернуть или восстановить", "Закрыть"]

        Button {
            id: control
            required property int index
            required property string modelData

            width: 44
            height: root.height
            Accessible.name: modelData

            contentItem: Item {
                DashIcon {
                    anchors.centerIn: parent
                    visible: control.index === 0
                    stroke: Theme.palette.ink
                }

                FullscreenIcon {
                    anchors.centerIn: parent
                    visible: control.index === 1 && root.window.visibility !== Window.Maximized
                    stroke: Theme.palette.ink
                }

                FullscreenExitIcon {
                    anchors.centerIn: parent
                    visible: control.index === 1 && root.window.visibility === Window.Maximized
                    stroke: Theme.palette.ink
                }

                XIcon {
                    anchors.centerIn: parent
                    visible: control.index === 2
                    stroke: Theme.palette.ink
                }
            }

            background: Rectangle {
                color: control.hovered || (control.index === 1 && WindowChrome.maximizeHovered)
                    ? Theme.palette.line : "transparent"
                border.width: control.activeFocus ? 1 : 0
                border.color: Theme.palette.accent
            }

            onClicked: {
                if (index === 0)
                    root.window.showMinimized();
                else if (index === 2)
                    root.window.close();
                else if (root.window.visibility === Window.Maximized)
                    root.window.showNormal();
                else
                    root.window.showMaximized();
            }
        }
    }
}
