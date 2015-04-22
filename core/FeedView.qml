/*
  Llicències CC0
  - Enrere: http://pixabay.com/es/men%C3%BA-rojo-brillante-ventana-145776/
  - Actualitza: http://pixabay.com/es/equipo-verde-icono-s%C3%ADmbolo-flecha-31177/
  - Llista: http://pixabay.com/es/plana-icono-propagaci%C3%B3n-frontera-27140/
  - Botó anterior: http://pixabay.com/es/flecha-verde-brillante-izquierda-145769/
  - Botó següent: http://pixabay.com/es/flecha-verde-brillante-derecho-145766/
  - Obre extern: http://pixabay.com/es/nuevo-internet-abierta-web-38743/
  - Menú extra: http://pixabay.com/es/icono-tema-acci%C3%B3n-barras-fila-27951/
  - Ajuda: http://pixabay.com/es/questionmark-info-ayuda-308636/
  */

import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.XmlListModel 2.0
import tipuspersonals 1.0
import 'qrc:///qml' as Qml
import 'qrc:///Core/core' as Core


Rectangle {
    id: feedView

    Core.UseUnits { id: units }

    signal showHelpPage()

    property string titol
    property var model
    property Component feedDelegate
    property Component detailFeedDelegate

    property bool oneViewVisible: false
    property string loadingBoxState: ''

//    property alias currentIndex: feedList.currentIndex
    property int statusCache
    property bool formatSectionDate: false
    property bool showReloadButton: !oneViewVisible
    // property bool showListButton: oneViewVisible
    property bool showExtraMenuButton: !doublePanel.canShowBothPanels()

    property string lastUpdate: ''
    property string homePage: ''

    signal goBack()
    signal reload()

    signal shareFacebook
    signal shareTwitter
    signal shareGooglePlus

    onStatusCacheChanged: feedView.tradueixEstat(statusCache)

    Core.MainBar {
        id: mainBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        pageTitle: feedView.titol
        onGoBack: {
            if (doublePanel.isShaded()) {
                doublePanel.toggleSubPanel();
            } else {
                if (oneViewVisible) {
                    oneViewVisible = false;
                } else {
                    feedView.goBack();
                }
            }
        }

        Core.ImageButton {
            available: !oneViewVisible
            size: parent.height
            image: 'computer-31177'
            onClicked: feedView.reload()
        }

        /*
        Core.ImageButton {
            available: showListButton
            size: parent.height
            image: 'flat-27140'
            onClicked: {
                oneViewVisible = false;
            }
        }
        */
        Core.ImageButton {
            available: showExtraMenuButton
            size: parent.height
            image: 'icon-27951'
            onClicked: doublePanel.toggleSubPanel()
        }

        Core.ImageButton {
            size: parent.height
            image: 'questionmark-308636'
            onClicked: showHelpPage()
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
                target: feedView
                onShareFacebook: Qt.openUrlExternally('https://www.facebook.com/sharer/sharer.php?u=' + encodeURIComponent(singleItemList.currentItem.enllac))
                onShareTwitter: Qt.openUrlExternally('http://twitter.com/intent/tweet?text=' + singleItemList.currentItem.titol + '%20' + encodeURIComponent(singleItemList.currentItem.enllac) + '&url=undefined')
                onShareGooglePlus: Qt.openUrlExternally('https://plus.google.com/share?url=' + singleItemList.currentItem.enllac)
            }

            Connections {
                target: doublePanel
                onObreExtern: Qt.openUrlExternally(singleItemList.currentItem.enllac)
                onCopiaTitol: {
                    clipboard.copia(singleItemList.currentItem.copiaTitol);
                    infoMessage.mostraInfo(qsTr("S'ha copiat el títol al portapapers."));
                }
                onCopiaContingut: {
                    clipboard.copia(singleItemList.currentItem.copiaContingut);
                    infoMessage.mostraInfo(qsTr("S'han copiat els continguts al portapapers."));
                }
                onCopiaEnllac: {
                    clipboard.copia(singleItemList.currentItem.copiaEnllac);
                    infoMessage.mostraInfo(qsTr("S'ha copiat l'enllaç al portapapers."));
                }
                onEnviaMail: Qt.openUrlExternally('mailto:?subject=' + encodeURIComponent('[Appsemblea] ' +singleItemList.currentItem.titol) + '&body=' + encodeURIComponent(singleItemList.currentItem.enllac))
            }

            Item {
                anchors.fill: parent
                anchors.margins: units.nailUnit

    //            property alias model: feedList.model
    //            property alias feedDelegate: feedList.delegate

                Qml.LoadingBox {
                    id: loadingBox
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    z: 2
                    state: loadingBoxState
                    actualitzat: feedView.lastUpdate
                }

                ListView {
                    id: feedList
                    property bool mustUpdate: false

                    Layout.fillHeight: true
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.topMargin: units.glanceUnit
                    anchors.bottom: parent.bottom

                    bottomMargin: doublePanel.globalMargins

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
                    footer: Rectangle {
                        width: feedList.width
                        height: childrenRect.height
                        Text {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            height: contentHeight + units.fingerUnit
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: '#aaaaaa'
                            text: qsTr('Hi ha ') + model.count + qsTr(' elements')
                        }
                    }

                    Component.onCompleted: {
                        currentIndex = -1;
                    }

                    onCurrentIndexChanged: {
                        if (currentIndex>-1) {
                            oneViewVisible = true;
                            singleItemList.positionViewAtIndex(currentIndex,ListView.Beginning);
                        }
                        currentIndex = -1;
                    }

                    onContentYChanged: {
                        switch(loadingBoxState) {
                        case '':
                        case 'perfect':
                        case 'error':
                        case 'timeout':
                        case 'nodata':
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
                        id: oneViewList
                        anchors.fill: feedList
                        visible: oneViewVisible
                        ListView {
                            id: singleItemList
                            anchors.fill: parent

                            model: feedView.model
                            orientation: ListView.Horizontal
                            snapMode: ListView.SnapOneItem
                            spacing: units.fingerUnit
                            highlightFollowsCurrentItem: true
                            highlightRangeMode: ListView.StrictlyEnforceRange
                            onCurrentIndexChanged: {console.log(currentIndex) }
                            delegate: feedView.detailFeedDelegate
                        }
                    }
                }
            }

            function openExternally() {
                Qt.openUrlExternally(singleItemList.currentItem.enllac);
            }
        }

        itemSubPanel: ListView {
            id: buttonsRow

            clip: true
            spacing: units.fingerUnit
            boundsBehavior: Flickable.StopAtBounds
            model: (feedView.oneViewVisible)?modelForItem:modelForList
            topMargin: doublePanel.globalMargins
            bottomMargin: doublePanel.globalMargins

            VisualItemModel {
                id: modelForList
                Core.Button {
                    id: homePageButton
                    width: buttonsRow.width
                    color: 'white'
                    text: qsTr('Obre extern')
                    onClicked: Qt.openUrlExternally(homePage)
                    visible: (homePage != '')
                }

                Text {
                    id: textExplicatiu
                    font.pixelSize: units.readUnit
                    text: qsTr('Selecciona un element de la llista per veure en aquesta barra les opcions disponibles.')
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    height: contentHeight
                    width: buttonsRow.width
                    Layout.alignment: Qt.AlignTop
                }
            }

            VisualItemModel {
                id: modelForItem

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

                Button {
                    id: shareFB
                    width: buttonsRow.width
                    color: '#0040FF'
                    textColor: 'white'
                    text: qsTr('Facebook')
                    onClicked: feedView.shareFacebook()
                }
                Button {
                    id: shareTwitter
                    width: buttonsRow.width
                    color: '#2ECCFA'
                    text: qsTr('Twitter')
                    onClicked: feedView.shareTwitter()
                }
                Button {
                    id: shareGPlus
                    width: buttonsRow.width
                    color: '#FE2E2E'
                    textColor: 'white'
                    text: qsTr('Google Plus')
                    onClicked: feedView.shareGooglePlus()
                }

                Core.Button {
                    id: botoObreExtern
                    width: buttonsRow.width
                    available: oneViewVisible
                    color: 'white'
                    text: qsTr('Obre extern')
                    onClicked: doublePanel.obreExtern()
                }

                Core.Button {
                    id: botoCopiaTitol
                    width: buttonsRow.width
                    available: oneViewVisible
                    color: 'white'
                    text: qsTr('Copia títol')
                    onClicked: doublePanel.copiaTitol()
                }
                Core.Button {
                    id: botoCopiaContingut
                    width: buttonsRow.width
                    available: oneViewVisible
                    color: 'white'
                    text: qsTr('Copia contingut')
                    onClicked: doublePanel.copiaContingut()
                }
                Core.Button {
                    id: botoCopiaEnllac
                    width: buttonsRow.width
                    available: oneViewVisible
                    color: 'white'
                    text: qsTr('Copia enllaç')
                    onClicked: doublePanel.copiaEnllac()
                }
                Core.Button {
                    id: botoEnviaMail
                    width: buttonsRow.width
                    available: oneViewVisible
                    color: 'white'
                    text: qsTr('Envia per correu')
                    onClicked: doublePanel.enviaMail()
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
            loadingBoxState = 'nodata';
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
            loadingBoxState = 'nodata';
            break;
        }
    }

    function getHelpText() {
        return "<p>Llisca el dit sobre la pantalla! Els gestos et permeten fer una navegació molt més fàcil i ràpida.</p>
        <ul><li>A la llista de titulars, toca amb el dit sobre qualsevol titular per mostrar tots els seus continguts.</li>
        <li>Arrossega la llista cap avall i deixa-la anar per poder actualitzar-la amb nova informació d'internet.</li>
        </ul>
        <p>Han desaparegut els botons per passar a la notícia següent o l'anterior. Però ara pots fer el canvi d'una altra manera.</p>
        <p>Quan es mostrin els continguts, llisca el dit sobre el text cap a l'esquerra per passar al titular següent o cap a la dreta per passar a l'anterior.</p>";
    }
}

