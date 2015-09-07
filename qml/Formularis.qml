import QtQuick 2.2
import QtQuick.XmlListModel 2.0
import 'qrc:///Javascript/javascript/Dates.js' as Dates
import 'qrc:///Core/core' as Core

Core.FeedView {
    id: feedView

    Core.UseUnits { id: units }

    signal obrePagina(string pagina, var opcions)

    titol: qsTr('Formularis')
    homePage: ''
    model: feedModel
    formatSectionDate: false

    feedDelegate: Core.FeedDelegate {
        width: parent.width
        textTitol: model.titol
        textContingut: '<p>' + model.titol + '</p><p>' + model.grup + '</p><p>Vàlid' + ((model.inici!=='')?(' des de ' + model.inici):'') + ((model.final!=='')?(' fins a ' + model.final):'') + '</p><p><a href="'+ model.urlAlternate + '">Emplena!</a></p>'
        copiaContingut: model.titol
        enllac: urlAlternate
        index: model.index
    }

    detailFeedDelegate: Core.DetailFeedDelegate {
        width: parent.parent.width
        height: parent.height
        titol: model.titol
        contingut:  '<p>' + model.titol + '</p><p>' + model.grup + '</p><p>Vàlid' + ((model.inici!=='')?(' des de ' + model.inici):'') + ((model.final!=='')?(' fins a ' + model.final):'') + '</p><p><a href="'+ model.urlAlternate + '">Emplena!</a></p>'
        enllac: urlAlternate

        openExternally: false
        onLinkActivated: feedView.obrePagina('MostraFormulari', {url: link})
    }

    Core.CachedModel {
        id: cachedModel
        source: 'https://docs.google.com/spreadsheets/d/1ywYpbHJatDW0JZbC4NRayhp1H4_dFaNiWeZ0_3aRlLg/pubhtml'
        categoria: 'formularisAD'
        typeFiltra: true
        typeFiltraHtml: true
    }
    statusCache: cachedModel.statusCache
    lastUpdate: cachedModel.lastUpdate

    XmlListModel {
        id: feedModel
        xml: cachedModel.contents
        query: '//table/tbody/tr[position()>1]'

        XmlRole { name: 'titol'; query: 'normalize-space(td[1]/string())' }
        XmlRole { name: 'grup'; query: 'td[2]/string()' }
        XmlRole { name: 'inici'; query: 'normalize-space(td[3]/string())' }
        XmlRole { name: 'final'; query: 'normalize-space(td[4]/string())' }
        XmlRole { name: 'urlAlternate'; query: 'normalize-space(td[5]/string())' }
    }

    onReload: cachedModel.llegeixOnline()
}
