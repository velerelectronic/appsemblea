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
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0


Item {
    id: button
    anchors.margins: units.nailUnit * 4

    property alias title: text.text
    property alias image: img.source
    property alias color: buttonBox.color
    signal opened

    states: [
        State {
            name: ''
            PropertyChanges {
                target: buttonShadow
                glowRadius: units.nailUnit
                spread: 0.4
            }
        },
        State {
            name: 'pressing'
            PropertyChanges {
                target: buttonShadow
                glowRadius: Math.round(units.nailUnit / 2)
                spread: 0.6
            }
        },

        State {
            name: 'pressed'
            PropertyChanges {
                target: buttonShadow
                glowRadius: units.nailUnit * 2
                spread: 0.2
            }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation {
                target: buttonShadow
                properties: 'glowRadius,spread'
                easing.type: Easing.InOutQuad
                duration: 200
            }
        }
    ]
    state: ''

    RectangularGlow {
        id: buttonShadow
        color: '#444444'
        anchors.fill: buttonBox
        glowRadius: units.nailUnit
        cornerRadius: glowRadius + buttonBox.radius
        spread: 0.4
    }

    Rectangle {
        id: buttonBox
        anchors.fill: parent
//        anchors.margins: units.nailUnit * 2

        radius: units.nailUnit * 2

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: units.nailUnit
            spacing: units.nailUnit
            Image {
                id: img
                Layout.fillWidth: true
                Layout.fillHeight: true
                fillMode: Image.PreserveAspectFit
                smooth: false
            }
            Text {
                id: text
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: units.readUnit
                font.bold: true
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                Layout.fillWidth: true
                Layout.preferredHeight: contentHeight
            }
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                button.state = 'pressed';
                button.opened();
            }
            onPressed: button.state = 'pressing'
            onReleased: button.state = ''
            onExited: button.state = ''
            onCanceled: button.state = ''
        }
    }

}

