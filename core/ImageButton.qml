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

Item {
    id: imageButton
    property string image
    property int size: units.fingerUnit
    property bool available: true
    signal clicked

    clip: true

    width: (available)?size:0
    height: (available)?size:0
    visible: available

    Image {
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: (image)?('qrc:///Imatges/imatges/' + image + '.svg'):''
    }

    MouseArea {
        anchors.fill: parent
        onClicked: imageButton.clicked()
    }
}

