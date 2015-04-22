import QtQuick 2.2
import QtQuick.XmlListModel 2.0
import 'qrc:///Javascript/javascript/Dates.js' as Dates
import 'qrc:///Core/core' as Core

Core.FeedView {
    id: feedView

    Core.UseUnits { id: units }

    titol: qsTr('Agenda Verda')
    homePage: 'http://www.agendaverdadocents.cat/esdeveniments/'
    model: feedModel
    formatSectionDate: false

    feedDelegate: Core.FeedDelegate {
        width: parent.width
        textTitol: {
            var data = (new Date()).llegeixDataRSS(publicat);
            return data.escriuDiaSetmana() + ', ' + data.escriuDiaMes() + ' - ' + titol;
        }
        textContingut: '<p>' + grup + '</p><p>' + descripcio + '</p><p><a href="' + enllac + '">Obre l\'esdeveniment</a></p>'
        copiaContingut: grup + descripcio
        enllac: model.enllac
        index: model.index
    }

    detailFeedDelegate: Core.DetailFeedDelegate {
        width: parent.parent.width
        height: parent.height
        titol: {
            var data = (new Date()).llegeixDataRSS(publicat);
            return data.escriuDiaSetmana() + ', ' + data.escriuDiaMes() + ' - ' + model.titol;
        }
        contingut: '<p>' + grup + '</p><p>' + descripcio + '</p><p><a href="' + enllac + '">Obre l\'esdeveniment</a></p>'
        enllac: model.enllac
        copiaContingut: grup + descripcio
    }

    Core.CachedModel {
        id: cachedModel

        source: 'http://www.agendaverdadocents.cat/esdeveniments/feed/'
        categoria: 'agendaVerda'
        typeFiltra: false
    }
    statusCache: cachedModel.statusCache
    lastUpdate: cachedModel.lastUpdate

    XmlListModel {
        id: feedModel
        xml: cachedModel.contents
        query: '/rss/channel/item'
        //namespaceDeclarations: "declare default element namespace 'http://www.w3.org/2005/Atom';"

        XmlRole { name: 'titol'; query: 'title/string()' }
        XmlRole { name: 'descripcio'; query: 'description/string()' }
        XmlRole { name: 'publicat'; query: 'pubDate/string()' }
        XmlRole { name: 'grup'; query: 'pubDate/string()' }
        XmlRole { name: 'enllac'; query: "link/string()" }
    }

    onReload: cachedModel.llegeixOnline()
}

