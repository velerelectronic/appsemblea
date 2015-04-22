import QtQuick 2.2
import QtQuick.XmlListModel 2.0
import 'qrc:///Javascript/javascript/Dates.js' as Dates
import 'qrc:///Core/core' as Core

Core.FeedView {
    id: feedView

    Core.UseUnits { id: units }

    titol: qsTr('Incidències')
    homePage: "http://assembleadocentsib.wordpress.com/"
    model: feedModel

    formatSectionDate: false
    feedDelegate: Core.FeedDelegate {
        width: parent.width
        textTitol: model.titol
        textContingut: grup + descripcio
        enllac: model.enllac
        index: model.index
    }

    detailFeedDelegate: Core.DetailFeedDelegate {
        width: parent.parent.width
        height: parent.height
        titol: model.titol
        contingut: grup + descripcio
        enllac: model.enllac
    }

    Core.CachedModel {
        id: cachedModel
        source: 'https://script.google.com/macros/s/AKfycbw6qq6UasD3eZckBwfIf-sOCDpR93qdb35CYZhFc7f7PQMX9WlY/exec?opt=incidencies'
        categoria: 'incidencies'
        typeFiltra: true
    }
    statusCache: cachedModel.statusCache
    lastUpdate: cachedModel.lastUpdate

    XmlListModel {
        id: feedModel
        xml: cachedModel.contents
        query: '/feed/entry'
        namespaceDeclarations: "declare default element namespace 'http://www.w3.org/2005/Atom';"

        XmlRole { name: 'titol'; query: 'title/string()' }
        XmlRole { name: 'descripcio'; query: 'content/string()' }
        XmlRole { name: 'publicat'; query: 'published/string()' }
        XmlRole { name: 'grup'; query: 'published/string()' }
        XmlRole { name: 'enllac'; query: "link[@rel='alternate']/@href/string()" }
    }

    onReload: cachedModel.llegeixOnline()
}
