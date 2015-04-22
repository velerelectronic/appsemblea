import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Layouts 1.1
import QtQuick.XmlListModel 2.0
import QtGraphicalEffects 1.0
import 'qrc:///Core/core' as Core

Item {
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


    Flickable {
        id: flickContents
        anchors.top: barraBotons.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: units.nailUnit
        clip: true

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


    Core.CachedModel {
        id: cachedModelBloc
        source: 'http://assembleadocentsib.blogspot.com/feeds/posts/default'
        categoria: 'blocAssemblea'
        typeFiltra: false
        onOnlineDataLoaded: infoBloc.carregant = false;

        XmlListModel {
            id: feedModelBloc
            query: '/feed/entry[1]'
            namespaceDeclarations: "declare default element namespace 'http://www.w3.org/2005/Atom';"
            xml: cachedModelBloc.contents

            XmlRole { name: 'titol'; query: 'title/string()' }
            XmlRole { name: 'altres'; query: 'published/substring-before(string(),"T")' }
        }
    }

    Core.CachedModel {
        id: cachedModelPremsa
        source: 'https://script.google.com/macros/s/AKfycby9ntz2iJ9hhQ5hB2-wktnlxJjBDsHY7YyBF4Mpj3LzGPBmJvGc/exec'
        categoria: 'recullPremsa'
        typeFiltra: true

        XmlListModel {
            id: feedModelPremsa
            query: '//feed/entry[1]'
            xml: cachedModelPremsa.contents

            XmlRole { name: 'titol'; query: "concat(title/string(), ' (', source/string(),'-',author/string(),')')" }
            XmlRole { name: 'altres'; query: "concat(td[1]/string(),' ', td[2]/string())" }
        }

        onOnlineDataLoaded: infoPremsa.carregant = false;
    }

    Core.CachedModel {
        id: cachedModelAgenda
        source: 'http://www.agendaverdadocents.cat/esdeveniments/feed/'
        categoria: 'agendaVerda'
        typeFiltra: false

        XmlListModel {
            id: feedModelAgenda
            query: '/rss/channel/item[1]'
            xml: cachedModelAgenda.contents

            XmlRole { name: 'titol'; query: 'title/string()' }
            XmlRole { name: 'altres'; query: 'pubDate/string()' }
        }

        onOnlineDataLoaded: infoAgenda.carregant = false;
    }

    function llegeixFeeds() {
        infoBloc.carregant = true;
        cachedModelBloc.llegeixOnline();

        infoPremsa.carregant = true;
        cachedModelPremsa.llegeixOnline();

        infoAgenda.carregant = true;
        cachedModelAgenda.llegeixOnline();
    }
}

