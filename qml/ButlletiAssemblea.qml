/*
    Appsemblea, an application to keep the assembly of teachers informed
    Copyright (C) 2014 Joan Miquel Payeras Crespí

    This file is part of Appsemblea

    Appsemblea is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 3 of the License.

    Appsemblea is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.2
import QtQuick.XmlListModel 2.0
import 'qrc:///Javascript/javascript/Dates.js' as Dates
import 'qrc:///Core/core' as Core

Core.FeedView {
    id: feedView

    Core.UseUnits { id: units }

    property bool working: feedModel.statusCache == XmlListModel.Loading

    titol: qsTr('Butlletí de notícies')
    model: feedModel
    statusCache: feedModel.statusCache
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

    Core.CachedModel {
        id: feedModel

        source: 'http://us3.campaign-archive2.com/feed?u=6e03bb74776d556676a7d306b&id=0682381565'
        query: '/rss/channel/item'
        //namespaceDeclarations: "declare namespace content='http://purl.org/rss/1.0/modules/content/';"
        categoria: 'butlletiAssemblea'
        typeFiltra: false

        XmlRole { name: 'titol'; query: 'title/string()' }
        XmlRole { name: 'descripcio'; query: 'title/string()' }
        XmlRole { name: 'updated'; query: 'updated/string()' }
        XmlRole { name: 'publicat'; query: 'pubDate/string()' }
        XmlRole { name: 'grup'; query: 'pubDate/string()' }
        XmlRole { name: 'urlAlternate'; query: "link/string()" }

    }

    onReload: feedModel.llegeixOnline()

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
