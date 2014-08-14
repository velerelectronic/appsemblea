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
    id: loadingBox

    property string actualitzat
    height: textContents.height

    state: 'loading'
    states: [
        State {
            name: 'loading'
            PropertyChanges {
                target: loadingBox
                color: 'yellow'
                height: units.fingerUnit
            }
            PropertyChanges {
                target: textContents
                color: 'gray'
                font.pixelSize: units.readUnit
                text: qsTr('Actualitzant...')
            }
        },
        State {
            name: 'perfect'
            PropertyChanges {
                target: loadingBox
                color: 'white'
                height: units.readUnit
            }
            PropertyChanges {
                target: textContents
                color: 'gray'
                font.pixelSize: units.smallReadUnit
                text: qsTr('Actualitzat ') + loadingBox.actualitzat
            }
        },
        State {
            name: 'updateable'
            PropertyChanges {
                target: loadingBox
                color: 'white'
                height: units.readUnit
            }
            PropertyChanges {
                target: textContents
                color: 'black'
                font.pixelSize: units.glanceUnit
                text: qsTr('Estira cap avall per actualitzar.')
            }
        }
    ]

    Text {
        id: textContents
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: contentHeight
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
