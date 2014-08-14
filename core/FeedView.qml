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
/*
    The following images belong to the public domain.

    CC0 licenses
    - Enrere: http://pixabay.com/es/men%C3%BA-rojo-brillante-ventana-145776/
    - Actualitza: http://pixabay.com/es/equipo-verde-icono-s%C3%ADmbolo-flecha-31177/
    - Llista: http://pixabay.com/es/plana-icono-propagaci%C3%B3n-frontera-27140/
    - Botó anterior: http://pixabay.com/es/flecha-verde-brillante-izquierda-145769/
    - Botó següent: http://pixabay.com/es/flecha-verde-brillante-derecho-145766/
    - Obre extern: http://pixabay.com/es/nuevo-internet-abierta-web-38743/
    - Menú extra: http://pixabay.com/es/icono-tema-acci%C3%B3n-barras-fila-27951/
*/

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.XmlListModel 2.0
import tipuspersonals 1.0
import 'qrc:///qml' as Qml
import 'qrc:///Core/core' as Core


Rectangle {
    id: feedView

    Core.UseUnits { id: units }

    property string titol
    property var model
    property Component feedDelegate
    property bool oneViewVisible: false
    property string loadingBoxState: ''

//    property alias currentIndex: feedList.currentIndex
    property int statusCache
    property bool formatSectionDate: false
    property bool showReloadButton: !oneViewVisible
    property bool showListButton: oneViewVisible
    property bool showPreviousButton: oneViewVisible
    property bool showNextButton: oneViewVisible
    property bool showExtraMenuButton: !doublePanel.canShowBothPanels()

    signal goBack()
    signal reload()

    onStatusCacheChanged: feedView.tradueixEstat(statusCache)

    Core.MainBar {
        id: mainBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        pageTitle: feedView.titol
        onGoBack: feedView.goBack()

        Core.ImageButton {
            available: !oneViewVisible
            size: parent.height
            image: 'computer-31177'
            onClicked: feedView.reload()
        }

        Core.ImageButton {
            available: showListButton
            size: parent.height
            image: 'flat-27140'
            onClicked: {
                oneViewVisible = false;
            }
        }
        Core.ImageButton {
            id: previousButton
            available: showPreviousButton
            size: parent.height
            image: 'arrow-145769'
        }
        Core.ImageButton {
            id: nextButton
            available: showNextButton
            size: parent.height
            image: 'arrow-145766'
        }
        Core.ImageButton {
            available: showExtraMenuButton
            size: parent.height
            image: 'icon-27951'
            onClicked: doublePanel.toggleSubPanel()
        }
    }

    DoublePanel {
        id: doublePanel

        signal obreExtern()
        signal copiaTitol()
        signal copiaContingut()
        signal copiaEnllac()
        signal enviaMail()

        anchors.top: mainBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        colorMainPanel: 'white'
        colorSubPanel: '#ECF6CE'

        itemMainPanel: Item {
            id: mainPanel
            Component.onCompleted: console.log('Creat ara ' + (new Date()).toISOString());

            Connections {
                target: previousButton
                onClicked: mainPanel.goToPreviousItem()
            }
            Connections {
                target: nextButton
                onClicked: mainPanel.goToNextItem()
            }

            Connections {
                target: doublePanel
                onObreExtern: Qt.openUrlExternally(singleItem.enllac)
                onCopiaTitol: {
                    clipboard.copia(singleItem.copiaTitol);
                    infoMessage.mostraInfo(qsTr("S'ha copiat el títol al portapapers."));
                }
                onCopiaContingut: {
                    clipboard.copia(singleItem.copiaContingut);
                    infoMessage.mostraInfo(qsTr("S'han copiat els continguts al portapapers."));
                }
                onCopiaEnllac: {
                    clipboard.copia(singleItem.copiaEnllac);
                    infoMessage.mostraInfo(qsTr("S'ha copiat l'enllaç al portapapers."));
                }
                onEnviaMail: Qt.openUrlExternally('mailto:?subject=' + encodeURIComponent('[Appsemblea] ' +singleItem.titol) + '&body=' + encodeURIComponent(singleItem.enllac))
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: units.nailUnit

    //            property alias model: feedList.model
    //            property alias feedDelegate: feedList.delegate

                Qml.LoadingBox {
                    id: loadingBox
                    Layout.fillWidth: true
                    Layout.preferredHeight: height
                    state: loadingBoxState
                    actualitzat: (typeof (model.lastUpdate) != 'undefined')?model.lastUpdate:''
                }

                ListView {
                    id: feedList
                    property bool mustUpdate: false
                    property bool initialValue: true

                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    z: 1
                    clip: true
                    model: feedView.model
                    delegate: feedView.feedDelegate

                    section.property: 'grup'
                    section.criteria: ViewSection.FullString
                    section.delegate: Item {
                        width: childrenRect.width
                        height: childrenRect.height + units.readUnit
                        Rectangle {
                            color: mainBar.color // Same color as the main bar
                            radius: units.nailUnit / 2
                            anchors.left: parent.left
                            width: childrenRect.width + units.nailUnit
                            anchors.top: parent.top
                            anchors.topMargin: units.readUnit
                            height: childrenRect.height + units.nailUnit
                            Text {
                                anchors.margins: units.nailUnit / 2
                                anchors.left: parent.left
                                width: paintedWidth
                                anchors.top: parent.top
                                height: paintedHeight
                                font.pixelSize: units.readUnit
                                verticalAlignment: Text.AlignVCenter
                                text: (formatSectionDate)?((new Date(section)).escriuDiaMes()):section
                            }
                        }
                    }

                    Component.onCompleted: {
                        currentIndex = -1;
                        initialValue = false;
                    }

                    onCurrentIndexChanged: {
                        if (!initialValue) {
                            if (currentIndex>-1) {
                                oneViewVisible = true;
                            }
                        }
                    }

                    onContentYChanged: {
                        switch(loadingBoxState) {
                        case '':
                        case 'perfect':
                        case 'error':
                            // The view has not been dragged downwards yet
                            if ((contentY<0) && (draggingVertically)) {
                                loadingBoxState = 'updateable';
                            }
                            break;

                        case 'updateable':
                            // The view has previously been dragged downwards
                            if ((movingVertically) && (!draggingVertically)) {
                                console.log('do loading');
                                loadingBoxState = 'loading';
                                feedView.reload();
                            } else {
                                if (contentY>=0)
                                    loadingBoxState = 'perfect';
                            }
                            break;

                        case 'loading':
                            // The view has been activated to load new contents
                            break;
                        }
                    }

                    Rectangle {
                        id: oneView
                        anchors.fill: feedList
                        visible: oneViewVisible
                        z: 3

                        MouseArea {
                            anchors.fill: parent
                            preventStealing: true
                            onPressed: mouse.accepted = true
                        }

                        ColumnLayout {
                            anchors.fill: parent
                            Rectangle {
                                id: extraMenu
                                states: [
                                    State {
                                        name: 'hidden'
                                        PropertyChanges {
                                            target: extraMenu
                                            height: 0
                                        }
                                    },
                                    State {
                                        name: 'show'
                                        PropertyChanges {
                                            target: extraMenu
                                            height: Math.round(units.fingerUnit * 1.5)
                                        }
                                    }
                                ]

                                state: 'hidden'
                                radius: units.nailUnit
                                color: '#60ff60'
                                Layout.fillWidth: true
                                Layout.preferredHeight: height
                                clip: true

                            }

                            SingleItemView {
                                id: singleItem
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                onVisibleChanged: if (visible == false) feedList.currentIndex = -1;

                                titol: (feedList.currentIndex>-1)?feedList.currentItem.textTitol:''
                                continguts: (feedList.currentIndex>-1)?feedList.currentItem.textContingut:''
                                enllac: (feedList.currentIndex>-1)?feedList.currentItem.enllac:''
                                copiaTitol: (feedList.currentIndex>-1)?feedList.currentItem.copiaTitol:''
                                copiaContingut: (feedList.currentIndex>-1)?feedList.currentItem.copiaContingut:''
                                copiaEnllac: (feedList.currentIndex>-1)?feedList.currentItem.copiaEnllac:''
                            }
                        }
                    }

                }
            }
            function goToPreviousItem() {
                feedList.decrementCurrentIndex();
                singleItem.situaAlPrincipi();
            }

            function goToNextItem() {
                feedList.incrementCurrentIndex();
                singleItem.situaAlPrincipi();
            }

            function openExternally() {
                Qt.openUrlExternally(singleItem.enllac);
            }
        }

        itemSubPanel: Flickable {
            contentWidth: parent.width
            contentHeight: buttonsRow.height
            boundsBehavior: Flickable.StopAtBounds
            clip: true

            Item {
                id: buttonsRow
                width: parent.width
                height: buttonsLayout.height + 2*units.nailUnit

                ColumnLayout {
                    id: buttonsLayout
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: units.nailUnit
                    height: childrenRect.height
                    spacing: units.fingerUnit

                    Text {
                        id: textExplicatiu
                        visible: !oneViewVisible
                        font.pixelSize: units.readUnit
                        text: qsTr('Selecciona un element de la llista per veure en aquesta barra les opcions disponibles.')
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        Layout.preferredHeight: (visible)?contentHeight:0
                        Layout.fillWidth: visible
                        Layout.alignment: Qt.AlignTop
                    }

                    /*
                    Core.Button {
                        id: botoObreCalendari
                        Layout.preferredWidth: parent.width
                        Layout.preferredHeight: units.fingerUnit
                        available: true
                        color: 'white'
                        text: qsTr('Calendari')
                        onClicked: Qt.openUrlExternally('calshow://')
                    }
                    */

                    Core.Button {
                        id: botoObreExtern
                        Layout.preferredWidth: parent.width
                        Layout.preferredHeight: units.fingerUnit
                        available: oneViewVisible
                        color: 'white'
                        text: qsTr('Obre extern')
                        onClicked: doublePanel.obreExtern()
                    }

                    Core.Button {
                        id: botoCopiaTitol
                        Layout.preferredWidth: parent.width
                        Layout.preferredHeight: units.fingerUnit
                        available: oneViewVisible
                        color: 'white'
                        text: qsTr('Copia títol')
                        onClicked: doublePanel.copiaTitol()
                    }
                    Core.Button {
                        id: botoCopiaContingut
                        Layout.preferredWidth: parent.width
                        Layout.preferredHeight: units.fingerUnit
                        available: oneViewVisible
                        color: 'white'
                        text: qsTr('Copia contingut')
                        onClicked: doublePanel.copiaContingut()
                    }
                    Core.Button {
                        id: botoCopiaEnllac
                        Layout.preferredWidth: parent.width
                        Layout.preferredHeight: units.fingerUnit
                        available: oneViewVisible
                        color: 'white'
                        text: qsTr('Copia enllaç')
                        onClicked: doublePanel.copiaEnllac()
                    }
                    Core.Button {
                        id: botoEnviaMail
                        Layout.preferredWidth: parent.width
                        Layout.preferredHeight: units.fingerUnit
                        available: oneViewVisible
                        color: 'white'
                        text: qsTr('Envia per correu')
                        onClicked: doublePanel.enviaMail()
                    }
                }
            }
        }
    }


    Component {
        id: subMenuComponent

        Rectangle {
            color: 'green'
        }
    }

    QClipboard { id: clipboard }

    MessageDialog {
        id: infoMessage
        visible: false
        standardButtons: StandardButton.Ok
        onAccepted: visible = false

        function mostraInfo(text) {
            informativeText = text;
            visible = true;
        }
    }

    function tradueixEstat(estat) {
        switch(estat) {
        case XmlListModel.Null:
            loadingBoxState = '';
            break;
        case XmlListModel.Loading:
            loadingBoxState = 'loading';
            break;
        case XmlListModel.Ready:
            loadingBoxState = 'perfect';
            break;
        case XmlListModel.Error:
            loadingBoxState = 'error';
            break;
        default:
            loadingBoxState = '';
            break;
        }
    }

}

