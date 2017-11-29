import QtQuick 2.5
import QtQuick.XmlListModel 2.0
import PersonalTypes 1.0

Item {
    id: feedModel

    property string source: 'http://assembleadocentsib.blogspot.com/feeds/posts/default'
    property alias postsModel: postsSqlModel

    function downloadData() {
        var doc = new XMLHttpRequest();
        doc.onload = function(e) {
            console.error(e);
        }

        doc.onreadystatechange = function() {
            if ((doc.readyState === XMLHttpRequest.DONE)) {
                console.log('Estat DONE');
                console.log('Status ' + doc.status + '-' + doc.statusText);
                var text = doc.responseText;

                if ((text) && (text != '')) {
                    analyzeData(text, doc.responseXML);
                }
            }
        }
        // console.log('Getting source ' +source);
        doc.open('GET',source,true);
        doc.send(null);
    }

    function analyzeData(text, xml) {
        // Convert data into feeds and posts

        onlyFeedsModel.xml = text;
        postsModel.xml = text;
    }

    function saveModels() {
        console.log('feed count', onlyFeedsModel.count);

        if ((onlyFeedsModel.status == XmlListModel.Ready) && (postsModel.status == XmlListModel.Ready)) {
            if (onlyFeedsModel.count == 1) {
                // Remove previous feed and posts in database not marked as saved.
                postsSqlModel.removeObjects('saved=0 AND feed IN (SELECT id FROM feeds WHERE source=?)', [feedModel.source]);
                feedsSqlModel.removeObjects('source=?',[feedModel.source]);

                // Insert new feed data
                var oneFeed = onlyFeedsModel.get(0);
                var feedId = feedsSqlModel.insertObject(
                            {
                                source: feedModel.source,
                                name: oneFeed['name'],
                                title: oneFeed['title'],
                                subtitle: oneFeed['subtitle'],
                                permalink: oneFeed['permalink'],
                                updated: oneFeed['updated'],
                                categories: ''
                            });
                console.log('feed id', feedId);

                // Insert new posts
                if (feedId >= 0) {
                    for (var i=0; i<postsModel.count; i++) {
                        var onePost = postsModel.get(i);

                        postsSqlModel.insertObject(
                                    {
                                        feed: feedId,
                                        title: onePost['title'],
                                        content: onePost['content'],
                                        published: onePost['published'],
                                        updated: onePost['updated'],
                                        author: onePost['author'],
                                        permalink: onePost['permalink'],
                                        saved: 0
                                    });
                    }
                }

                // Update model
                postsSqlModel.select();
                console.log('sql count', postsSqlModel.count);

            } else {
                console.log('Feed count mismatch', onlyFeedsModel.count);
            }
        }
    }

    XmlListModel {
        id: onlyFeedsModel

        query: '/feed'
        namespaceDeclarations: "declare default element namespace 'http://www.w3.org/2005/Atom';"

        XmlRole { name: 'title'; query: 'title/string()' }
        XmlRole { name: 'subtitle'; query: 'subtitle/string()' }
        XmlRole { name: 'permalink'; query: "link[@rel='self']/string()" }
        XmlRole { name: 'updated'; query: 'updated/string()' }

        onStatusChanged: saveModels()
    }

    XmlListModel {
        id: postsModel

        query: '/feed/entry'
        namespaceDeclarations: "declare default element namespace 'http://www.w3.org/2005/Atom';"

        XmlRole { name: 'title'; query: 'title/string()' }
        XmlRole { name: 'content'; query: 'content/string()' }
        XmlRole { name: 'updated'; query: 'updated/string()' }
        XmlRole { name: 'published'; query: 'published/string()' }
        XmlRole { name: 'author'; query: 'author/name/string()' }
        XmlRole { name: 'permalink'; query: "link[@rel='alternate']/@href/string()" }

        onStatusChanged: saveModels()
    }

    SqlTableModel {
        id: feedsSqlModel

        primaryKey: 'id'
        tableName: 'feeds'
        fieldNames: ['id', 'source', 'name', 'title', 'subtitle', 'permalink', 'updated', 'categories']
    }

    SqlTableModel {
        id: postsSqlModel

        primaryKey: 'id'
        tableName: 'feedPosts'
        fieldNames: ['id','feed', 'title', 'content', 'published', 'updated', 'author', 'permalink', 'saved']
    }

    Timer {
        id: loadingTimer

        running: true
        interval: 1000 * 60
        repeat: true
        triggeredOnStart: true

        onTriggered: downloadData()
    }

    function reloadContents() {
        loadingTimer.restart();
    }
}
