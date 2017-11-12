import QtQuick 2.6
import QtQuick.Window 2.1
import QtQuick.Layouts 1.1
import QtQuick.XmlListModel 2.0
import QtGraphicalEffects 1.0
import 'qrc:///Core/core' as Core
import PersonalTypes 1.0

Item {
    id: mainPage
    Core.UseUnits { id: units }

    signal obrePagina(string pagina,var opcions)
    property int alturaSeccions: units.fingerUnit
    property bool showMainBar: false
    property string colorTitulars: '#D0FA58' // '#ECF6CE'

//    color: 'white'

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
                onClicked: llegeixFeeds()
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

    property int margesGlobal: units.fluentMargins(width,units.nailUnit)

    property bool isVertical: width < height
    property bool isHorizontal: !isVertical

    ListView {
        id: contentsList

        anchors {
            top: barraBotons.bottom
            bottom: parent.bottom

            horizontalCenter: parent.horizontalCenter
        }
        width: Math.min(parent.width - 2 * units.nailUnit, parent.width * 0.8)

        clip: true
        model: feedModel.postsModel

        spacing: units.fingerUnit

        delegate: Rectangle {
            border.color: 'black'

            color: (ListView.isCurrentItem)?'yellow':'white'

            width: contentsList.width
            height: units.fingerUnit * 2
            Text {
                anchors.fill: parent
                anchors.margins: units.nailUnit
                font.pixelSize: units.readUnit
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                text: model.title
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    contentsList.currentIndex = model.index;
                    contentPanel.openPost(model.title, model.content, model.permalink, model.updated)
                }
            }
        }
    }

    Rectangle {
        id: contentPanel

        property string title: ''
        property string content: ''
        property string permalink: ''
        property string updated: ''

        states: [
            State {
                name: 'minimized'
                PropertyChanges {
                    target: contentPanel
                    width: (mainPage.isVertical)?contentPanel.parent.width:(units.fingerUnit * 2)
                    height: (mainPage.isHorizontal)?contentPanel.parent.height:(units.fingerUnit * 2)
                }
            },
            State {
                name: 'maximized'
                PropertyChanges {
                    target: contentPanel
                    width: contentPanel.parent.width
                    height: contentPanel.parent.height
                }
            },
            State {
                name: 'split'
                PropertyChanges {
                    target: contentPanel
                    width: (mainPage.isVertical)?contentPanel.parent.width:(contentPanel.parent.width / 2)
                    height: (mainPage.isHorizontal)?contentPanel.parent.height:(contentPanel.parent.height / 2)
                }
            }
        ]

        state: 'minimized'

        transitions: [
            Transition {
                NumberAnimation {
                    properties: 'width, height'
                    duration: 250
                }
            }
        ]
        anchors {
            bottom: parent.bottom
            right: parent.right
        }
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
                        contentPanel.openPost();
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

                        text: contentPanel.title
                    }

                    Core.Button {
                        Layout.alignment: Text.AlignTop
                        Layout.preferredHeight: units.fingerUnit
                        visible: (contentPanel.state !== 'minimized')
                        color: colorTitulars
                        text: qsTr('Tanca')
                        onClicked: contentPanel.state = 'minimized'
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
                    text: qsTr('Actualitzat: ') + contentPanel.updated
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
                    text: contentPanel.content

                    onLinkActivated: Qt.openUrlExternally(link)
                }
            }
        }


        function openPost(title, content, permalink, updated) {
            if (typeof title !== 'undefined') {
                state = 'split';
                contentPanel.title = title;
                contentPanel.content = content;
                contentPanel.permalink = permalink;
                contentPanel.updated = updated;
            } else {
                if (contentPanel.title !== '') {
                    switch(contentPanel.state) {
                    case 'minimized':
                        contentPanel.state = 'split';
                        break;
                    case 'split':
                        contentPanel.state = 'maximized';
                        break;
                    case 'maximized':
                        contentPanel.state = 'split';
                        break;
                    }
                }
            }
        }
    }

    Core.FeedModel {
        id: feedModel
    }

    function testFeature() {
        obrePagina('MostraFormulari',{url: 'https://script.google.com/macros/s/AKfycbzHwbpJ6Qvwkci2oG5cx-Kw0Vs94p3Fpnz2XL9HL6GHyYA4KBg/exec'});
        //obrePagina('MostraFormulari',{url: 'https://script.googleusercontent.com/macros/echo?user_content_key=PxBrKXhF8w4RInN7FL-9wHK8HNUqWPq0T0Ct0xWm5kbNCbuRn0HOLodx84LU4IKOBncVsdmmO_EAlq8Vtsc2mlZg8R9hnTKRm5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnMXDmXPiSJ6jAooIJJ3Xqdx66-9mRZnellyGprim7tgpu_eV19ToCZMIBzRszd5VJdveWPraiRQB&amp;lib=Mamx1sfZKrMwcz-fUC4CiCO7HcjZDuJUr'});
        //obrePagina('MostraFormulari',{url: 'http://assembleadocentsib.blogspot.com/feeds/posts/default'});
        //obrePagina('MostraFormulari',{url: 'https://api.twitter.com/'});
    }
}

