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

.import QtQuick.LocalStorage 2.0 as Sql


function getDatabase() {
    var db = Sql.LocalStorage.openDatabaseSync('Appsemblea',"1.0",'EsquirolDatabase',1000 * 1024);
    return db;
}

function initDatabase() {
    var db = getDatabase();
    db.transaction(
            function(tx) {
                // Init the table of the field names
                // tx.executeSql('DROP TABLE cacheData');
                tx.executeSql('CREATE TABLE IF NOT EXISTS cacheData (id INT AUTO_INCREMENT PRIMARY KEY,instantRegistrat TEXT, categoria INT, instantDades TEXT, continguts TEXT)');
            });
}

function currentTime() {
    var now = new Date();
    var format = now.toISOString();
    return format;
}

function getFirstResult(resultats) {
    if (resultats.rows.length>0)
        return resultats.rows.item(0);
}

function getQueryStatus(resultats) {

}

function desaDadesXML(categoria,instantDades,continguts) {
    var status;
    instantDades = currentTime();
    getDatabase().transaction(
                function(tx) {
                    var rs = tx.executeSql('UPDATE cacheData SET instantRegistrat=?, instantDades=?, continguts=? WHERE categoria=?',[currentTime(),instantDades,continguts,categoria]);
                    if (rs.rowsAffected == 0)
                        rs = tx.executeSql('INSERT INTO cacheData VALUES(null,?,?,?,?)',[currentTime(),categoria,instantDades,continguts]);
                    status = getQueryStatus(rs);
                }
                );
    return status;
}

function llegeixDadesXML(categoria,xmlModel) {
    var status;
    getDatabase().transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM cacheData WHERE categoria=?',[categoria]);
                    var resultats = getFirstResult(rs);
                    if (!resultats)
                        resultats = {continguts: '', instantDades: ''};
                    xmlModel.recuperaDades(resultats.continguts, resultats.instantDades);
                }
                );
}
