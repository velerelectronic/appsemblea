import QtQuick 2.2
import 'qrc:///Core/core' as Core

Core.FeedView {
    id: feedView

    Core.UseUnits { id: units }

    titol: qsTr('Twitter assemblea')
    homePage: 'https://twitter.com/Assembleadocent'
    model: feedModel
    formatSectionDate: false

    feedDelegate: Core.FeedDelegate {
        width: parent.width
        textTitol: titol
        textContingut: contingut
        enllac: urlAlternate
        index: model.index
    }

    detailFeedDelegate: Core.DetailFeedDelegate {
        width: parent.parent.width
        height: parent.height
        titol: model.titol
        contingut: model.contingut
        enllac: urlAlternate
    }

    Core.TweetModel {
        id: feedModel
        from: '@Assembleadocent'
        onOnlineDataLoaded: feedView.loadingBoxState = 'perfect';
    }
//    statusCache: cachedModel.statusCache
//    lastUpdate: cachedModel.lastUpdate

    onReload: feedModel.rellegeixTweets()
}
