/*
  Llicències CC0:
  - Enviar mail: http://pixabay.com/es/l%C3%A1piz-pluma-editar-bloc-de-notas-160443/
  - Copiar mail: http://pixabay.com/es/copia-documentos-p%C3%A1ginas-97584/
  */

import QtQuick 2.2
import QtQuick.Layouts 1.1
import 'qrc:///Core/core' as Core
import tipuspersonals 1.0
import QtQuick.Dialogs 1.1

Rectangle {
    id: contactes
    color: 'transparent'
    anchors.margins: units.nailUnit

    signal goBack()

    Core.UseUnits { id: units }

    QClipboard { id: clipboard }

    Core.MainBar {
        id: mainBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        pageTitle: qsTr('Contactes')
        onGoBack: contactes.goBack()
    }

    ListView {
        anchors.top: mainBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        clip: true

        model: ListModel {
            id: contactModel
        }

        delegate: Rectangle {
            property int globalMargins: units.fluentMargins(parent.width,units.nailUnit)
            border.color: 'black'
            height: rowContacts.height + globalMargins * 2
            width: parent.width

            RowLayout {
                id: rowContacts
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: Math.max(units.fingerUnit * 2, info.height)
                anchors.margins: globalMargins
                spacing: globalMargins
                Item {
                    id: info
                    property bool arrangeHorizontal: (units.fingerUnit*5 < width/2)
                    Layout.fillWidth: true
                    Layout.preferredHeight: height
                    height: (info.arrangeHorizontal)?(Math.max(sectionName.implicitHeight,sectionMail.contentHeight)):(sectionName.height+sectionMail.height)
                    Text {
                        id: sectionName
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: (info.arrangeHorizontal)?sectionMail.left:parent.right
                        height: contentHeight
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        font.pixelSize: units.readUnit
                        font.bold: model.section
                        text: model.title
                    }
                    Text {
                        id: sectionMail
                        anchors.right: parent.right
                        anchors.top: (info.arrangeHorizontal)?parent.top:sectionName.bottom
                        width: (info.arrangeHorizontal)?(parent.width/2):undefined
                        height: contentHeight
                        anchors.left: (info.arrangeHorizontal)?undefined:parent.left
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        font.pixelSize: units.readUnit
                        text: (model.section)?'':model.email
                    }
                }

                Core.ImageButton {
                    Layout.alignment: Qt.AlignVCenter
                    image: 'pencil-160443'
                    size: units.fingerUnit
                    onClicked: Qt.openUrlExternally('mailto:"' + encodeURIComponent(model.title) + '" <' + model.email + '>' + '?subject=' + encodeURIComponent('[Appsemblea] Propostes o preguntes'));
                }

                Core.ImageButton {
                    Layout.alignment: Qt.AlignVCenter
                    image: 'copy-97584'
                    size: units.fingerUnit
                    onClicked: {
                        clipboard.copia(model.email);
                        infoMessage.mostraInfo(qsTr("S'ha copiat el mail al portapapers."));
                    }
                }
            }
        }
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

    Component.onCompleted: {
        contactModel.append({section: false, title: qsTr('COMITÈ DE VAGA'), email: 'assembleadocentsib@gmail.com'});
        contactModel.append({section: false, title: qsTr('COMUNICACIÓ'), email: 'comunicacioad@gmail.com'});
        contactModel.append({section: false, title: qsTr('MOBILITZACIÓ'), email: 'mobilitzacioad@gmail.com'});
        contactModel.append({section: false, title: qsTr('INCIDÈNCIES ALS CENTRES'), email: 'incidenciesad@gmail.com'});
        contactModel.append({section: false, title: qsTr('SUBHASTA OBRES D\'ART'), email: 'artiresistencia@gmail.com'});
        contactModel.append({section: false, title: qsTr('FONS D\'IMATGES'), email: 'imatgesad@gmail.com'});
        contactModel.append({section: false, title: qsTr('CAIXA RESISTÈNCIA'), email: 'caixaderesistencia@gmail.com'});
        contactModel.append({section: false, title: qsTr('ESTRATÈGIES'), email: 'comiteestrategiesad@gmail.com'});
        contactModel.append({section: false, title: qsTr('AFERS EXTERIORS'), email: 'afersexteriorsad@gmail.com'});
        contactModel.append({section: false, title: qsTr('AGENDA VERDA'), email: 'agendaverda@gmail.com'});
        contactModel.append({section: false, title: qsTr('ASSEMBLEA DOCENTS DESCONCERTATS'), email: 'assembleadocentsdesconcertats@autistici.org'});
        contactModel.append({section: false, title: qsTr('COMISSIÓ JURÍDICA'), email: 'comissiojuridicaad@gmail.com'});
        contactModel.append({section: false, title: qsTr('DESENVOLUPAMENT APPSEMBLEA'), email: 'developerjmpc@gmail.com'});
    }
}
