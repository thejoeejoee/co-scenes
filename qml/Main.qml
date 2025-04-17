import QtQuick
import QtQuick.Layouts

import "./CO" as CO

Window {
    id: root
    width: 1280
    height: 720
    visible: true
    flags: Qt.Window

    color: "#EDECE3"
    title: qsTr("CO scenes")

    property bool display: true

    Rectangle {
        id: runner

        property real textSlide: 0

        color: "white"
        x: 24
        y: 24

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
                            to: 24; duration: 100
                            easing.type: Easing.InOutQuad
                        }
                        NumberAnimation {
                            target: text; property: "opacity";
                            to: 0; duration: 100
                            easing.type: Easing.InOutQuad
                        }
                    }
                    PauseAnimation { duration: 50 }
                    ParallelAnimation {
                        NumberAnimation {
                            target: symbol; property: "opacity";
                            to: 0; duration: 100
                            easing.type: Easing.InOutQuad
                        }
                        NumberAnimation {
                            target: text.bg; property: "opacity";
                            to: 0; duration: 100
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

        CO.Symbol {
            id: symbol

            color: "red"

            height: 56
            width: symbol.height * (symbol.implicitWidth / symbol.implicitHeight)
        }

        CO.BoxedText {
            id: text

            content: "Iva Kavánková"
            color: "#EDECE3"
            bgColor: "#FE5900"
            size: 56

            anchors.left: symbol.right

            text.transform: Translate {
                x: runner.textSlide
            }
        }
    }


    Shortcut {
        sequence: "H"
        onActivated: {
            root.display = !root.display
        }
    }


}
