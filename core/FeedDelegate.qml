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

Rectangle {
    id: feedDelegate

    property string textTitol
    property string textContingut
    property string enllac

    property int index
    property string copiaTitol
    property string copiaContingut
    property string copiaEnllac

    property string colorOdd: '#ffffff' // #e0e0e0'
    property string colorEven: '#ffffff'

    color: (index % 2 == 1)?colorOdd:colorEven

    height: Math.max(textContents.height + units.nailUnit * 2, 2 * units.fingerUnit)
    border.color: '#aaaaaa'
    border.width: 2

    Text {
        id: textContents
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: units.nailUnit
        height: paintedHeight

        textFormat: Text.RichText
        font.pixelSize: units.readUnit
        verticalAlignment: Text.AlignVCenter
        text: feedDelegate.textTitol
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    }

    MouseArea {
        anchors.fill: feedDelegate
        onClicked: {
            console.log('Canviat a ' + index);
            feedDelegate.ListView.view.currentIndex = index;
        }
    }

    Component.onCompleted: {
        if (copiaTitol == '')
            copiaTitol = titol;
        if (copiaContingut == '')
            copiaContingut = textContingut;
        if (copiaEnllac == '')
            copiaEnllac = enllac;
    }

}
