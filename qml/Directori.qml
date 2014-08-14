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

    Bloc assemblea: http://pixabay.com/es/nota-de-papel-oficina-pasador-23618/
    Agenda verda: http://pixabay.com/es/programa-programaci%C3%B3n-calendario-152918/
    Formularis: http://pixabay.com/es/bol%C3%ADgrafo-pluma-formulario-de-papel-147645/
    Reculls de premsa: http://pixabay.com/es/peri%C3%B3dico-diario-noticias-de-papel-295480/
    Alo Camps: http://pixabay.com/es/signo-punto-verde-icono-azul-mark-40876/
    Incidencies: http://pixabay.com/es/rojo-signo-equipo-parada-icono-31176/
    Videos Assemblea: http://pixabay.com/es/cine-clapboard-claqueta-director-154392/
    Facebook: http://pixabay.com/es/mano-como-pulgar-hasta-confirmar-157251/
    Twitter: http://pixabay.com/es/mascota-azul-dibujos-animados-ave-48563/
    Butlletí: http://pixabay.com/es/carta-correo-electr%C3%B3nico-enviar-97861/
    A Balears Volem: http://pixabay.com/es/demostrador-manifestante-signo-154201/
    Taula Educativa: http://pixabay.com/es/torre-antigua-de-radio-electr%C3%B3nica-36800/
    DÈBAT: http://pixabay.com/es/autob%C3%BAs-escolar-la-escuela-296824/
    Biblioteca de Recursos: http://pixabay.com/es/los-libros-pila-universidad-308785/
*/


import QtQuick 2.2
import 'qrc:///Core/core' as Core

Rectangle {
    id: directori
    color: 'transparent'
    anchors.margins: units.nailUnit

    signal obrePagina(string pagina, var opcions)
    signal goBack()

    property int realButtonSize: Math.round(units.fingerUnit * 3.5)
    property int requiredButtonSize: units.fingerUnit * 4
    property int buttonSpacing: units.fingerUnit * 4
    property bool working: true

    Core.UseUnits { id: units }

    Core.MainBar {
        id: mainBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        pageTitle: qsTr('Directori')
        onGoBack: directori.goBack()

    }

    Loader {
        id: gridLoader
        z: 2
        property int availableSpace: parent.width - 2 * anchors.margins
        property int numberOfButtonsPerRow: Math.floor(availableSpace / requiredButtonSize)

        anchors.top: mainBar.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: numberOfButtonsPerRow * requiredButtonSize

        anchors.bottom: parent.bottom
        anchors.margins: units.nailUnit

        sourceComponent: gridComponent
        asynchronous: true
    }

    /*
    Text {
        anchors.fill: gridLoader
        font.pixelSize: units.readUnit
        text: qsTr('Carregant...')
    }
    */

    Component {
        id: gridComponent

        GridView {
            id: grid
            cellHeight: requiredButtonSize
            cellWidth: requiredButtonSize
            clip: true
            cacheBuffer: requiredButtonSize * 15

            model: ListModel { id: menuModel }
            delegate: Item {
                width: requiredButtonSize
                height: requiredButtonSize
                ButtonBox {
                    id: botoBox
                    anchors.centerIn: parent
                    width: realButtonSize
                    height: realButtonSize
                    anchors.margins: units.nailUnit
                    color: model.color
                    title: model.titol
                    image: 'qrc:///Imatges/imatges/' + model.imatge + '.svg'
                    opacity: 1
                    onOpened: obrePagina(model.pagina,{})
                }
            }

            function inicialitza() {
                working = true;
                menuModel.append({color: 'yellow', titol: qsTr('Bloc assemblea'), imatge: 'note-23618', pagina: 'BlocAssemblea'});
                menuModel.append({color: '#44ff44', titol: qsTr('Agenda verda'), imatge: 'agenda-152918', pagina: 'AgendaVerda'});
                menuModel.append({color: '#aaaaff', titol: qsTr('Formularis'), imatge: 'ballpoint-147645', pagina: 'Formularis'});
                menuModel.append({color: '#f78181', titol: qsTr('Reculls de premsa'), imatge: 'newspaper-295480', pagina: 'RecullPremsa'});
//                menuModel.append({color: '#ECF6CE', titol: qsTr('Aló Camps'), imatge: 'sign-40876', pagina: 'AloCamps'});
//                menuModel.append({color: '#ffdddd', titol: qsTr('Incidències'), imatge: 'red-31176', pagina: 'Incidencies'});
                menuModel.append({color: '#F3E2A9', titol: qsTr('Vídeos assemblea'), imatge: 'cinema-154392', pagina: 'CanalYoutube'});
                menuModel.append({color: '#045FB4', titol: qsTr('Facebook'), imatge: 'hand-157251', pagina: 'FacebookAssemblea'});
                menuModel.append({color: '#D8CEF6', titol: qsTr('Twitter'), imatge: 'mascot-48563', pagina: 'TwitterAssemblea'});
                menuModel.append({color: '#2EFE2E', titol: qsTr('Butlletí'), imatge: 'letter-97861', pagina: 'ButlletiAssemblea'});
                menuModel.append({color: '#eeeeee', titol: qsTr('A Balears Volem'), imatge: 'demonstrator-154201', pagina: 'ABalearsVolem'});
                menuModel.append({color: '#F7D358', titol: qsTr('Taula Educativa'), imatge: 'tower-36800', pagina: 'RadioTaulaEducativa'});
                menuModel.append({color: 'white', titol: qsTr('DÈBAT'), imatge: 'school-bus-296824', pagina: 'DocenciaBalearTour'});
                menuModel.append({color: 'green', titol: qsTr('BRADIB'), imatge: 'books-308785', pagina: 'BibliotecaRecursos'});
                working = false;
            }

            Component.onCompleted: inicialitza()
        }
    }
    Image {
        anchors.fill: gridLoader
        anchors.margins: units.nailUnit
        z: 1
        source: 'qrc:///Imatges/imatges/Logo assemblea docents.png'
        fillMode: Image.PreserveAspectFit
        smooth: true
        opacity: 0.25
    }
    Text {
        visible: working
        anchors.fill: gridLoader
        text: qsTr('Carregant...');
    }


}
