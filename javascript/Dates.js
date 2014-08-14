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

Date.prototype.nomsMesos = [
         qsTr('gener'),
         qsTr('febrer'),
         qsTr('març'),
         qsTr('abril'),
         qsTr('maig'),
         qsTr('juny'),
         qsTr('juliol'),
         qsTr('agost'),
         qsTr('setembre'),
         qsTr('octubre'),
         qsTr('novembre'),
         qsTr('desembre')
     ];

Date.prototype.diesSetmana = [
            qsTr('diumenge'),
            qsTr('dilluns'),
            qsTr('dimarts'),
            qsTr('dimecres'),
            qsTr('dijous'),
            qsTr('divendres'),
            qsTr('dissabte')
        ];

Date.prototype.abreviaMesosRSS = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Oct',
        'Nov',
        'Dec'
    ];

Date.prototype.escriuDiaMes = function() {
    return this.getDate() + ' ' + this.nomsMesos[this.getMonth()];
}

Date.prototype.escriuDiaSetmana = function() {
    return this.diesSetmana[this.getDay()];
}

Date.prototype.llegeixDataRSS = function(cadena) {
    // El format de data i hora que proporciona Wordpress em resulta desconegut
    // Podria haver-hi problemes en les situacions seg√ºents:
    // * Canvi d'hora: estiu i hivern
    // * Canvi de zona geografica en que s'executa l'aplicacio
    // ------------
    var partsData = cadena.split(' ');
    this.setDate(partsData[1]);
    this.setMonth(this.abreviaMesosRSS.indexOf(partsData[2]));
    this.setFullYear(partsData[3]);
    var partsHora = partsData[4].split(':');
    this.setHours(partsHora[0]);
    this.setMinutes(partsHora[1]);
    this.setSeconds(partsHora[2]);
    this.setMilliseconds(0);
    this.setMinutes(this.getMinutes() - this.getTimezoneOffset());
//    console.log(cadena + '---' + this.toString())
    return this;
}
