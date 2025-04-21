import QtQuick

Item {
    id: component

    property real hPadding: 8
    property real vPadding: 8

    property alias content: text.text
    property alias size: component.height
    property alias color: text.color

    property alias text: text
    property alias bg: background
    property alias bgColor: background.color
    property alias bgOpacity: background.opacity

    FontMetrics {
        id: fm
        font.pixelSize: component.height - 2 * component.vPadding
    }

    Rectangle {
        id: background
        height: component.height
        width: text.width + 2 * component.hPadding

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        id: text

        antialiasing: true
        font.pixelSize: component.height - 2 * component.vPadding

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: component.hPadding
    }

    // Item {
    //     id: wrapper
    //
    //     width: parent.width
    //     height: parent.height
    //
    //
    // }
}

// Rectangle {
//     property alias text: text.text
//     property bool withSymbol: false
//
//     height: text.implicitHeight
//     width: text.implicitWidth
//     color: "#FE5900"
//     radius: 2
//
//     Row {
//         width: text.implicitWidth
//         height: text.implicitHeight
//
//         spacing: 0
//         anchors.fill: parent
//
//         Symbol {
//             visible: withSymbol
//             height: text.height
//         }
//
//         Text {
//             id: text
//             font.pixelSize: 24
//
//             color: "white"
//
//             font.family: "Arial"
//             font.weight: Font.Bold
//             horizontalAlignment: Text.AlignHCenter
//             verticalAlignment: Text.AlignVCenter
//             textFormat: Text.PlainText
//             wrapMode: Text.WordWrap
//         }
//     }
// }