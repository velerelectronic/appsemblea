import QtQuick 2.2
import QtQuick.XmlListModel 2.0
import 'qrc:///Javascript/javascript/Dates.js' as Dates
import 'qrc:///Core/core' as Core

Core.FeedView {
    id: feedView

    Core.UseUnits { id: units }

    titol: qsTr('Vídeos de l\'assemblea')
    homePage: 'https://www.youtube.com/channel/UCMIw7tVRqjlfnGJrzQgkA5w/'
    model: feedModel
    formatSectionDate: true

    feedDelegate: Core.FeedDelegate {
        width: parent.width
        textTitol: titol
        textContingut: '<p>' + contingut + '</p><img src="' + thumbnail + '" href="' + urlAlternate + '"></img><p><a href="' + urlAlternate + '">Obre el vídeo</a></p>'
        copiaContingut: contingut
        enllac: urlAlternate
        index: model.index
    }

    detailFeedDelegate: Core.DetailFeedDelegate {
        width: parent.parent.width
        height: parent.height
        titol: model.titol
        contingut:  '<p>' + model.contingut + '</p><img src="' + thumbnail + '" href="' + urlAlternate + '"></img><p><a href="' + urlAlternate + '">Obre el vídeo</a></p>'
        enllac: urlAlternate
    }

    Core.CachedModel {
        id: cachedModel
        source: 'https://gdata.youtube.com/feeds/api/users/assembleadocentsib/uploads'
        categoria: 'youtubeAssemblea'
        typeFiltra: false
    }
    statusCache: cachedModel.statusCache
    lastUpdate: cachedModel.lastUpdate

    XmlListModel {
        id: feedModel
        xml: cachedModel.contents
        query: '/feed/entry'
        namespaceDeclarations: "declare default element namespace 'http://www.w3.org/2005/Atom'; declare namespace media='http://search.yahoo.com/mrss/';"

        XmlRole { name: 'titol'; query: 'title/string()' }
        XmlRole { name: 'contingut'; query: 'content/string()' }
        XmlRole { name: 'updated'; query: 'updated/string()' }
        XmlRole { name: 'publicat'; query: 'published/string()' }
        XmlRole { name: 'grup'; query: 'published/substring-before(string(),"T")' }
//        XmlRole { name: 'thumbnail'; query: "media:group/media:thumbnail[0]/@url/string()" }
        XmlRole { name: 'thumbnail'; query: "media:group/media:thumbnail[1]/@url/string()" }
        XmlRole { name: 'urlAlternate'; query: "link[@rel='alternate']/@href/string()" }
    }

    onReload: cachedModel.llegeixOnline()
}
