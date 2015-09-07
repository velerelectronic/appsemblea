import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Layouts 1.1
import QtQuick.XmlListModel 2.0
import QtGraphicalEffects 1.0
import 'qrc:///Core/core' as Core

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

    ListView {
        id: contentsList
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: barraBotons.bottom
            bottom: parent.bottom
            margins: units.nailUnit
        }


        width: Math.min(parent.width,units.maximumReadWidth) - 2 * parent.margesGlobal
        clip: true
        orientation: ListView.Vertical

        topMargin: (contentItem.height >= height)?0:Math.round((height - contentItem.height)/2)

        spacing: Math.round(parent.height / 20)

        model: VisualItemModel {
            TitularView {
                id: infoBloc
                width: contentsList.width
                marges: mainPage.margesGlobal
                color: colorTitulars
                model: feedModelBloc
                etiqueta: qsTr("Informacions de l'assemblea")
                midaTitular: units.readUnit
                resumeix: false
                onClicTitular: obrePagina('BlocAssemblea',{})
            }

            TitularView {
                id: infoPremsa
                width: contentsList.width
                marges: mainPage.margesGlobal
                color: colorTitulars
                model: feedModelPremsa
                etiqueta: qsTr("En els mitjans de comunicació")
                midaTitular: units.readUnit
                resumeix: false
                onClicTitular: obrePagina('RecullPremsa',{})
            }

            TitularView {
                id: infoAgenda
                width: contentsList.width
                marges: mainPage.margesGlobal
                color: colorTitulars
                model: feedModelAgenda
                etiqueta: qsTr("Propers esdeveniments")
                midaTitular: units.readUnit
                resumeix: false
                onClicTitular: obrePagina('AgendaVerda',{})
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

    function testFeature() {
        obrePagina('MostraFormulari',{url: 'https://script.google.com/macros/s/AKfycbzHwbpJ6Qvwkci2oG5cx-Kw0Vs94p3Fpnz2XL9HL6GHyYA4KBg/exec'});
        //obrePagina('MostraFormulari',{url: 'https://script.googleusercontent.com/macros/echo?user_content_key=PxBrKXhF8w4RInN7FL-9wHK8HNUqWPq0T0Ct0xWm5kbNCbuRn0HOLodx84LU4IKOBncVsdmmO_EAlq8Vtsc2mlZg8R9hnTKRm5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnMXDmXPiSJ6jAooIJJ3Xqdx66-9mRZnellyGprim7tgpu_eV19ToCZMIBzRszd5VJdveWPraiRQB&amp;lib=Mamx1sfZKrMwcz-fUC4CiCO7HcjZDuJUr'});
        //obrePagina('MostraFormulari',{url: 'http://assembleadocentsib.blogspot.com/feeds/posts/default'});
        //obrePagina('MostraFormulari',{url: 'https://api.twitter.com/'});
    }
}

