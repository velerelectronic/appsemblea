import QtQuick 2.6
import QtQuick.Window 2.1
import QtQuick.Layouts 1.1
import QtQuick.XmlListModel 2.0
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.2
import 'qrc:///Core/core' as Core

import PersonalTypes 1.0
import tipuspersonals 1.0

Item {
    id: mainPage
    Core.UseUnits { id: units }

    signal obrePagina(string pagina,var opcions)
    property int alturaSeccions: units.fingerUnit
    property bool showMainBar: false
    property string colorTitulars: '#D0FA58' // '#ECF6CE'

//    color: 'white'

    property int minimumOuterMargin: units.nailUnit

    ListView {
        id: barraBotons
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: units.nailUnit
        }
        height: units.fingerUnit
        spacing: units.nailUnit
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds

        // Ensure the menu is visible for small and large screens
        leftMargin: ((contentWidth<width)?(width-contentWidth)/2:0) + anchors.margins

        model: VisualItemModel {
            Core.Button {
                id: botoTest
                color: colorTitulars
                text: qsTr('Test')
                onClicked: testFeature()
            }

            Core.Button {
                id: botoActualitza
                color: colorTitulars
                text: qsTr('Actualitza')
                onClicked: feedModel.reloadContents()
            }
            Core.Button {
                id: botoDirectori
                color: 'white'
                text: qsTr('Directori')
                onClicked: obrePagina('Directori',{})
            }
            Core.Button {
                id: botoPMF
                color: 'white'
                text: qsTr('PMF')
                onClicked: obrePagina('FAQ',{})
            }
            Core.Button {
                id: botoContactes
                color: 'white'
                text: qsTr('Contactes')
                onClicked: obrePagina('Contactes',{})
            }
            Core.Button {
                id: botoLicense
                color: 'white'
                text: qsTr('Llicència')
                onClicked: obrePagina('LicensePage',{})
            }
        }
    }

    Item {
        id: twoPanelsPlace

        anchors {
            top: barraBotons.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: twoPanelsPlace.horizontalMargins
            rightMargin: twoPanelsPlace.horizontalMargins
            topMargin: twoPanelsPlace.verticalMargins
            bottomMargin: twoPanelsPlace.verticalMargins
        }

        property int horizontalMargins: Math.max(units.nailUnit, parent.width * 0.1)
        property int verticalMargins: 0
        property int panelWidth: (isVertical)?twoPanelsPlace.width:Math.min(twoPanelsPlace.width * 0.8, twoPanelsPlace.width)

        // REEVIEW here
        property int panelHeight: (isHorizontal)?twoPanelsPlace.height:Math.min(twoPanelsPlace.height * 0.8, twoPanelsPlace.height)
        ///

        states: [
            State {
                name: 'onlyFeeds'

                // Feed list in the middle of the screen, no posts panel

                PropertyChanges {
                    target: feedsList
                    width: twoPanelsPlace.panelWidth
                }
                PropertyChanges {
                    target: postPanel
                    visible: false
                }
                AnchorChanges {
                    target: feedsList
                    anchors.top: twoPanelsPlace.top
                    anchors.bottom: twoPanelsPlace.bottom
                    anchors.horizontalCenter: twoPanelsPlace.horizontalCenter
                }

                AnchorChanges {
                    target: postPanel
                    anchors.left: twoPanelsPlace.left
                    anchors.top: twoPanelsPlace.top
                }
            },
            State {
                name: 'splitWithFeeds'

                AnchorChanges {
                    target: feedsList
                    anchors.left: (isVertical)?undefined:twoPanelsPlace.left
                    anchors.top: (isHorizontal)?undefined:twoPanelsPlace.top
                    anchors.horizontalCenter: (isVertical)?twoPanelsPlace.horizontalCenter:undefined
                    anchors.verticalCenter: (isHorizontal)?twoPanelsPlace.verticalCenter:undefined
                }
                AnchorChanges {
                    target: postPanel
                    anchors.left: (isVertical)?undefined:feedsList.right
                    anchors.top: (isHorizontal)?undefined:bottomSpaceItem.top
                    anchors.horizontalCenter: (isVertical)?twoPanelsPlace.horizontalCenter:undefined
                    anchors.verticalCenter: (isHorizontal)?twoPanelsPlace.verticalCenter:undefined
                }

            },
            State {
                name: 'splitWithPost'

                AnchorChanges {
                    target: feedsList

                    anchors.left: (isVertical)?undefined:twoPanelsPlace.left
                    anchors.top: (isHorizontal)?undefined:twoPanelsPlace.top
                    anchors.horizontalCenter: (isVertical)?twoPanelsPlace.horizontalCenter:undefined
                    anchors.verticalCenter: (isHorizontal)?twoPanelsPlace.verticalCenter:undefined
                }

                AnchorChanges {
                    target: postPanel

                    anchors.right: (isVertical)?undefined:twoPanelsPlace.right
                    anchors.bottom: (isHorizontal)?undefined:twoPanelsPlace.bottom
                    anchors.horizontalCenter: (isVertical)?twoPanelsPlace.horizontalCenter:undefined
                    anchors.verticalCenter: (isHorizontal)?twoPanelsPlace.verticalCenter:undefined
                }
            }

        ]

        state: 'onlyFeeds'

        transitions: [
            Transition {
                AnchorAnimation {
                    duration: 250
                }
            }
        ]

        ListView {
            id: feedsList

            clip: true
            model: feedModel.postsModel

            spacing: units.fingerUnit

            width: twoPanelsPlace.panelWidth
            height: twoPanelsPlace.panelHeight

            delegate: Rectangle {
                border.color: 'black'

                color: (ListView.isCurrentItem)?'yellow':'white'

                width: feedsList.width
                height: postTitleText.height + units.nailUnit * 4

                Text {
                    id: postTitleText

                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }
                    anchors.margins: units.nailUnit * 2
                    height: contentHeight

                    font.pixelSize: units.readUnit
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    //verticalAlignment: Text.AlignVCenter
                    maximumLineCount: 3
                    //elide: Text.ElideRight

                    textFormat: Text.PlainText
                    text: model.title
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        feedsList.currentIndex = model.index;
                        twoPanelsPlace.openPost(model.title, model.content, model.permalink, model.updated)
                    }
                }
            }

            bottomMargin: units.fingerUnit
        }

        Rectangle {
            id: postPanel

            property string title: ''
            property string content: ''
            property string permalink: ''
            property string updated: ''

            width: twoPanelsPlace.panelWidth
            height: twoPanelsPlace.panelHeight

            transitions: [
                Transition {
                    AnchorAnimation {
                        duration: 250
                    }
                }
            ]
            border.color: 'black'

            MouseArea {
                anchors.fill: parent
                onPressed: mouse.accepted = true
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: parent.border.width
                spacing: 0

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: titleText.contentHeight + titleText.padding * 2
                    color: '#AAFFAA'

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            twoPanelsPlace.openPost();
                        }
                    }

                    RowLayout {
                        anchors.fill: parent
                        spacing: units.fingerUnit

                        Text {
                            id: titleText

                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            padding: units.fingerUnit

                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            font.pixelSize: units.readUnit
                            font.bold: true

                            text: postPanel.title
                        }

                        Core.Button {
                            Layout.alignment: Text.AlignTop
                            Layout.preferredHeight: units.fingerUnit
                            visible: (twoPanelsPlace.state !== 'onlyFeeds')
                            color: colorTitulars
                            text: qsTr('Tanca')
                            onClicked: twoPanelsPlace.state = 'onlyFeeds'
                        }

                    }

                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: units.fingerUnit
                    Text {
                        anchors.fill: parent
                        padding: units.nailUnit

                        font.pixelSize: units.readUnit
                        color: 'gray'
                        text: qsTr('Actualitzat: ') + postPanel.updated
                    }
                }

                Flickable {
                    id: flickArea

                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    contentWidth: flickText.contentWidth
                    contentHeight: flickText.height + flickText.padding * 2
                    clip: true

                    Text {
                        id: flickText

                        width: flickArea.width
                        height: contentHeight
                        padding: units.fingerUnit

                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        font.pixelSize: units.readUnit
                        text: postPanel.content

                        onLinkActivated: Qt.openUrlExternally(link)
                    }
                }
            }
            Flow {
                id: buttonsRow

                anchors {
                    bottom: postPanel.bottom
                    left: postPanel.left
                    right: postPanel.right
                    margins: units.fingerUnit
                }
                height: childrenRect.height + units.fingerUnit

                spacing: units.fingerUnit

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
                    id: shareFB

                    color: '#0040FF'
                    textColor: 'white'
                    text: qsTr('Facebook')
                    onClicked: {
                        Qt.openUrlExternally('https://www.facebook.com/sharer/sharer.php?u=' + encodeURIComponent(postPanel.permalink));
                    }
                }

                Core.Button {
                    id: shareTwitter

                    color: '#2ECCFA'
                    text: qsTr('Twitter')
                    onClicked: Qt.openUrlExternally('http://twitter.com/intent/tweet?text=' + postPanel.title + '%20' + encodeURIComponent(postPanel.permalink) + '&url=undefined')
                }
                Core.Button {
                    id: shareGPlus

                    color: '#FE2E2E'
                    textColor: 'white'
                    text: qsTr('Google Plus')
                    onClicked: Qt.openUrlExternally('https://plus.google.com/share?url=' + postPanel.permalink)
                }

                Core.Button {
                    id: botoObreExtern

                    color: 'white'
                    text: qsTr('Obre extern')
                    onClicked: Qt.openUrlExternally(postPanel.permalink)
                }

                Core.Button {
                    id: botoCopiaTitol

                    color: 'white'
                    text: qsTr('Copia títol')
                    onClicked: {
                        clipboard.copia(postPanel.title);
                        infoMessage.mostraInfo(qsTr("S'ha copiat el títol al portapapers."));
                    }
                }
                Core.Button {
                    id: botoCopiaContingut

                    color: 'white'
                    text: qsTr('Copia contingut')
                    onClicked: {
                        clipboard.copia(postPanel.content);
                        infoMessage.mostraInfo(qsTr("S'han copiat els continguts al portapapers."));
                    }
                }
                Core.Button {
                    id: botoCopiaEnllac

                    color: 'white'
                    text: qsTr('Copia enllaç')
                    onClicked: {
                        clipboard.copia(postPanel.permalink);
                        infoMessage.mostraInfo(qsTr("S'ha copiat l'enllaç al portapapers."));
                    }
                }
                Core.Button {
                    id: botoEnviaMail

                    color: 'white'
                    text: qsTr('Envia per correu')
                    onClicked: {
                        Qt.openUrlExternally('mailto:?subject=' + encodeURIComponent('[Appsemblea] ' +postPanel.title) + '&body=' + encodeURIComponent(postPanel.permalink));
                    }
                }
            }
        }

        Item {
            id: bottomSpaceItem

            // Item to leave space for post panel when minimized
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
            height: units.fingerUnit * 2
        }

        function openPost(title, content, permalink, updated) {
            if (typeof title !== 'undefined') {
                state = 'splitWithPost';
                postPanel.title = title;
                postPanel.content = content;
                postPanel.permalink = permalink;
                postPanel.updated = updated;
            } else {
                if (postPanel.title !== '') {
                    switch(state) {
                    case 'onlyFeeds':
                        state = 'splitWithPost';
                        break;
                    case 'splitWithPost':
                        state = 'splitWithFeeds';
                        break;
                    case 'splitWithFeeds':
                        state = 'splitWithPost';
                        break;
                    }
                }
            }
        }

    }


    property int margesGlobal: units.fluentMargins(width,units.nailUnit)

    property bool isVertical: twoPanelsPlace.width < twoPanelsPlace.height
    property bool isHorizontal: !isVertical



    Core.FeedModel {
        id: feedModel
    }

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

    QClipboard { id: clipboard }

    function testFeature() {
        obrePagina('MostraFormulari',{url: 'https://script.google.com/macros/s/AKfycbzHwbpJ6Qvwkci2oG5cx-Kw0Vs94p3Fpnz2XL9HL6GHyYA4KBg/exec'});
        //obrePagina('MostraFormulari',{url: 'https://script.googleusercontent.com/macros/echo?user_content_key=PxBrKXhF8w4RInN7FL-9wHK8HNUqWPq0T0Ct0xWm5kbNCbuRn0HOLodx84LU4IKOBncVsdmmO_EAlq8Vtsc2mlZg8R9hnTKRm5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnMXDmXPiSJ6jAooIJJ3Xqdx66-9mRZnellyGprim7tgpu_eV19ToCZMIBzRszd5VJdveWPraiRQB&amp;lib=Mamx1sfZKrMwcz-fUC4CiCO7HcjZDuJUr'});
        //obrePagina('MostraFormulari',{url: 'http://assembleadocentsib.blogspot.com/feeds/posts/default'});
        //obrePagina('MostraFormulari',{url: 'https://api.twitter.com/'});
    }
}

