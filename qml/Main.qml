import QtQuick

import "./CO" as CO

Window {
    width: 1280
    height: 720
    visible: true
    flags:  Qt.Window

    color:  "#FFFFFF"
    title: qsTr("oc")

    Row {
        spacing: 20

        CO.Symbol {
            implicitWidth: 750 * (120/661)
            implicitHeight: 661 * (120/661)
        }

        OBoxedText {
            height: 60
            text: "Iva Kavánková"
        }
    }

}
