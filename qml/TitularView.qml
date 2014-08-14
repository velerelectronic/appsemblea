/*
    Appsemblea, an application to keep the assembly of teachers informed
    Copyright (C) 2014 Joan Miquel Payeras Crespí

    This file is part of Appsemblea

    Appsemblea is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 3 of the License.

    Appsemblea is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

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
            text: qsTr('Carregant...')
            font.pixelSize: units.readUnit
            visible: carregant
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: clicTitular()
        propagateComposedEvents: true
    }
}
