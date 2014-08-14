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
import 'qrc:///Javascript/javascript/Storage.js' as Storage

XmlListModel {
    id: cachedModel
    property int statusCache: XmlListModel.Null
    property string source: ''
    property string lastUpdate: ''
    property string categoria: ''
    property bool typeFiltra: false

    signal onlineDataLoaded

    onOnlineDataLoaded: {
        llegeixHtml();
    }

    function llegeixHtml() {
        Storage.llegeixDadesXML(categoria,cachedModel);
    }

    function recuperaDades(newXml,newActualitzat) {
        xml = newXml;
        lastUpdate = newActualitzat;
    }

    function llegeixOnline() {
        statusCache = XmlListModel.Loading;
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
//                console.log('Headers....');
//                console.log(doc.getAllResponseHeaders());
            }
            if ((doc.readyState === XMLHttpRequest.DONE)) {
                console.log('Estat DONE');
//                console.log(doc.getAllResponseHeaders());
                var text = doc.responseText;
                if (typeFiltra) {
                    if ((text)) {
                        lastUpdate = Storage.currentTime();
                        text = text.match(/\<table.*<\/table\>/,'').join('');
//                        cachedModel.xml = text;
                        Storage.desaDadesXML(categoria,lastUpdate,text);
//                        console.log(text);
                        statusCache = status;
                    } else
                        statusCache = XmlListModel.Null;
                } else {
                    if ((text) && (text != '')) {
                        lastUpdate = Storage.currentTime();
//                        cachedModel.xml = text;
                        Storage.desaDadesXML(categoria,lastUpdate,text);
//                        console.log(text);
                        statusCache = status;
                    } else
                        statusCache = XmlListModel.Null;
                }

                cachedModel.onlineDataLoaded();
            }
        }
        console.log('Getting source ' +source);
        doc.open('GET',source);
        //doc.setRequestHeader("Content-type", "text/plain");
        //doc.setRequestHeader("Content-length", 0);
        //doc.setRequestHeader("Connection", "close");
        doc.send(null);
    }

    onStatusChanged: {
        statusCache = status;
    }

    Component.onCompleted: llegeixOnline()
}
