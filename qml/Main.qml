import QtQuick
import QtQuick.Layouts

import "./CO" as CO

Window {
    id: root
    // width: 1280
    // height: 720

    width: 1920
    height: 1080
    visible: true
    flags: Qt.Window

    // color: "#EDECE3"
    color: "#FDFDFD"
    title: qsTr("Český Orienťák | scenes")
    FontLoader { id: webFont; source: "https://fonts.gstatic.com/s/robotomono/v23/L0xuDF4xlVMF-BfR8bXMIhJHg45mwgGEFl0_7Pq_ROW4AJi8SJQt.woff2" }

    property bool runnerDisplay: false
    property bool resultsDisplay: false
    property real size: 64

    property var demoList: CO.DemoList {}
    property var emptyList: ListModel {}

    property var model: ListModel {}

    CO.Runner {
        x: 2 * root.size
        y: root.height - 3 * root.size
        // content: "Iva Kavánková"
        content: "Šimon Mareček"
        display: root.runnerDisplay
        size: root.size
    }

    CO.Results {
        x: 8 * root.size
        y: 2 * root.size

        w: root.width - 16 * root.size
        h: root.height - 2 * root.size

        display: root.resultsDisplay
        model: root.model
    }

    Shortcut {
        sequence: "H"
        onActivated: {
            root.runnerDisplay = !root.runnerDisplay
        }
    }
    Shortcut {
        sequence: "S"
        onActivated: {
            if (root.resultsDisplay) {
                root.resultsDisplay = false
                root.model.clear()
            } else {
                root.resultsDisplay = true
                for (var i = 0; i < root.demoList.count; i++) {
                    root.model.append(root.demoList.get(i))
                }
            }
        }
    }
}

// Timer {
//     property var started : new Date()
//     interval: 100; running: true; repeat: true
//     Component.onCompleted: {
//         runner.started = new Date()
//     }
//     onTriggered: {
//         // time.content = Date().toString()
//         var elapsed = (new Date()) - runner.started
//         var minutes = Math.floor(elapsed / 60000)
//         var seconds = Math.floor((elapsed % 60000) / 1000)
//         var milliseconds = Math.floor((elapsed % 1000) / 10)
//         // MM:SS.m
//         time.content = minutes.toString().padStart(2, '0') + ":" +
//             seconds.toString().padStart(2, '0') + "." +
//             milliseconds.toString().padStart(1, '0').slice(0, 1)
//     }
// }

// CO.BoxedText {
//     id: time
//
//     anchors.verticalCenter: text.verticalCenter
//     anchors.left: text.right
//     anchors.leftMargin: 14
//
//     content: "00:00.000"
//     color: "#EDECE3"
//     bgColor: "#FE5900"
//     size: 56
//
//     // TODO: monospace
//     text.font.family: webFont.font.family
//     text.font.styleName: webFont.font.styleName
//     text.font.weight: webFont.font.weight
//
//     // monospace
//
//     hPadding: 12
// }
