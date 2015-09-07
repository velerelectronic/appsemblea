import QtQuick 2.0

Rectangle {
    id: detailDelegate

    property string titol
    property string contingut
    property string enllac

    property string copiaTitol: titol
    property string copiaContingut: contingut
    property string copiaEnllac: enllac
    property alias openExternally: singleItem.openExternally

    signal linkActivated(string link)

    SingleItemView {
        id: singleItem
        anchors.fill: parent

        property real lastY: 0
        onMovementStarted: lastY = contentY
        onContentYChanged: {
            if (!flickingVertically) {
                if (contentY<lastY)
                    shareButtons.visible = true;
                else {
                    shareButtons.visible = false;
                }
                lastY = contentY;
            }
        }
        onMovementEnded: {
            if ((atYBeginning)||(atYEnd)) {
                lastY = contentY;
                shareButtons.visible = true;
            }
        }

        onLinkActivated: detailDelegate.linkActivated(link)

        titol: detailDelegate.titol
        continguts: detailDelegate.contingut
        enllac: detailDelegate.enllac
        copiaTitol: detailDelegate.copiaTitol
        copiaContingut: detailDelegate.copiaContingut
        copiaEnllac: detailDelegate.copiaEnllac

        bottomMargin: shareButtons.height
    }
    Rectangle {
        id: shareButtons

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: units.fingerUnit * 1.5
        ListView {
            anchors.fill: parent
            orientation: ListView.Horizontal
            spacing: units.nailUnit
            model: VisualItemModel {
                Button {
                    color: '#0040FF'
                    textColor: 'white'
                    text: qsTr('Facebook')
                    onClicked: {
                        console.log(singleItem.enllac);
                        Qt.openUrlExternally('https://www.facebook.com/sharer/sharer.php?u=' + encodeURIComponent(singleItem.enllac));
                    }
                }
                Button {
                    color: '#2ECCFA'
                    text: qsTr('Twitter')
                    onClicked: Qt.openUrlExternally('http://twitter.com/intent/tweet?text=' + encodeURIComponent(singleItem.titol + ' ' + singleItem.enllac) + '&url=undefined')
                }
                Button {
                    color: '#FE2E2E'
                    textColor: 'white'
                    text: qsTr('Google Plus')
                    onClicked: Qt.openUrlExternally('https://plus.google.com/share?url=' + singleItem.enllac)
                }
                Button {
                    color: 'white'
                    textColor: 'black'
                    text: qsTr('Correu')
                    onClicked: Qt.openUrlExternally('mailto:?subject=' + encodeURIComponent('[Appsemblea] ' +singleItem.titol) + '&body=' + encodeURIComponent(singleItem.enllac))
                }
            }
        }
    }
}
