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

    anchors.fill: parent
    titol: qsTr('Formularis')
    model: feedModel
    statusCache: feedModel.statusCache
    formatSectionDate: false

    feedDelegate: Core.FeedDelegate {
        width: parent.width
        textTitol: model.titol
        textContingut: '<p>' + model.titol + '</p><p>' + model.grup + '</p><p>Vàlid' + ((model.inici!=='')?(' des de ' + model.inici):'') + ((model.final!=='')?(' fins a ' + model.final):'') + '</p><p><a href="'+ model.urlAlternate + '">Emplena!</a></p>'
        copiaContingut: model.titol
        enllac: urlAlternate
        index: model.index
    }

    Core.CachedModel {
        id: feedModel
        source: 'https://docs.google.com/spreadsheets/d/1ywYpbHJatDW0JZbC4NRayhp1H4_dFaNiWeZ0_3aRlLg/pubhtml'
        query: '//table/tbody/tr[position()>1]'
        categoria: 'formularisAD'
        typeFiltra: true

        XmlRole { name: 'titol'; query: 'normalize-space(td[1]/string())' }
        XmlRole { name: 'grup'; query: 'td[2]/string()' }
        XmlRole { name: 'inici'; query: 'normalize-space(td[3]/string())' }
        XmlRole { name: 'final'; query: 'normalize-space(td[4]/string())' }
        XmlRole { name: 'urlAlternate'; query: 'normalize-space(td[5]/string())' }
    }

    onReload: feedModel.llegeixOnline()
}
