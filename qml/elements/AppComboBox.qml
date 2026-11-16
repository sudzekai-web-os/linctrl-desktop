import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Shapes

ComboBox {
    id: control

    implicitHeight: 40
    leftPadding: 12
    rightPadding: 36
    hoverEnabled: true

    contentItem: AppText {
        text: control.displayText
        color: control.enabled ? Theme.palette.ink : Theme.palette.muted
        wrapMode: Text.NoWrap
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }

    indicator: Shape {
        x: control.width - 28
        y: (control.height - height) / 2
        width: 16
        height: 16

        ShapePath {
            strokeColor: control.enabled ? Theme.palette.ink : Theme.palette.muted
            strokeWidth: 1.5
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            startX: 4
            startY: 6
            PathLine { x: 8; y: 10 }
            PathLine { x: 12; y: 6 }
        }
    }

    background: Rectangle {
        radius: 8
        color: control.enabled && (control.hovered || control.down) ? Theme.palette.background : Theme.palette.surface
        border.color: control.activeFocus || control.popup.visible ? Theme.palette.accent : Theme.palette.line
    }

    delegate: AppMenuItem {
        required property int index
        required property var modelData

        width: ListView.view ? ListView.view.width : control.width
        text: control.textRole ? String(modelData[control.textRole] ?? "") : String(modelData ?? "")
        selected: index === control.currentIndex
        highlighted: index === control.highlightedIndex
    }

    popup: Popup {
        y: control.height + 4
        width: control.width
        padding: 4
        height: Math.min(contentItem.contentHeight + topPadding + bottomPadding, 248)

        contentItem: ListView {
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            model: control.delegateModel
            currentIndex: control.highlightedIndex
        }

        background: AppCard { radius: 8 }
    }
}
