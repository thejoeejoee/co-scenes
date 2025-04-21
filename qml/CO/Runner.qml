import QtQuick

import "." as CO

Rectangle {
    id: runner

    property alias content: text.content
    property bool display: true

    property real size: 56
    property real textSlide: 0

    color: "white"

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
                ParallelAnimation {
                    NumberAnimation {
                        target: runner; property: "textSlide";
                        to: runner.size * 0.5;
                        duration: 100
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: text; property: "opacity";
                        to: 0;
                        duration: 100
                        easing.type: Easing.InOutQuad
                    }
                }
                PauseAnimation { duration: 50 }
                ParallelAnimation {
                    NumberAnimation {
                        target: symbol; property: "opacity";
                        to: 0;
                        duration: 100
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: text.bg; property: "opacity";
                        to: 0;
                        duration: 100
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        },
        Transition {
            from: "HIDDEN"
            to: "SHOW"
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation {
                        target: symbol; property: "opacity"
                        to: 1; duration: 100
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: text.bg; property: "opacity"
                        to: 1; duration: 100
                        easing.type: Easing.InOutQuad
                    }
                }
                PauseAnimation { duration: 50 }
                ParallelAnimation {
                    NumberAnimation {
                        target: runner; property: "textSlide"
                        to: 0; duration: 100
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: text; property: "opacity";
                        to: 1; duration: 100
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    ]

    Rectangle {
        id: symbol

        color: "#FE5900"

        width: runner.size
        height: runner.size

        CO.Control {
            color: "#EDECE3"

            width: runner.size * 0.75
            height: runner.size * 0.75

            anchors.centerIn: parent
        }
        // height: 48
        // width: symbol.height * (symbol.implicitWidth / symbol.implicitHeight)
    }

    CO.BoxedText {
        id: text

        color: "#EDECE3"
        bgColor: "#FE5900"
        size: runner.size

        anchors.verticalCenter: symbol.verticalCenter
        anchors.left: symbol.right
        anchors.leftMargin: runner.size * 0.25

        text.transform: Translate {
            x: runner.textSlide
        }
    }
}