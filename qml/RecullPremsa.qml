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
import QtQuick.Layouts 1.1
import QtQuick.XmlListModel 2.0
import tipuspersonals 1.0
import QtQuick.Dialogs 1.1
import 'qrc:///Javascript/javascript/Dates.js' as Dates
import 'qrc:///Core/core' as Core

Core.FeedView {
    id: feedView

    Core.UseUnits { id: units }

    property bool working: feedModel.statusCache == XmlListModel.Loading

    titol: qsTr('Reculls de premsa')
    model: feedModel
    statusCache: feedModel.statusCache
    formatSectionDate: false

    feedDelegate: Core.FeedDelegate {
        width: parent.width
        textTitol: titol
        textContingut: '<p>' + media + '</p><p>' + titol + '</p><p><a href="'+ urlAlternate + '">' + urlAlternate + '</a></p>'
        enllac: urlAlternate
        index: model.index
    }

    Core.CachedModel {
        id: feedModel
        source: 'https://docs.google.com/spreadsheets/d/1Z1sec6V9kzxmrsG1UYOrKFRHhWiF6McZLfRqlS6DNlM/pubhtml'
        query: '//table/tbody/tr[position()>1]'
        categoria: 'recullPremsa'
        typeFiltra: true

        XmlRole { name: 'grup'; query: 'td[1]/string()' }
        XmlRole { name: 'media'; query: 'td[2]/string()' }
        XmlRole { name: 'titol'; query: 'normalize-space(td[3]/string())' }
        XmlRole { name: 'contingut'; query: 'td[3]/string()' }
        XmlRole { name: 'urlAlternate'; query: 'normalize-space(td[4]/string())' }
    }

    onReload: feedModel.llegeixOnline()
}
