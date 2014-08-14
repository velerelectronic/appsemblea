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
import 'qrc:///Core/core' as Core

Rectangle {
    id: doublePanel
    property alias colorMainPanel: mainPanel.color
    property alias colorSubPanel: subPanel.color
    property alias itemMainPanel: mainPanelLoader.sourceComponent
    property alias itemSubPanel: subPanelLoader.sourceComponent

    property int globalMargins: units.fluentMargins(width, units.nailUnit)
    property int widthSubPanel: Math.min(6 * units.fingerUnit + 2 * globalMargins,width)
    property int availableWidth: width - widthSubPanel

    Core.UseUnits {
        id: units
    }

    state: 'normal'

    function canShowBothPanels() {
        return availableWidth>2*widthSubPanel;
    }

    states: [
        State {
            name: 'shaded'
            AnchorChanges {
                target: subPanel
                anchors.left: parent.left
                anchors.right: undefined
            }
            PropertyChanges {
                target: shade
                opacity: (canShowBothPanels())?0:0.5
            }
        },
        State {
            name: 'normal'
            AnchorChanges {
                target: subPanel
                anchors.left: undefined
                anchors.right: (canShowBothPanels())?mainPanel.left:parent.left
            }
            PropertyChanges {
                target: shade
                opacity: 0.0
            }
        }
    ]

    Rectangle {
        id: mainPanel

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: (canShowBothPanels())?availableWidth:parent.width

        Loader {
            id: mainPanelLoader
            anchors.fill: parent
            anchors.margins: globalMargins
        }

        Rectangle {
            id: shade
            anchors.fill: parent
            color: 'black'
            MouseArea {
                anchors.fill: parent
                enabled: (doublePanel.state=='shaded')
                onPressed: toggleSubPanel()
            }
        }
    }
    Rectangle {
        id: subPanel
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: widthSubPanel

        Loader {
            id: subPanelLoader
            anchors.fill: parent
            anchors.margins: globalMargins
        }
    }

    transitions: Transition {
        NumberAnimation {
            target: shade
            properties: 'opacity'
            duration: 300
            easing.type: Easing.InOutQuad
        }
        AnchorAnimation {
            targets: subPanel
            duration: 300
            easing.type: Easing.InOutQuad
        }
    }

    function toggleSubPanel() {
        state = (state == 'shaded')?'normal':'shaded';
    }
}
