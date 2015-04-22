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
        'Sep',
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
