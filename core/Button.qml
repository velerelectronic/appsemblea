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
import QtGraphicalEffects 1.0

Item {
    id: button
    signal clicked

    property alias text: continguts.text
    property alias fontSize: continguts.font.pixelSize
    property alias color: buttonRect.color
    property bool available: true

    height: (available)?units.fingerUnit:0
    width: (available)?continguts.paintedWidth + units.nailUnit * 2:0
    visible: available

    states: [
        State {
            name: ''
            PropertyChanges {
                target: buttonShadow
                glowRadius: Math.round(units.nailUnit / 2)
            }
        },
        State {
            name: 'pressing'
            PropertyChanges {
                target: buttonShadow
                glowRadius: Math.round(units.nailUnit / 4)
            }
        },

        State {
            name: 'pressed'
            PropertyChanges {
                target: buttonShadow
                glowRadius: units.nailUnit
            }
        }
    ]
    state: ''
    transitions: [
        Transition {
            NumberAnimation {
                target: buttonShadow
                properties: 'glowRadius'
                easing.type: Easing.InOutQuad
                duration: 200
            }
        }
    ]

    RectangularGlow {
        id: buttonShadow
        color: '#444444'
        anchors.fill: buttonRect
        glowRadius: Math.round(units.nailUnit / 2)
        cornerRadius: glowRadius + buttonRect.radius
        spread: 0.5
    }

    Rectangle {
        id: buttonRect
        anchors.fill: parent
        anchors.margins: Math.round(units.nailUnit / 2)

        color: 'gray'
        radius: units.nailUnit

        Text {
            id: continguts
            anchors.fill: parent
            font.pixelSize: units.readUnit
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        MouseArea {
            anchors.fill: parent
            onPressed: button.state = 'pressing';

            onClicked: {
                button.state = 'pressed';
                button.clicked();
                button.state = '';
            }
            onExited: button.state = ''
            onCanceled: button.state = ''
        }
    }

}

