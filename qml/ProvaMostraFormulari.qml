import QtQuick 2.3
import QtWebKit 3.0
import 'qrc:///Core/core' as Core


Rectangle {
    id: formularis
    color: 'transparent'
    anchors.margins: units.nailUnit

    signal goBack()

    Core.UseUnits { id: units }

    Core.MainBar {
        id: mainBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        pageTitle: qsTr('Formularis')
        onGoBack: formularis.goBack()
    }

    Text {
        id: formTitle
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: mainBar.bottom
        height: Math.max(contentHeight,units.fingerUnit)
        text: ((formLoader.item) && (formLoader.item.title))?formLoader.item.title:''
        font.pixelSize: units.readUnit
        font.bold: true
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    }

    WebView {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: formTitle.bottom
        anchors.bottom: parent.bottom
        Component.onCompleted: {
            console.log('web view');
            var html = "<h1>Hola</h1><form><input type=\"text\"></form><p>Com va?</p>";
            loadHtml(html,"","");
        }
    }

    Flickable {
        id: flickLoader

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: formTitle.bottom
        anchors.bottom: parent.bottom
        visible: false

        clip: true
        flickableDirection: Flickable.VerticalFlick

        contentHeight: formLoader.height

        Loader {
            id: formLoader
            anchors.left: parent.left
            anchors.right: parent.right

            source: 'qrc:///qml/Prova.qml'

            onStatusChanged: {
                if (status == Loader.Error) {
                    message.text = qsTr('El formulari no s\'ha pogut carregar.');
                }

                console.log(status);
            }
        }
    }

    Text {
        id: message
        anchors.fill: flickLoader
    }
}
