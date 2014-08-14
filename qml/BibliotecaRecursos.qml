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

    titol: qsTr('Biblioteca de recursos')
    model: feedModel
    statusCache: feedModel.statusCache
    formatSectionDate: true

    feedDelegate: Core.FeedDelegate {
        width: parent.width
        textTitol: titol
        textContingut: contingut
        enllac: urlAlternate
        index: model.index
    }

    Core.CachedModel {
        id: feedModel

        source: 'http://bradib.assembleadocentsib.cat/spip.php?page=backend'
        query: '/rss/channel/item'
//        namespaceDeclarations: "declare default element namespace 'http://www.w3.org/2005/Atom';"
        categoria: 'blocAssemblea'
        typeFiltra: false

        XmlRole { name: 'titol'; query: 'title/string()' }
        XmlRole { name: 'contingut'; query: 'description/string()' }
        XmlRole { name: 'updated'; query: 'updated/string()' }
        XmlRole { name: 'publicat'; query: 'published/string()' }
        XmlRole { name: 'grup'; query: 'published/substring-before(string(),"T")' }
        XmlRole { name: 'urlAlternate'; query: "link[@rel='alternate']/@href/string()" }
    }

    onReload: feedModel.llegeixOnline()
}
