import QtQuick 2.2
import QtQuick.XmlListModel 2.0
import 'qrc:///Javascript/javascript/Dates.js' as Dates
import 'qrc:///Core/core' as Core

Core.FeedView {
    id: feedView

    Core.UseUnits { id: units }

    titol: qsTr('Taula Educativa')
    homePage: 'https://www.facebook.com/pages/Taula-Educativa/637930349628129'
    model: feedModel
    formatSectionDate: false

    feedDelegate: Core.FeedDelegate {
        width: parent.width
        textTitol: (titol != '')?titol:(autor + ' ' + grup)
        textContingut: descripcio
        enllac: link
        index: model.index
        Component.onCompleted: console.log(descripcio)
    }

    detailFeedDelegate: Core.DetailFeedDelegate {
        width: parent.parent.width
        height: parent.height
        titol: (model.titol != '')?model.titol:(autor + ' ' + grup)
        contingut: descripcio
        enllac: link
    }

    Core.CachedModel {
        id: cachedModel
        source: 'https://www.facebook.com/feeds/page.php?id=637930349628129&format=rss20'
        categoria: 'radioTaulaEducativa'
        typeFiltra: false
    }
    statusCache: cachedModel.statusCache
    lastUpdate: cachedModel.lastUpdate

    XmlListModel {
        id: feedModel
        xml: cachedModel.contents
        query: '/rss/channel/item'

        XmlRole { name: 'titol'; query: 'normalize-space(title/string())' }
        XmlRole { name: 'autor'; query: 'author/string()' }
        XmlRole { name: 'descripcio'; query: 'description/string()' }
        XmlRole { name: 'publicat'; query: 'pubDate/string()' }
        XmlRole { name: 'grup'; query: 'pubDate/string()' }
        XmlRole { name: 'link'; query: "link/string()" }
    }

    onReload: cachedModel.llegeixOnline()
}

