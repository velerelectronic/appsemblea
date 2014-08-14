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
import QtQuick.Window 2.1
import QtQuick.Layouts 1.1
import 'qrc:///Core/core' as Core
import 'qrc:///Javascript/javascript/Storage.js' as Storage


Window {
    id: mainWindow
    visible: true
    width: Screen.width
    height: Screen.height
    color: 'black'
    property bool isVertical: height > width
    property string paginaInicial: 'Portada'
    property int midaMainBar: Math.round(units.fingerUnit * 1.5)
    property bool showMainBar: false
    property var navegacio: []

    Rectangle {
        id: rectWindow
        anchors.fill: parent
        color: 'white'
        states: [
            State {
                name: 'complet'
                PropertyChanges {
                    target: rectWindow
                    opacity: 1.0
                }
            },
            State {
                name: 'inicial'
                PropertyChanges {
                    target: rectWindow
                    opacity: 0.0
                }
            }
        ]
        state: 'inicial'

        transitions: [
            Transition {
                PropertyAnimation {
                    properties: 'opacity'
                    easing.type: Easing.InOutQuad
                    duration: 500
                }
            }
        ]

        Keys.onPressed: {
            if (event.key == Qt.Key_Back) {
                event.accepted = true;
                obrePaginaInicial();
            }
        }

        Core.UseUnits {
            id: units
        }

        Item {
            id: espaiPagines
            anchors.fill: parent

            // Tenim dos carregadors de pàgines per fer més fluïts els canvis de pàgina

            Loader {
                id: pageLoader
                anchors.fill: parent
                z: 2

                onWidthChanged: (progressAnimation.running)?progressAnimation.restart():false
                onLoaded: {
                    rectWindow.state = 'complet';

                    if (typeof(pageLoader.item.showMainBar) != 'undefined')
                        showMainBar = pageLoader.item.showMainBar;
                    else
                        showMainBar = true;
                }
                Connections {
                    ignoreUnknownSignals: true
                    target: pageLoader.item
                    onObrePagina: obrePagina(pagina,opcions)
                    onGoBack: obrePaginaEnrere()
                    onWorkingChanged: (pageLoader.item.working)?progressAnimation.restart():progressAnimation.stop()
                }
                Component.onCompleted: obrePaginaInicial()
            }
        }

        Rectangle {
            // Barra de progrés que es mostra quan es carreguen les pàgines
            z: 3
            id: progress
            anchors.top: espaiPagines.top
            anchors.horizontalCenter: espaiPagines.horizontalCenter
            anchors.margins: 0
            color: 'green'
            height: units.nailUnit
            width: 0
            visible: progressAnimation.running

            PropertyAnimation {
                id: progressAnimation
                target: progress
                property: 'width'
                running: false
                loops: Animation.Infinite
                from: 0
                to: espaiPagines.width + 2 * units.nailUnit
                duration: 1000
            }
        }
    }

    function obrePagina(pagina,opcions) {
        navegacio.push({pagina: pagina,opcions:opcions});
        pageLoader.setSource(pagina + '.qml', opcions);
    }

    function obrePaginaInicial() {
        obrePagina(paginaInicial,{});
    }

    function obrePaginaEnrere() {
        if (navegacio.length>1) {
            navegacio.pop();
            var anterior = navegacio.pop();
            obrePagina(anterior.pagina,anterior.opcions);
        }
    }

    Component.onCompleted: {
        mainWindow.visible = true;
        Storage.initDatabase();
    }
}
