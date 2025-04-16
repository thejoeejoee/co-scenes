import QtQuick

Rectangle {
    property alias text: textField.text

    width: 300
    height: 60
    color: "#FE5900"
    radius: 2

    Text {
        id: textField
        fontSizeMode: Text.Fit
        minimumPixelSize: 10;
        font.pixelSize: 72
        anchors.fill: parent
        color: "white"
        padding: 10
    //     bold
        font.family: "Arial"
        font.weight: Font.Bold
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        textFormat: Text.PlainText
        wrapMode: Text.WordWrap
        text: qsTr("Hello, World!")
    }
}