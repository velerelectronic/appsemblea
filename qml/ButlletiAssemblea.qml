import QtQuick 2.2
import QtQuick.XmlListModel 2.0
import 'qrc:///Javascript/javascript/Dates.js' as Dates
import 'qrc:///Core/core' as Core

Core.FeedView {
    id: feedView

    Core.UseUnits { id: units }

    titol: qsTr('Butlletí de notícies')
    model: feedModel
    formatSectionDate: false

    feedDelegate: Core.FeedDelegate {
        width: parent.width
        textTitol: titol
        textContingut: '<p>' + descripcio + '</p><p><a href="' + urlAlternate + '">Accedeix al butlletí</a></p>'
        copiaContingut: descripcio
        //textContingut: converteixPlainText(descripcio)
        enllac: urlAlternate
        index: model.index
    }

    detailFeedDelegate: Core.DetailFeedDelegate {
        width: parent.parent.width
        height: parent.height
        titol: model.titol
        contingut: '<p>' + descripcio + '</p><p><a href="' + urlAlternate + '">Accedeix al butlletí</a></p>'
        enllac: urlAlternate
        copiaContingut: descripcio
    }

    Core.CachedModel {
        id: cachedModel

        source: 'http://us3.campaign-archive2.com/feed?u=6e03bb74776d556676a7d306b&id=0682381565'
        categoria: 'butlletiAssemblea'
        typeFiltra: false
    }
    statusCache: cachedModel.statusCache
    lastUpdate: cachedModel.lastUpdate

    XmlListModel {
        id: feedModel
        xml: cachedModel.contents
        query: '/rss/channel/item'
        //namespaceDeclarations: "declare namespace content='http://purl.org/rss/1.0/modules/content/';"

        XmlRole { name: 'titol'; query: 'title/string()' }
        XmlRole { name: 'descripcio'; query: 'title/string()' }
        XmlRole { name: 'updated'; query: 'updated/string()' }
        XmlRole { name: 'publicat'; query: 'pubDate/string()' }
        XmlRole { name: 'grup'; query: 'pubDate/string()' }
        XmlRole { name: 'urlAlternate'; query: "link/string()" }

    }

    onReload: cachedModel.llegeixOnline()

    function converteixPlainText(cadena) {
        var linies = cadena.split('\n');
        var resultat = [];

        for (var i=0; i<linies.length; i++) {
            var prefix = linies[i].substr(0,3);
            switch(prefix) {
            case '** ':
                resultat.push('<h3>' + linkify(linies[i].substr(3)) + '</h3>');
                break;
            case '':
                resultat.push('');
                break;
            case '---':
                break;
            default:
                resultat.push('<p>' + linkify(linies[i]) + '</p>');
            }
        }
        return resultat.join('');
    }

    function linkify(text){
        var initial = text;
        if (initial) {
            var resultats = initial.match(/((https?\:\/\/)|(www\.))(\S+)(\w{2,4})(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/gi);
            if (resultats !== null)
                return '<a href="' + resultats[0] + '">' + text + '</a>';
        }
        return initial;
    }


}
