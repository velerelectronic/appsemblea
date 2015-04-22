import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.XmlListModel 2.0
import QtQuick.Dialogs 1.1
import 'qrc:///Core/core' as Core
import 'qrc:///qml' as Qml

Rectangle {
    id: faqPage
    color: 'transparent'
    anchors.margins: units.nailUnit

    signal obrePagina(string pagina, var opcions)
    signal reload()
    signal goBack()
    signal showHelpPage()

    property string loadingBoxState: 'perfect'
    property string lastUpdate: faqModel.lastUpdate

    onReload: faqModel.llegeixOnline()

    property bool showExtraMenuButton: !doublePanel.canShowBothPanels()

    property bool working: true

    Core.UseUnits { id: units }

    Core.MainBar {
        id: mainBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        pageTitle: qsTr('PMF')
        onGoBack: {
            if (doublePanel.isShaded()) {
                doublePanel.toggleSubPanel();
            } else {
                faqPage.goBack();
            }
        }

        Core.ImageButton {
            size: parent.height
            image: 'computer-31177'
            onClicked: faqPage.reload()
        }

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

    Core.CachedModel {
        id: faqModel
        source: 'https://script.google.com/macros/s/AKfycbzad_8gw3RCZ6J6L9u_wseFupDknESf4nbij0xJGsBFs_5yBJk/exec'
        categoria: 'faq'
        typeFiltra: true
    }

    Core.DoublePanel {
        id: doublePanel

        signal enviaMail()

        anchors.top: mainBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        colorMainPanel: 'white'
        colorSubPanel: '#ECF6CE'

        itemSubPanel: ListView {
            id: buttonsRow

            clip: true
            spacing: units.fingerUnit
            boundsBehavior: Flickable.StopAtBounds
            model: modelForList
            topMargin: doublePanel.globalMargins
            bottomMargin: doublePanel.globalMargins

            VisualItemModel {
                id: modelForList
                Core.Button {
                    width: buttonsRow.width
                    text: qsTr('Col·labora-hi!')
                    color: 'white'
                    onClicked: collaborate()
                }

                Text {
                    width: buttonsRow.width
                    height: contentHeight
                    font.pixelSize: units.readUnit
                    text: qsTr('Categories')
                }

                ListView {
                    id: categoryList
                    model: categoriesModel
                    height: contentItem.height
                    width: buttonsRow.width

                    spacing: units.nailUnit
                    interactive: false

                    delegate: Rectangle {
                        radius: units.fingerUnit / 2
                        border.color: 'green'

                        function hastobeshown(index,category) {
                            for (var i=0; i<index; i++) {
                                if (categoriesModel.get(i)['category']==category) {
                                    console.log('TROBAT');
                                    return false;
                                }
                            }
                            return true;
                        }

                        height: (hastobeshown(model.index,model.category))?categoryText.height:0
                        width: categoryList.width
                        clip: true

                        Text {
                            id: categoryText
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: Math.max(units.fingerUnit,contentHeight)
                            font.pixelSize: units.readUnit
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            text: category
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: infoDialog.open()
                        }
                    }
                }
            }
        }
        itemMainPanel: Item {
            Qml.LoadingBox {
                id: loadingBox
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                z: 2
                state: faqPage.loadingBoxState
                actualitzat: faqPage.lastUpdate
            }

            ListView {
                id: faqList
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: loadingBox.bottom
                anchors.bottom: parent.bottom

                clip: true

                model: questionsModel
                delegate: Rectangle {
                    border.color: 'black'
                    width: faqList.width
                    height: column.height + 2 * units.nailUnit

                    ColumnLayout {
                        id: column
                        anchors.margins: units.nailUnit
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        // height: categoriesSection.height + questionSection.height + answerSection.height + datesSection.height + 3 * spacing
                        spacing: units.nailUnit

                        Text {
                            id: categoriesSection
                            Layout.fillWidth: true
                            Layout.preferredHeight: height
                            font.pixelSize: units.readUnit
                            color: 'blue'
                            text: categoryA + ' - ' + categoryB
                        }
                        Text {
                            id: questionSection
                            Layout.fillWidth: true
                            Layout.preferredHeight: contentHeight
                            font.bold: true
                            font.pixelSize: units.titleReadUnit
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            text: question
                        }
                        Text {
                            id: answerSection
                            Layout.fillWidth: true
                            Layout.preferredHeight: contentHeight
                            font.pixelSize: units.readUnit
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            text: (answer)?answer:''
                        }
                        Text {
                            id: datesSection
                            Layout.fillWidth: true
                            font.pixelSize: units.smallReadUnit
                            color: 'gray'
                            text: created + ' - ' + updated
                        }
                    }
                    MouseArea {
                        anchors.fill: column
                        onClicked: {
                            if (model.link !== '') {
                                console.log(model.link);
                                Qt.openUrlExternally(model.link);
                            }
                        }
                    }
                }
            }
        }
    }

    XmlListModel {
        id: questionsModel
        xml: faqModel.contents
        query: '/data/item'
        //namespaceDeclarations: "declare default element namespace 'http://www.w3.org/2005/Atom';"

        XmlRole { name: 'categoryA'; query: 'category1/string()' }
        XmlRole { name: 'categoryB'; query: 'category2/string()' }
        XmlRole { name: 'question'; query: 'question/string()' }
        XmlRole { name: 'answer'; query: 'answer/string()' }
        XmlRole { name: 'link'; query: 'link/string()' }
        XmlRole { name: 'created'; query: 'created/string()' }
        XmlRole { name: 'updated'; query: 'updated/string()' }
    }
    XmlListModel {
        id: categoriesModel
        xml: faqModel.contents
        query: '/data/item/(category1|category2)'

        XmlRole { name: 'category'; query: 'string()' }
    }

    MessageDialog {
        id: infoDialog
        title: qsTr('Informació')
        text: qsTr("Pròximament, en una propera actualització de l'aplicació!")
        standardButtons: StandardButton.Ok
        onAccepted: infoDialog.close()
    }

    function collaborate() {
        var mailComunicacioAD = 'comunicacioad@gmail.com';
        Qt.openUrlExternally('mailto:"' + encodeURIComponent('Comunicacio AD') + '" <' + mailComunicacioAD + '>' + '?subject=' + encodeURIComponent('[FAQ] Participar a les PMF'));
    }

    function getHelpText() {
        return "<p>No trobes allò que cerques en aquesta secció?</p><p>Possiblement no hi sigui. Per solucionar-ho, pots col·laborar de dues maneres. Per una banda, suggerir informacions que et resultarien imprescindibles o, per l'altra, oferint la teva ajuda per ampliar el que hi ha en aquesta secció.</p><p>En qualsevol cas, clica sobre la secció <b>Com puc col·laborar a les PMF</b> que podràs trobar dins la llista. D'aquesta manera podràs enviar un correu electrònic per poder posar-hi remei.</p>";
    }


    Component.onCompleted: faqModel.llegeixOnline()

}
