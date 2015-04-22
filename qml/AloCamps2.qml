import QtQuick 2.2
import QtQuick.XmlListModel 2.0
import QtQuick.Layouts 1.1
import 'qrc:///Javascript/javascript/Dates.js' as Dates
import 'qrc:///Core/core' as Core

Core.FeedView {
    id: feedView

    Core.UseUnits { id: units }

    titol: qsTr('Alo Riera')
    homePage: 'http://aloconsellera2.wordpress.com/'

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

        source: 'https://script.google.com/macros/s/AKfycbw6qq6UasD3eZckBwfIf-sOCDpR93qdb35CYZhFc7f7PQMX9WlY/exec?opt=alo2'
        categoria: 'aloCamps'
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
        XmlRole { name: 'contingut'; query: 'content/string()' }
        XmlRole { name: 'updated'; query: 'updated/string()' }
        XmlRole { name: 'publicat'; query: 'published/string()' }
        XmlRole { name: 'grup'; query: 'published/substring-before(string(),"T")' }
        XmlRole { name: 'urlAlternate'; query: "link[@rel='alternate']/@href/string()" }
    }

    onReload: cachedModel.llegeixOnline()
}

