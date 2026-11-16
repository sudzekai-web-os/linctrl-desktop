
import QtQuick
import QtQuick.Effects

Item {
    id: root

    width: 16
    height: 16

    property color stroke: "white"

    Item {
        id: backSource
        anchors.fill: parent
        visible: false
        layer.enabled: true

        Rectangle {
            x: 3
            y: 1
            width: 13
            height: 13
            radius: 5

            color: "transparent"
            border.color: root.stroke
            border.width: 2
        }
    }

    Item {
        id: maskSourceItem
        anchors.fill: parent
        visible: false
        layer.enabled: true

        Rectangle {
            x: 1
            y: 3
            width: 12
            height: 12
            radius: 5

            color: "white"
        }
    }

    MultiEffect {
        anchors.fill: parent

        source: backSource
        maskEnabled: true
        maskSource: maskSourceItem
        maskInverted: true
        maskThresholdMin: 0
        maskSpreadAtMin: 0
    }

    Rectangle {
        x: 1
        y: 3
        width: 13
        height: 13
        radius: 5

        color: "transparent"
        border.color: root.stroke
        border.width: 2
    }
}
