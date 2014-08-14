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
    The following images belong to the public domain:

    CC0 licenses:
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
            height: Math.max(2 * units.fingerUnit,2 * globalMargins,sectionName.contentHeight + 2 * globalMargins,sectionMail.contentHeight + 2 * globalMargins)
            width: parent.width

            RowLayout {
                id: rowContacts
                anchors.fill: parent
                anchors.margins: globalMargins
                spacing: globalMargins
                Text {
                    id: sectionName
                    Layout.preferredWidth: Math.round(parent.width / 3)
                    Layout.fillHeight: true
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    font.pixelSize: units.readUnit
                    font.bold: model.section
                    text: model.title
                }
                Text {
                    id: sectionMail
                    Layout.fillWidth: !model.section
                    Layout.preferredHeight: contentHeight
                    Layout.fillHeight: true
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    font.pixelSize: units.readUnit
                    text: (model.section)?'':model.email
                }
                Core.ImageButton {
                    image: 'pencil-160443'
                    size: units.fingerUnit
                    onClicked: Qt.openUrlExternally('mailto:"' + encodeURIComponent(model.title) + '" <' + model.email + '>' + '?subject=' + encodeURIComponent('[Appsemblea] Propostes o preguntes'));
                }

                Core.ImageButton {
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
        contactModel.append({section: false, title: qsTr('AGENDA VERDA 1'), email: 'iniciatives@agendaverdadocents.cat'});
        contactModel.append({section: false, title: qsTr('AGENDA VERDA 2'), email: 'sospubliceducation@gmail.com'});
        contactModel.append({section: false, title: qsTr('ASSEMBLEA DOCENTS DESCONCERTATS'), email: 'assembleadocentsdesconcertats@autistici.org'});
        contactModel.append({section: false, title: qsTr('DESENVOLUPAMENT APPSEMBLEA'), email: 'developerjmpc@gmail.com'});
    }
}
