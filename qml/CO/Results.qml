import QtQuick

import "." as CO


Item {
    id: root
    property alias w: root.width
    property alias h: root.height

    property bool display: false
    property real headerH: 48

    property alias model: list.model

    state: display ? "SHOW" : "HIDDEN"

    states: [
        State {name: "SHOW"},
        State {name: "HIDDEN"}
    ]

    transitions: [
        Transition {
            from: "SHOW"
            to: "HIDDEN"
            SequentialAnimation {
                // PropertyAction {
                //     target: list
                //     property: "model"
                //     value: root.emptyList
                // }
                NumberAnimation {
                    target: root;
                    property: "opacity"
                    to: 0;
                    duration: 100
                    easing.type: Easing.InOutQuad
                }
            }
        },
        Transition {
            from: "HIDDEN"
            to: "SHOW"
            SequentialAnimation {
                NumberAnimation {
                    target: root
                    property: "opacity"
                    to: 1
                    duration: 100
                    easing.type: Easing.InOutQuad
                }
                // PropertyAction {
                //     target: list
                //     property: "model"
                //     value: root.demoList
                // }
            }
        }
    ]

    FontLoader { id: webFont; source: "https://fonts.gstatic.com/s/robotomono/v23/L0xuDF4xlVMF-BfR8bXMIhJHg45mwgGEFl0_7Pq_ROW4AJi8SJQt.woff2" }

    Rectangle {
        id: header

        width: root.width
        height: root.headerH

        color: "#3b4f3c"

        CO.Symbol {
            id: symbol
            anchors.left: header.left
            anchors.leftMargin: -root.headerH / 1.5
            anchors.verticalCenter: header.verticalCenter

            height: root.headerH * 2
            width: root.headerH * 2 * (symbol.implicitWidth / symbol.implicitHeight)

            antialiasing: true
        }

        CO.BoxedText {
            id: results
            content: "RESULTS"
            size: root.headerH
            color: "#EDECE3"
            // bgColor: "#3b4f3c"
            bgColor: "transparent"
            text.font.letterSpacing: 2

            anchors.left: symbol.right
            anchors.leftMargin: -root.headerH / 2
        }

        CO.BoxedText {
            id: finish
            content: "<b>FINISH</b>"
            size: root.headerH
            color: "#FE5900"
            // bgColor: "#3b4f3c"
            bgColor: "transparent"
            text.font.letterSpacing: 8
            text.horizontalAlignment: Text.AlignHCenter
            width: finish.bg.width

            anchors.right: header.right
        }
    }

    Rectangle {
        id: bg
        color: "#EDECE3"
        width: root.width
        height: root.headerH * root.model.count
        anchors.top: root.top
        anchors.topMargin: root.headerH
        anchors.horizontalCenter: root.horizontalCenter
        z: -1
        Component.onCompleted: {
            console.log("bg width: " + bg.width)
            console.log("bg height: " + bg.height)
            console.log("root.headerH * root.model.count " + root.headerH * root.model.count)
        }
    }


    // CO.Symbol {
    //     id: symbol
    //     anchors.right: header.right
    //     anchors.rightMargin: -root.headerH / 2
    //     anchors.verticalCenter: header.verticalCenter
    //
    //     height: root.headerH * 2
    //     width: root.headerH * 2 * (symbol.implicitWidth / symbol.implicitHeight)
    //
    //     antialiasing: true
    // }



    Component {
        id: rowDelegate
        Item {
            id: row
            required property int index
            required property string name
            required property string time
            width: root.width
            height: root.headerH

            CO.BoxedText {
                property bool isTop: index < 3

                id: position
                color: isTop ? "#FE5900" : "#3b4f3c"
                bgColor: "#EDECE3"
                size: root.headerH
                content: index + 1
                width: 56 * 0.75
                text.anchors {
                    verticalCenter: position.verticalCenter
                    left: position.left
                    right: position.right
                }

                text.horizontalAlignment: Text.AlignHCenter
                text.font.weight: Font.Bold
                vPadding: 10
            }

            CO.BoxedText {
                id: nameText
                color: "#3b4f3c"
                bgColor: "#EDECE3"
                size: root.headerH
                content: name
                anchors.left: position.right
                anchors.leftMargin: 8
            }



            CO.BoxedText {
                id: timeText
                color: "#3b4f3c"
                bgColor: "#EDECE3"
                size: root.headerH
                content: time
                // monospace
                text.font.family: webFont.font.family
                text.horizontalAlignment: Text.AlignRight
                width: timeText.text.width + 2 * timeText.hPadding
                anchors {
                    right: row.right
                    rightMargin: 0
                }
            }


            Image {
                source: "qrc:/assets/flag-" + (index % 3) + ".svg"
                height: root.headerH
                width: root.headerH * (3/2)
                anchors.verticalCenter: nameText.verticalCenter
                anchors.right: timeText.left
                anchors.rightMargin: root.headerH / 4

                visible: index != -1
            }

            Rectangle {
                id: border
                color: "#3b4f3c"
                width: row.width
                height: 1
                anchors.horizontalCenter: row.horizontalCenter
                anchors.top: row.top
                anchors.topMargin: 0
            }
        }
    }

    ListView {
        id: list
        width: root.w
        height: root.h - root.headerH
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: header.horizontalCenter

        model: root.model
        delegate: rowDelegate

        populate: Transition {
            id: _popuTrans
            SequentialAnimation {
                PropertyAction { property: "scale"; value: 0.0 }
                PauseAnimation { duration: 200 * _popuTrans.ViewTransition.index }
                NumberAnimation { property: "scale"; from: 0.0; to: 1.0; duration: 200; easing.type: Easing.InOutQuad }
            }
        }

        add: Transition {
            NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 200 }
        }
    }
}

