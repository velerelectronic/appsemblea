import QtQuick 2.2
import QtQuick.XmlListModel 2.0
import 'qrc:///Javascript/javascript/Dates.js' as Dates
import 'qrc:///Core/core' as Core

Core.FeedView {
    id: feedView

    Core.UseUnits { id: units }

    titol: qsTr('Biblioteca de recursos')
    homePage: 'http://bradib.assembleadocentsib.cat'
    model: feedModel
    formatSectionDate: true

    feedDelegate: Core.FeedDelegate {
        width: parent.width
        textTitol: titol
        textContingut: contingut
        enllac: urlAlternate
        index: model.index
    }

    detailFeedDelegate: Core.DetailFeedDelegate {
        width: parent.parent.width
        height: parent.height
        titol: model.titol
        contingut: model.contingut
        enllac: urlAlternate
    }

    Core.CachedModel {
        id: cachedModel

        source: 'http://bradib.assembleadocentsib.cat/spip.php?page=backend'
        categoria: 'blocAssemblea'
        typeFiltra: false
    }
    statusCache: cachedModel.statusCache
    lastUpdate: cachedModel.lastUpdate

    XmlListModel {
        id: feedModel
        xml: cachedModel.contents
        query: '/rss/channel/item'
//        namespaceDeclarations: "declare default element namespace 'http://www.w3.org/2005/Atom';"

        XmlRole { name: 'titol'; query: 'title/string()' }
        XmlRole { name: 'contingut'; query: 'description/string()' }
        XmlRole { name: 'updated'; query: 'updated/string()' }
        XmlRole { name: 'publicat'; query: 'published/string()' }
        XmlRole { name: 'grup'; query: 'published/substring-before(string(),"T")' }
        XmlRole { name: 'urlAlternate'; query: "link[@rel='alternate']/@href/string()" }
    }

    onReload: cachedModel.llegeixOnline()
}
