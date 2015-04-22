import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.XmlListModel 2.0
import tipuspersonals 1.0
import QtQuick.Dialogs 1.1
import 'qrc:///Javascript/javascript/Dates.js' as Dates
import 'qrc:///Core/core' as Core

Core.FeedView {
    id: feedView

    Core.UseUnits { id: units }

    titol: qsTr('Reculls de premsa')
    homePage: 'https://docs.google.com/spreadsheets/d/1Z1sec6V9kzxmrsG1UYOrKFRHhWiF6McZLfRqlS6DNlM/edit?usp=sharing'
    model: feedModel
    formatSectionDate: false

    feedDelegate: Core.FeedDelegate {
        width: parent.width
        textTitol: titol + ' (' + media + ' - ' + signat + ')'
        textContingut: '<p>' + media + ' - ' + signat + '</p><p>' + titol + '</p><p><a href="'+ urlAlternate + '">' + urlAlternate + '</a></p>'
        enllac: urlAlternate
        index: model.index
    }

    detailFeedDelegate: Core.DetailFeedDelegate {
        width: parent.parent.width
        height: parent.height
        titol: model.titol + ' (' + media + ' - ' + signat + ')'
        contingut: '<p>' + media + ' - ' + signat + '</p><p>' + titol + '</p><p><a href="'+ urlAlternate + '">' + urlAlternate + '</a></p>'
        enllac: urlAlternate
    }

    Core.CachedModel {
        id: cachedModel
        source: 'https://script.google.com/macros/s/AKfycby9ntz2iJ9hhQ5hB2-wktnlxJjBDsHY7YyBF4Mpj3LzGPBmJvGc/exec'
        categoria: 'recullPremsa'
        typeFiltra: true
    }

    /*
    Core.CachedModel {
        id: cachedModel
        source: 'https://docs.google.com/spreadsheets/d/1Z1sec6V9kzxmrsG1UYOrKFRHhWiF6McZLfRqlS6DNlM/pubhtml'
        categoria: 'recullPremsa'
        typeFiltra: true
    }
    */

    statusCache: cachedModel.statusCache
    lastUpdate: cachedModel.lastUpdate

    XmlListModel {
        id: feedModel
        xml: cachedModel.contents
        query: '//feed/entry'

        XmlRole { name: 'grup'; query: 'updated/string()' }
        XmlRole { name: 'media'; query: 'source/string()' }
        XmlRole { name: 'titol'; query: 'title/string()' }
        XmlRole { name: 'contingut'; query: 'title/string()' }
        XmlRole { name: 'signat'; query: 'author/string()' }
        XmlRole { name: 'urlAlternate'; query: 'link/string()' }
    }

    /*
    XmlListModel {
        id: feedModel
        xml: cachedModel.contents
        query: '//table/tbody/tr[position()>1]'

        XmlRole { name: 'grup'; query: 'td[1]/string()' }
        XmlRole { name: 'media'; query: 'td[2]/string()' }
        XmlRole { name: 'titol'; query: 'normalize-space(td[3]/string())' }
        XmlRole { name: 'contingut'; query: 'td[3]/string()' }
        XmlRole { name: 'signat'; query: 'normalize-space(td[5]/string())' }
        XmlRole { name: 'urlAlternate'; query: 'normalize-space(td[4]/string())' }

        //onXmlChanged: console.log(xml)
    }
    */

    onReload: cachedModel.llegeixOnline()
}
