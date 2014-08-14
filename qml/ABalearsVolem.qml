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
import 'qrc:///Core/core' as Core


Rectangle {
    id: abalearsvolem
    property bool working: true
    signal goBack()

    Core.UseUnits { id: units }

    color: 'white'

    ColumnLayout {
        anchors.fill: parent
        spacing: Math.round((parent.height - mainBar.height - units.fingerUnit * 6) / 4)

        Core.MainBar {
            id: mainBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            pageTitle: qsTr('A Balears Volem')
            onGoBack: abalearsvolem.goBack()
        }

        Core.Button {
            text: qsTr('Pàgina web')
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.preferredWidth: parent.width / 2
            Layout.preferredHeight: units.fingerUnit * 2
            color: '#88ff88'
            onClicked: Qt.openUrlExternally('http://abalearsvolem.com/')
        }
        Core.Button {
            text: qsTr('Twitter')
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.preferredWidth: parent.width / 2
            Layout.preferredHeight: units.fingerUnit * 2
            color: '#88ff88'
            onClicked: Qt.openUrlExternally('https://twitter.com/abalearsvolem')
        }
        Core.Button {
            text: qsTr('Facebook')
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.preferredWidth: parent.width / 2
            Layout.preferredHeight: units.fingerUnit * 2
            color: '#88ff88'
            onClicked: Qt.openUrlExternally('https://www.facebook.com/abalearsvolem')
        }
        Item {
            Layout.fillHeight: true
        }
    }

    Component.onCompleted: working = false
}
