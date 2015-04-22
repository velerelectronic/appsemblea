import QtQuick 2.2

import 'qrc:///Core/core' as Core

Item {
    id: viewRect

    property alias model: llista.model
    property int marges: units.nailUnit
    property string etiqueta
    property int midaEtiqueta: units.readUnit
    property int midaTitular: units.readUnit
    property bool resumeix: true
    property int numeroLinies: 2
    property string color
    property real colorOpacity: 0.9

    property bool carregant: true

    signal clicTitular

    property int requiredHeight: titulars.height + 2 * marges
    height: requiredHeight

    clip: true

    Rectangle {
        anchors.fill: parent
        color: viewRect.color
        opacity: viewRect.colorOpacity
    }

    Item {
        id: titulars
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: marges
        height: Math.max(llista.height,units.fingerUnit)

        ListView {
            id: llista
            visible: !carregant
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: contentItem.height
            interactive: false

            delegate: Rectangle {
                width: parent.width
                height: childrenRect.height
                color: 'transparent'
                Text {
                    id: textEtiqueta
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    height: contentHeight
                    font.pixelSize: midaEtiqueta
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    text: etiqueta
                }

                Text {
                    id: textTitular
                    anchors.topMargin: units.nailUnit
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: textEtiqueta.bottom
                    height: contentHeight
                    maximumLineCount: (resumeix)?viewRect.numeroLinies:undefined
    //                elide: Text.ElideRight
                    font.pixelSize: midaTitular
                    text: model.titol
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    font.bold: true
                }
            }
        }
        Text {
            id: loadingText
            anchors.fill: llista
            text: {
                if (carregant) {
                    return qsTr('Carregant...');
                } else {
                    if (model.count==0) {
                        return etiqueta + ': ' + qsTr('No hi ha elements');
                    } else
                        return '';
                }
            }
            font.pixelSize: units.readUnit
            visible: (carregant) || (model.count==0)
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: clicTitular()
        propagateComposedEvents: true
    }
}
