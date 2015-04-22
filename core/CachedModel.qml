import QtQuick 2.2
import QtQuick.XmlListModel 2.0
import PersonalTypes 1.0

Item {
    property int statusCache: XmlListModel.Null
    property string source: ''
    property string contents: ''
    property string lastUpdate: ''
    property string categoria: ''
    property bool typeFiltra: false
    property bool typeFiltraHtml: false

    signal onlineDataLoaded

    onOnlineDataLoaded: {
//        console.log('llegint HTML');
        llegeixHtml();
    }

    function llegeixHtml() {
        var obj = dbModel.getObjectInRow(0);
        if ((obj.continguts) && (obj.instantDades)) {
            contents = obj.continguts;
            lastUpdate = obj.instantDades;
        }
        // Storage.llegeixDadesXML(categoria,cachedModel);
    }

    function currentTime() {
        var now = new Date();
        var format = now.toISOString();
        return format;
    }

    function desaDadesXML(contents) {
        var obj = {
            instantRegistrat: currentTime(),
            instantDades: lastUpdate,
            categoria: categoria,
            continguts: contents
        };
        if (!dbModel.updateObject(obj)) {
            dbModel.insertObject(obj);
        }
    }

    /*
    onStatusChanged: {
        statusCache = status;
    }
    */

    function llegeixOnline() {
        statusCache = XmlListModel.Loading;
        var doc = new XMLHttpRequest();
        doc.onload = function(e) {
            console.error(e);
        }

        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
//                console.log("Headers -->");
//                console.log(doc.getAllResponseHeaders());
            }
            if ((doc.readyState === XMLHttpRequest.DONE)) {
//                console.log('Estat DONE');
//                console.log('Status ' + doc.status + '-' + doc.statusText);
                var text = doc.responseText;
//                console.log('TEXT: ' + doc.responseText);
//                console.log('XML: ' + doc.responseXML);
                if (typeFiltra) {
                    if ((text)) {
                        lastUpdate = currentTime();
                        var text2;
                        if (typeFiltraHtml)
                            text2 = text.match(/\<table.*<\/table\>/,'').join('');
                        else
                            text2 = text.replace(/^\<HTML(\n|.)*<\/HTML\>(\n)*/i,'');
                        desaDadesXML(text2);
                        statusCache = XmlListModel.Ready;
                    } else
                        statusCache = XmlListModel.Null;
                } else {
                    if ((text) && (text != '')) {
                        lastUpdate = currentTime();
                        desaDadesXML(text);
                        statusCache = XmlListModel.Ready;
                    } else
                        statusCache = XmlListModel.Null;
                }

                onlineDataLoaded();
            }
        }
        // console.log('Getting source ' +source);
        doc.open('GET',source,true);
//        doc.setRequestHeader('User-Agent','XMLHTTP/1.0');

//        doc.setRequestHeader('Accept','text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8');
        /*
        doc.setRequestHeader('Accept-Encoding','gzip,deflate,sdch');
        doc.setRequestHeader('Accept-Language', 'es,ca;q=0.8');
        doc.setRequestHeader('Cache-Control','no-cache');
        doc.setRequestHeader('Connection','keep-alive');
        doc.setRequestHeader('Host','aloconsellera2.wordpress.com');
        doc.setRequestHeader('Pragma','no-cache');
        doc.setRequestHeader('User-Agent','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.94 Safari/537.36');
        */
        doc.send(null);
    }

    SqlTableModel {
        id: dbModel
        tableName: 'cacheData'
        filters: ["categoria='" + categoria + "'"]
    }

    Component.onCompleted: {
        llegeixHtml();
        llegeixOnline();
        dbModel.select();
    }
}

