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
import 'qrc:///Javascript/javascript/SecretStuff.js' as SecretStuff
import 'qrc:///autolink-js/autolink.js' as AutoLink

ListModel {
    id: tweetsModel
    property int statusCache: 0

    property string accessToken: ''
    property string lastUpdate: ''
    signal onlineDataLoaded
    signal initDone

    // Required for tweets model
    property string consumerKey: SecretStuff.twitter_API().consumerKey
    property string consumerSecret: SecretStuff.twitter_API().secretKey
    property string bearerToken: ''
    property string from: ''
    property string phrase: ''
    property int status: XMLHttpRequest.UNSENT
    property bool isLoading: status == XMLHttpRequest.LOADING
    property bool wasLoading: false
    signal isLoaded

    // Helper properties
    property var idx
    property var ids
    property int counter: 0

    function rellegeixTweets() {
        // tweets
        // wrapper
        var req = new XMLHttpRequest;
        req.open("GET", "https://api.twitter.com/1.1/search/tweets.json?from=" + from +
                        "&count=10&q=" + encodeURIComponent(phrase));
        req.setRequestHeader("Authorization", "Bearer " + bearerToken);
        req.onreadystatechange = function() {
            status = req.readyState;
            if (status === XMLHttpRequest.DONE) {
                var objectArray = JSON.parse(req.responseText);
                if (objectArray.errors !== undefined)
                    console.log("Error agafant els tweets: " + objectArray.errors[0].message);
                else {
                    idx = new Array();
                    for (var key in objectArray.statuses) {
                        var jsonObject = objectArray.statuses[key];
                        processTweet(jsonObject);
                    }
                }
                if (wasLoading == true)
                    tweetsModel.isLoaded()
                tweetsModel.onlineDataLoaded();
            }
            wasLoading = (status === XMLHttpRequest.LOADING);
        }
        req.send();
    }

    onPhraseChanged: rellegeixTweets()
    onFromChanged: rellegeixTweets()
    onInitDone: rellegeixTweets()

    Component.onCompleted: {
        console.log(consumerKey);
        console.log(consumerSecret);

        if (consumerKey === "" || consumerSecret == "") {
            bearerToken = encodeURIComponent(accessToken);
        } else {
            var authReq = new XMLHttpRequest;
            authReq.open("POST", "https://api.twitter.com/oauth2/token");
            authReq.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
            authReq.setRequestHeader("Authorization", "Basic " + Qt.btoa(consumerKey + ":" + consumerSecret));
            authReq.onreadystatechange = function() {
                if (authReq.readyState === XMLHttpRequest.DONE) {
                    var jsonResponse = JSON.parse(authReq.responseText);
                    if (jsonResponse.errors !== undefined)
                        console.log("Error d'autenticació: " + jsonResponse.errors[0].message);
                    else
                        bearerToken = jsonResponse.access_token;

                    tweetsModel.initDone();
                }
            }
            authReq.send("grant_type=client_credentials");
        }
    }

    function idInList(id) {
        for (var i=0; i< idx.length; i++) {
            if (ids[i] === id)
                return true;
        }
        return false;
    }

    function processTweet(object) {
        var titol = '';
        var contingut = '';

        if (object.retweeted_status) {
            var retweeted = object.retweeted_status;
            titol = 'RT ' + retweeted.user.screen_name + ': ' + retweeted.text;
            contingut = '<p>Retuitejat per @' + object.user.screen_name + '</p><p><b>' + retweeted.user.name + '</b> @' + retweeted.user.screen_name + '</p><p>' + (retweeted.text.autoLink()) + '</p>';
        } else {
            titol = object.text;
            contingut = '<p>' + (titol.autoLink()) + '</p>';
        }
        var urlAlternate = 'twitter://status?id=' + object.id_str;
        contingut = contingut + '<p><a href="'+ urlAlternate +'">Obre tweet</a></p>';

        tweetsModel.append({titol: titol, urlAlternate: urlAlternate, contingut: contingut});

        console.log('Objecte: ');
// metadata, user, retweeted_status, entities,
        var objecte = object; // ['retweeted_status'];
        for (var prop in objecte) {
            console.log(prop + " -> " + objecte[prop]);
        }

        // Save index
//        var id = object.id;
//        if (!idInList(id))
//            idx.push(id);
    }

    /*
    Timer {
        id: timer
        interval: 500
        running: tweetsModel.counter
        repeat: true
        onTriggered: {
            main.counter--;
            var id = elements[idx[main.counter]].id;
            var item = elements[main.counter];
            tweetsModel.add( { "statusText": Helper.insertLinks(item.text, item.entities),
                                "twitterName": item.user.screen_name,
                                "name" : item.user.name,
                                "userImage": item.user.profile_image_url,
                                "source": item.source,
                                "id": id,
                                 "uri": Helper.insertLinks(item.user.url, item.user.entities),
                                "published": item.created_at } );
            ids.push(id);
        }
    }
    */
}
