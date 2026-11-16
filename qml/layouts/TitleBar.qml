import QtQuick
import QtQuick.Controls.Basic

Rectangle {
    id: root
    required property Window window
    color: Theme.palette.surface
    Component.onCompleted: {
        if (visible)
            WindowChrome.attach(window, root, buttonRow, buttonRow.maximizeButton(), brandIcon)
    }

    DragHandler {
        enabled: !WindowChrome.active
        target: null
        onActiveChanged: if (active)
            root.window.startSystemMove()
    }
    TapHandler {
        enabled: !WindowChrome.active
        onDoubleTapped: root.window.visibility === Window.Maximized ? root.window.showNormal() : root.window.showMaximized()
    }
    Text {
        anchors.left: parent.left
        anchors.leftMargin: 56
        anchors.verticalCenter: parent.verticalCenter
        text: "LinCtrl"
        font.pixelSize: 15
        font.weight: Font.DemiBold
        color: Theme.palette.ink
    }
    Rectangle {
        id: brandIcon
        x: 16
        anchors.verticalCenter: parent.verticalCenter
        width: 24
        height: 24
        radius: 6
        color: Theme.palette.accent
        Text {
            anchors.centerIn: parent
            text: "L"
            color: Theme.palette.onAccent
            font.bold: true
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: Theme.palette.line
    }

    WindowButtons {
        id: buttonRow
        window: root.window
        anchors.right: parent.right
        height: parent.height
    }
}
