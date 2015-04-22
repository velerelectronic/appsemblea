import QtQuick 2.2
// import QtWebKit 3.0

Flickable {
    id: singleitemview

    property alias titol: textTitol.text
    property alias continguts: textContinguts.text
//    property string continguts: ''
    property string enllac
    property string copiaTitol
    property string copiaContingut
    property string copiaEnllac

    contentWidth: width
    contentHeight: columnaSingleItem.height
    clip: true

    Column {
        id: columnaSingleItem
        width: parent.width
        height: titol.height + units.readUnit + continguts.height
        spacing: units.readUnit

        Rectangle {
            id: titol
            anchors.left: parent.left
            anchors.right: parent.right
            height: textTitol.paintedHeight
            Text {
                id: textTitol
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                font.bold: true
                textFormat: Text.RichText
                font.pixelSize: Math.round(units.readUnit * 1.5)
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }
        }
        Rectangle {
            id: continguts
            anchors.left: parent.left
            anchors.right: parent.right
            height: textContinguts.contentHeight
            Text {
                id: textContinguts
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                font.pixelSize: units.readUnit
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                textFormat: Text.RichText
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }
    }

    function situaAlPrincipi() {
        contentY = 0;
        contentX = 0;
    }
}
