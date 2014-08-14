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

    titol: qsTr('Vídeos de l\'assemblea')
    model: feedModel
    statusCache: feedModel.statusCache
    formatSectionDate: true

    feedDelegate: Core.FeedDelegate {
        width: parent.width
        textTitol: titol
        textContingut: '<p>' + contingut + '</p><img src="' + thumbnail + '" href="' + urlAlternate + '"></img><p><a href="' + urlAlternate + '">Obre el vídeo</a></p>'
        copiaContingut: contingut
        enllac: urlAlternate
        index: model.index
    }

    Core.CachedModel {
        id: feedModel
        source: 'https://gdata.youtube.com/feeds/api/users/assembleadocentsib/uploads'
        query: '/feed/entry'
        namespaceDeclarations: "declare default element namespace 'http://www.w3.org/2005/Atom'; declare namespace media='http://search.yahoo.com/mrss/';"
        categoria: 'youtubeAssemblea'
        typeFiltra: false

        XmlRole { name: 'titol'; query: 'title/string()' }
        XmlRole { name: 'contingut'; query: 'content/string()' }
        XmlRole { name: 'updated'; query: 'updated/string()' }
        XmlRole { name: 'publicat'; query: 'published/string()' }
        XmlRole { name: 'grup'; query: 'published/substring-before(string(),"T")' }
//        XmlRole { name: 'thumbnail'; query: "media:group/media:thumbnail[0]/@url/string()" }
        XmlRole { name: 'thumbnail'; query: "media:group/media:thumbnail[1]/@url/string()" }
        XmlRole { name: 'urlAlternate'; query: "link[@rel='alternate']/@href/string()" }
    }

    onReload: feedModel.llegeixOnline()
}
