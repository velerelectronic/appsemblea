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
// import QtWebKit 3.0

Flickable {
    property alias titol: textTitol.text
    property alias continguts: textContinguts.text
//    property string continguts: ''
    property string enllac
    property string copiaTitol
    property string copiaContingut
    property string copiaEnllac

    contentWidth: width
    contentHeight: columnaSingleItem.height
    clip: true

    Column {
        id: columnaSingleItem
        width: parent.width
        height: titol.height + units.readUnit + continguts.height
        spacing: units.readUnit

        Rectangle {
            id: titol
            anchors.left: parent.left
            anchors.right: parent.right
            height: textTitol.paintedHeight
            Text {
                id: textTitol
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                font.bold: true
                textFormat: Text.RichText
                font.pixelSize: Math.round(units.readUnit * 1.5)
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }
        }
        Rectangle {
            id: continguts
            anchors.left: parent.left
            anchors.right: parent.right
            height: textContinguts.contentHeight
            Text {
                id: textContinguts
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                font.pixelSize: units.readUnit
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                textFormat: Text.RichText
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }
    }

    function situaAlPrincipi() {
        contentY = 0;
        contentX = 0;
    }

}
