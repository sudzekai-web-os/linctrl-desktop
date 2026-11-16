import QtQuick
import QtQuick.Controls.Basic

DefaultButton {
    id: root

    required property url glyph
    required property string caption

    implicitWidth: 36
    horizontalPadding: 8
    opacity: enabled ? 1 : 0.48

    Accessible.name: caption
    ToolTip.text: caption
    ToolTip.visible: hovered
    ToolTip.delay: 400

    contentItem: Button {
        enabled: false
        focusPolicy: Qt.NoFocus
        padding: 0
        background: null
        display: AbstractButton.IconOnly

        icon.source: root.glyph
        icon.color: !root.enabled ? Theme.palette.muted : root.primary ? Theme.palette.onAccent : Theme.palette.ink
        icon.width: 16
        icon.height: 16
    }
}
