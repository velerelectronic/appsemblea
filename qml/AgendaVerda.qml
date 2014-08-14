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

    titol: qsTr('Agenda Verda')
    model: feedModel
    statusCache: feedModel.statusCache
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

    Core.CachedModel {
        id: feedModel

        source: 'http://www.agendaverdadocents.cat/esdeveniments/feed/'
        query: '/rss/channel/item'
        //namespaceDeclarations: "declare default element namespace 'http://www.w3.org/2005/Atom';"
        categoria: 'agendaVerda'
        typeFiltra: false

        XmlRole { name: 'titol'; query: 'title/string()' }
        XmlRole { name: 'descripcio'; query: 'description/string()' }
        XmlRole { name: 'publicat'; query: 'pubDate/string()' }
        XmlRole { name: 'grup'; query: 'pubDate/string()' }
        XmlRole { name: 'enllac'; query: "link/string()" }

    }

    onReload: feedModel.llegeixOnline()
}

