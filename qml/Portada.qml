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
import QtQuick.XmlListModel 2.0
import QtGraphicalEffects 1.0
import 'qrc:///Core/core' as Core
import 'qrc:///Javascript/javascript/Storage.js' as Storage


Rectangle {
    Core.UseUnits { id: units }

    signal obrePagina(string pagina,var opcions)
    property int alturaSeccions: units.fingerUnit
    property bool showMainBar: false
    property string colorTitulars: '#D0FA58' // '#ECF6CE'

    anchors.fill: parent

    color: 'white'

    Rectangle {
        id: barraBotons
        anchors.top: parent.top
        height: childrenRect.height
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: units.nailUnit
        color: 'transparent'

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: Math.max(botoActualitza,botoDirectori,botoContactes /*,botoConfiguracio */)
            spacing: units.nailUnit

            Item {
                Layout.fillWidth: true
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
                id: botoContactes
                color: 'white'
                text: qsTr('Contactes')
                onClicked: obrePagina('Contactes',{})
            }

            /*
            Core.Button {
                id: botoConfiguracio
                color: 'white'
                text: qsTr('Configuració')
            }
            */

            Item {
                Layout.fillWidth: true
            }
        }
    }

    Item {
        id: continguts
        anchors.top: barraBotons.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: units.nailUnit
        clip: true

        Image {
            id: imatgeFons
            anchors.fill: parent
            source: 'qrc:///Imatges/imatges/Logo assemblea docents.png'
            fillMode: Image.PreserveAspectFit
            smooth: true
            opacity: 0.5
        }

        Flickable {
            id: flickContents
            anchors.fill: parent
            anchors.margins: units.nailUnit
            clip: false
            topMargin: (contentHeight>=height)?0:Math.round((height-contentHeight)/2)

            flickableDirection: Flickable.VerticalFlick
            contentHeight: titularsItem.height
            contentWidth: titularsItem.width

            Rectangle {
                id: titularsItem

                color: 'transparent'
                height: childrenRect.height
                width: flickContents.width

                ColumnLayout {
                    id: layoutTitulars
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: totalHeight
                    spacing: Math.round(parent.height / 20)
                    property int margesGlobal: units.fluentMargins(width,units.nailUnit)
                    property int totalHeight: infoBloc.height + infoPremsa.height + infoAgenda.height + 2 * spacing

                    TitularView {
                        id: infoBloc
                        Layout.preferredHeight: height
                        Layout.preferredWidth: Math.min(parent.width,units.maximumReadWidth) - 2 * layoutTitulars.margesGlobal
                        Layout.alignment: Qt.AlignHCenter
                        marges: layoutTitulars.margesGlobal
                        color: colorTitulars
                        model: feedModelBloc
                        etiqueta: qsTr("Informacions de l'assemblea")
                        midaTitular: units.readUnit
                        resumeix: false
                        onClicTitular: obrePagina('BlocAssemblea',{})
                    }

                    TitularView {
                        id: infoPremsa
                        Layout.preferredHeight: height
                        Layout.preferredWidth: Math.min(parent.width,units.maximumReadWidth) - 2 * layoutTitulars.margesGlobal
                        Layout.alignment: Qt.AlignHCenter
                        marges: layoutTitulars.margesGlobal
                        color: colorTitulars
                        model: feedModelPremsa
                        etiqueta: qsTr("En els mitjans de comunicació")
                        midaTitular: units.readUnit
                        resumeix: false
                        onClicTitular: obrePagina('RecullPremsa',{})
                    }

                    TitularView {
                        id: infoAgenda
                        Layout.preferredHeight: height
                        Layout.preferredWidth: Math.min(parent.width,units.maximumReadWidth) - 2 * layoutTitulars.margesGlobal
                        Layout.alignment: Qt.AlignHCenter
                        marges: layoutTitulars.margesGlobal
                        color: colorTitulars
                        model: feedModelAgenda
                        etiqueta: qsTr("Propers esdeveniments")
                        midaTitular: units.readUnit
                        resumeix: false
                        onClicTitular: obrePagina('AgendaVerda',{})
                    }
                }

            }

        }
    }




    Core.CachedModel {
        id: feedModelBloc
        source: 'http://assembleadocentsib.blogspot.com/feeds/posts/default'
        query: '/feed/entry[1]'
        namespaceDeclarations: "declare default element namespace 'http://www.w3.org/2005/Atom';"
        categoria: 'blocAssemblea'
        typeFiltra: false

        XmlRole { name: 'titol'; query: 'title/string()' }
        XmlRole { name: 'altres'; query: 'published/substring-before(string(),"T")' }

        onOnlineDataLoaded: infoBloc.carregant = false;
    }

    Core.CachedModel {
        id: feedModelPremsa
        source: 'https://docs.google.com/spreadsheets/d/1Z1sec6V9kzxmrsG1UYOrKFRHhWiF6McZLfRqlS6DNlM/pubhtml'
        query: '//table/tbody/tr[2]'
        categoria: 'recullPremsa'
        typeFiltra: true

        XmlRole { name: 'titol'; query: 'normalize-space(td[3]/string())' }
        XmlRole { name: 'altres'; query: "concat(td[1]/string(),' ', td[2]/string())" }

        onOnlineDataLoaded: infoPremsa.carregant = false;
    }

    Core.CachedModel {
        id: feedModelAgenda
        source: 'http://www.agendaverdadocents.cat/esdeveniments/feed/'
        query: '/rss/channel/item[1]'
        categoria: 'agendaVerda'
        typeFiltra: false

        XmlRole { name: 'titol'; query: 'title/string()' }
        XmlRole { name: 'altres'; query: 'pubDate/string()' }

        onOnlineDataLoaded: infoAgenda.carregant = false;
    }

    function llegeixFeeds() {
        infoBloc.carregant = true;
        feedModelBloc.llegeixOnline();

        infoPremsa.carregant = true;
        feedModelPremsa.llegeixOnline();

        infoAgenda.carregant = true;
        feedModelAgenda.llegeixOnline();
    }
}

