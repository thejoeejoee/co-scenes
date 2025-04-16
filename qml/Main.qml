import QtQuick

Window {
    width: 1280
    height: 720
    visible: true
    flags:  Qt.Window

    color:  "#FFFFFF"
    title: qsTr("EYOC")

    Row {
        spacing: 20

        OCOSymbol {
            implicitWidth: 750 * (120/661)
            implicitHeight: 661 * (120/661)
        }

        OBoxedText {
            height: 60
            text: "Iva Kavánková"
        }
    }

}
