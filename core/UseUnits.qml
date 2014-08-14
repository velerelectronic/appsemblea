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
import QtQuick.Window 2.1

Item {
    id: units

    property int dimensioMenor: Math.min(Screen.width,Screen.height)
    property int decimaPart: Math.round(dimensioMenor / 10)
    property int fingerUnit: Screen.pixelDensity * 6
    property int nailUnit: Screen.pixelDensity * 1
    property int glanceUnit: Screen.pixelDensity * 6
    property int readUnit: Screen.pixelDensity * 3
    property int smallReadUnit: Screen.pixelDensity * 2
    property int titleReadUnit: Screen.pixelDensity * 4

    // Paper
    property int widthA4: Screen.pixelDensity * 210
    property int heightA4: Screen.pixelDensity * 297
    property int widthA5: Screen.pixelDensity * 148
    property int heightA5: Screen.pixelDensity * 210
    property int maximumReadWidth: widthA5

    // Fluent margins
    function fluentMargins(refDimension, minimum) {
        return Math.max(Math.round(refDimension / 50), minimum);
    }
}
