import QtQuick 2.2

Rectangle {
    property bool working: true

    width: 100
    height: 62
    color: '#FFFFAA'
    Text {
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: units.fingerUnit
        text: qsTr('En contrucció...')
    }
}
