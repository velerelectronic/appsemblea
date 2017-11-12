#include "sqltablemodel.h"

#include "sqltablemodel.h"

#include <QDebug>
#include <QSqlField>
#include <QSqlIndex>
#include <QSqlRecord>
#include <QSqlQuery>
#include <QMap>
#include <QSqlDatabase>
#include <QSqlError>

SqlTableModel::SqlTableModel(QObject *parent, QSqlDatabase db) :
    QSqlQueryModel(parent)
{
    innerLimit=0;
    connect(this,SIGNAL(rowsInserted(QModelIndex,int,int)),this,SLOT(select()));
    connect(this,SIGNAL(rowsInserted(QModelIndex,int,int)),this,SLOT(debug()));
    connect(this,SIGNAL(rowsInserted(QModelIndex,int,int)),this,SIGNAL(updated()));

    QSqlQuery query(db);
    QSqlQueryModel::setQuery(query);

    innerFakeCounter = 0;
}

void SqlTableModel::debug() {
//    qDebug() << "HHOOOLA";
}

QStringList SqlTableModel::bindValues() const {
    return innerBindValues;
}

QSqlRecord SqlTableModel::buildRecord(const QVariantMap &object,bool autoValue) {
    QSqlRecord record;
    QVariantMap::const_iterator i = object.constBegin();
    while (i != object.constEnd()) {
        QSqlField field(i.key(),QVariant::String);
        field.setValue(i.value());
        record.append(field);
        ++i;
    }
    if (autoValue) {
        QSqlField idfield("id",QVariant::Int);
        idfield.setAutoValue(true);
        idfield.setGenerated(false);
        record.append(idfield);
    }
    return record;
}

QStringList SqlTableModel::calculatedFieldNames() const {
    return innerCalculatedFieldNames;
}

void SqlTableModel::clear() {
    QSqlQuery query;
    query.prepare("DELETE FROM " + innerTableName);
    setQuery(query);
    query.exec();
    updated();
}

int SqlTableModel::count() {
    return QSqlQueryModel::rowCount();
}

QVariant SqlTableModel::data(const QModelIndex &index, int role) const {

    QVariant value = QSqlQueryModel::data(index,role);

    if (role < Qt::UserRole)
        value = QSqlQueryModel::data(index, role);
    else {
        int columnIdx = role - Qt::UserRole - 1;
        QModelIndex modelIndex = this->index(index.row(), columnIdx);
        value = QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
    }
    return value;
}

void SqlTableModel::deselectAllObjects() {
    subselectedRows.clear();
    QModelIndex indexStart = this->createIndex(0,Qt::UserRole + columnCount() + 1);
    QModelIndex indexEnd = this->createIndex(rowCount(),Qt::UserRole + columnCount() + 1);
    this->dataChanged(indexStart,indexEnd);
}

const QStringList &SqlTableModel::fieldNames() {
    return innerFieldNames;
}

QStringList &SqlTableModel::filters() {
    return innerFilters;
}

Qt::ItemFlags SqlTableModel::flags(const QModelIndex &index) const {
    Qt::ItemFlags flags = QSqlQueryModel::flags(index);
    flags |= Qt::ItemIsEditable;
    return flags;
}

void SqlTableModel::generateRoleNames() {
    roles.clear();
    int nbCols = innerFieldNames.size();
    for (int i = 0; i < nbCols; i++) {
        roles[Qt::UserRole + i + 1] = innerFieldNames.at(i).toLocal8Bit();
    }
    int nbCols2 = innerCalculatedFieldNames.size();
    QRegExp finalWord("\\w+$");
    for (int i = 0; i < nbCols2; i++) {
        QString fieldName = innerCalculatedFieldNames.at(i);
        roles[Qt::UserRole + i + 1 + nbCols] = fieldName.mid(fieldName.indexOf(finalWord)).toLocal8Bit();
    }
    roles[Qt::UserRole + nbCols + nbCols2 + 1] = QByteArray("selected");
}

QString SqlTableModel::getFieldNameByIndex(int index) {
    return roles[Qt::UserRole + index + 1];
}

QVariantMap SqlTableModel::getObject(QString key) {
    return getObject(innerPrimaryKey, key);
}

QVariantMap SqlTableModel::getObject(QString primaryField, QString key) {
    QStringList auxFilters = innerFilters;
    QStringList auxBoundValues = innerBindValues;

    innerFilters.clear();
    innerFilters << primaryField + "=?";

    innerBindValues.clear();
    innerBindValues << key;

    SqlTableModel::select();

    QVariantMap result;
    if (rowCount() > 0) {
        QSqlRecord searchRecord = this->record(0);
        for (int i=0; i<searchRecord.count(); i++) {
            result.insert(searchRecord.fieldName(i),searchRecord.value(i));
        }
    }

    innerFilters = auxFilters;
    innerBindValues = auxBoundValues;

    return result;
}

QVariantMap SqlTableModel::getObjectInRow(int row) const {
    QSqlRecord rec = record(row);
    QVariantMap result;
    for (int i=0; i<rec.count(); i++) {
        result.insert(rec.fieldName(i),rec.value(i));
    }
    return result;
}

QString SqlTableModel::getSearchString() {
    // Build a string to search text in searchFields

    QString filter;
    QStringList searchList;
    if ((innerSearchString != "") && (innerSearchFields.size()>0)) {
        QStringList::const_iterator i = innerSearchFields.constBegin();
        while (i != innerSearchFields.constEnd()) {
            searchList << "INSTR(UPPER(" + *i + "),UPPER(?))";
            ++i;
        }
        filter = "(" + searchList.join(" OR ") + ")";
    }
    return filter;
}

QString &SqlTableModel::groupBy() {
    return innerGroupBy;
}

QVariant SqlTableModel::insertObject(const QVariantMap &object) {
    QStringList keys = object.keys();
    QStringList placeHolders;

    for (int i=0; i<object.size(); i++)
        placeHolders << "?";

    QSqlQuery query;
    query.prepare("INSERT INTO " + innerTableName + " (\"" + keys.join("\", \"") + "\") VALUES (" + placeHolders.join(",") + ")");

    QVariantMap::const_iterator values = object.cbegin();
    while ( values != object.cend()) {
        query.addBindValue(*values);
        ++values;
    }

    query.exec();

    setQuery(query);

    QVariant lastId = query.lastInsertId();

    qDebug() << "INSERT" << query.lastQuery();
    qDebug() << object;
    updated();
    qDebug() << "Last ID " << lastId;
    return lastId;
}

bool SqlTableModel::isSelectedObject(const int &row) {
    return subselectedRows.contains(row);
}
int SqlTableModel::limit() {
    return innerLimit;
}

QString SqlTableModel::primaryKey() {
    return innerPrimaryKey;
}

QString SqlTableModel::reference() {
    return innerReference;
}

int SqlTableModel::removeAllObjects() {
    QSqlQuery query;
    query.prepare("DELETE FROM " + innerTableName);
    setQuery(query);
    query.exec();
    updated();
    return query.numRowsAffected();
}

int SqlTableModel::removeObject(const QVariant &identifier) {
    QSqlQuery query;
    if (innerPrimaryKey != "") {
        query.prepare("DELETE FROM " + innerTableName + " WHERE " +  innerPrimaryKey + "=?");
        query.addBindValue(identifier);
        setQuery(query);
        query.exec();
        updated();
        return query.numRowsAffected();
    }
    return 0;
}

bool SqlTableModel::removeObjects(const QString &conditions, const QVariantList &values) {
    QSqlQuery query;
    query.prepare("DELETE FROM " + innerTableName + " WHERE " + conditions);

    QVariantList::const_iterator it;
    for (it = values.constBegin(); it != values.constEnd(); it++) {
        query.addBindValue(*it);
    }
    setQuery(query);
    query.exec();
    qDebug() << "DEL;; " << query.lastQuery();
    updated();
    qDebug() << "ROWS:" << query.numRowsAffected();
    qDebug() << query.boundValues();
    qDebug() << query.lastError();
    return query.numRowsAffected();

}
int SqlTableModel::removeSelectedObjects() {
    int i = 0;
    QMap<int,bool>::iterator row = subselectedRows.end();
    while (row != subselectedRows.begin()) {
        --row;
//        if (removeObjectInRow(row.key())) {
//            i++;
//            updated();
//        }
    }
    subselectedRows.clear();
    select();
    return i;
}

QHash<int, QByteArray> SqlTableModel::roleNames() const {
    return roles;
}

int SqlTableModel::searchRowWithKeyValue(const QVariant &value) {
    QSqlRecord searchRecord;
    int row=0;
    bool found = false;
    while ((!found) && (row<rowCount())) {
        searchRecord = this->record(row);
        if (searchRecord.value(innerPrimaryKey)==value)
            found = true;
        else
            row++;
    }
    return (found)?row:-1;
}

QStringList SqlTableModel::searchFields() {
    return innerSearchFields;
}

QString SqlTableModel::searchString() {
    return innerSearchString;
}

void SqlTableModel::setPrimaryKey(const QString &key) {
    innerPrimaryKey = key;
    primaryKeyChanged();
}

bool SqlTableModel::select(const QString &queryString) {
    QSqlQuery query;
    query.prepare(queryString);
    QStringList::const_iterator filtersValues = innerBindValues.constBegin();
    while (filtersValues != innerBindValues.constEnd()) {
        query.addBindValue(*filtersValues);
        ++filtersValues;
    }

    bool result = query.exec();
    if (result) {
        setQuery(query);
        countChanged();
    }
    return result;
}

bool SqlTableModel::select() {
//    deselectAllObjects();

    // This strongly needs to be fixed. There is a strange bug that keeps on calling "select()"
    qDebug() << "NUMBER " << innerFakeCounter;
    innerFakeCounter++;

    QStringList filtersList;

    // Attach the common filters
    if (innerFilters.size()>0)
        filtersList << "(" + innerFilters.join(") AND (") + ")";

    // Filter the search fields
    QStringList searchList;
    if ((innerSearchString != "") && (innerSearchFields.size()>0)) {
        QStringList::const_iterator i = innerSearchFields.constBegin();
        while (i != innerSearchFields.constEnd()) {
            searchList << "INSTR(UPPER(" + *i + "),UPPER(?))";
            ++i;
        }
        filtersList << "(" + searchList.join(" OR ") + ")";
    }

    QSqlQuery query(this->query());
    query.prepare("SELECT \"" + fieldNames().join("\", \"") + "\"" +
                  ((calculatedFieldNames().size()>0)?(", " + calculatedFieldNames().join(", ")):"") +
                  " FROM " + innerTableName +
                  ((filtersList.size()>0)?(" WHERE " + filtersList.join(" AND ")):"") +
                  ((innerGroupBy != "")?" GROUP BY " + innerGroupBy:"") +
                  ((innerSort != "")?" ORDER BY " + innerSort:"") +
                  ((innerLimit > 0)?QString(" LIMIT ") + QString().setNum(innerLimit):""));
    qDebug() << "Last query 1" << query.lastQuery();

    qDebug() << "Bindings" << innerBindValues.size();
    QStringList::const_iterator filtersValues = innerBindValues.constBegin();
    while (filtersValues != innerBindValues.constEnd()) {
        query.addBindValue(*filtersValues);
        ++filtersValues;
    }

    if (innerSearchString != "") {
        for (int j=0; j<innerSearchFields.size(); j++) {
            query.addBindValue(innerSearchString);
        }
    }

    qDebug() << "bound values " << query.boundValues();
    bool result = query.exec();
    if (result) {
        if (innerFakeCounter>10) {
            innerFakeCounter = 0;
            return false;
        }
        setQuery(query);
        countChanged();
        qDebug() << "executed";
        qDebug() << "Last query 2" << query.executedQuery();
    }
    return result;
}

bool SqlTableModel::selectUnique(QString field) {
    QSqlQuery query;
    query.prepare("SELECT DISTINCT \"" + field + "\" FROM " + innerTableName);
    query.exec();
    setQuery(query);

    countChanged();
    return !query.lastError().isValid();
}

QStringList SqlTableModel::selectDistinct(QString field,QString order,QString filter,bool ascending) {
    QStringList vector;
    QSqlQuery query("SELECT DISTINCT " + field + " FROM " + this->innerTableName + ((filter != "")?(" WHERE " + filter):"") + " ORDER BY " + order + ((ascending)?" ASC":" DESC "));
//    qDebug() << query.executedQuery();
    query.exec();
    bool iter = query.first();
    while (iter) {
//        qDebug() << ".";
        vector.append(query.record().value(0).toString());
        iter = query.next();
    }
    return vector;
}

void SqlTableModel::selectObject(int row,bool activate) {
//    qDebug() << "Selecting object in " << row << " " << activate;
    if (activate)
        subselectedRows.insert(row,true);
    else
        subselectedRows.remove(row);
    QModelIndex index = this->createIndex(row,Qt::UserRole + columnCount() + 1);
    this->dataChanged(index,index);
}

void SqlTableModel::setBindValues(const QStringList &bindValues) {
    innerBindValues = bindValues;
}

void SqlTableModel::setCalculatedFieldNames(const QStringList &fields) {
    innerCalculatedFieldNames = fields;
    generateRoleNames();
    calculatedFieldNamesChanged();
}

bool SqlTableModel::setData(const QModelIndex &item, const QVariant &value, int role) {
    QString fieldName = getFieldNameByIndex(item.column());

//    query().prepare("UPDATE " + innerTableName)
    qDebug() << "Set data";

    bool ok = false;

    if (innerPrimaryKey != "") {
        QSqlQuery query;
        query.prepare("UPDATE " + innerTableName + " SET " + fieldName + " WHERE " + innerPrimaryKey + "=?");
        query.addBindValue(value.toString());
        ok = query.exec();

        setQuery(query);

        qDebug() << query.lastQuery();
        int rows = query.numRowsAffected();
        QVector<int> rolesVector;
        rolesVector << role;
        dataChanged(item,item,rolesVector);
        updated();
    }

    return ok;
}

void SqlTableModel::setFieldNames(const QStringList &fields) {
    innerFieldNames = fields;
    generateRoleNames();
    fieldNamesChanged();
}

void SqlTableModel::setFilters(const QStringList &filters) {
    innerFilters = filters;
    filtersChanged();
}

void SqlTableModel::setGroupBy(const QString &group) {
    innerGroupBy = group;
    groupByChanged();
}

void SqlTableModel::setLimit(int limit) {
    innerLimit = limit;
    limitChanged();
}

void SqlTableModel::setReference(const QString &keyRef) {
    innerReference = keyRef;
    referenceChanged();
}

void SqlTableModel::setSearchFields(const QStringList &fields) {
    innerSearchFields = fields;
    searchFieldsChanged();
}

void SqlTableModel::setSearchString(const QString &search) {
    innerSearchString = search;
    searchStringChanged();
}

void SqlTableModel::setSort(int column, Qt::SortOrder order) {
//    QSqlTableModel::setSort(column,order);
}

void SqlTableModel::setSort(const QString &sort) {
    innerSort = sort;
    sortChanged();
}

void SqlTableModel::setTableName(const QString &tableName) {
    innerTableName = tableName;
    tableNameChanged();

    setSort(0,Qt::DescendingOrder);
}

QString SqlTableModel::sort() {
    return innerSort;
}

const QString &SqlTableModel::tableName() {
    return innerTableName;
}

int SqlTableModel::updateObject(const QVariant &keyValue, const QVariantMap &object) {
    qDebug() << "Updating" << object;
    if (innerPrimaryKey != "") {
        QStringList keys;
        QVariantMap::const_iterator keysIterator = object.cbegin();
        while ( keysIterator != object.cend()) {
            QString set = "\"" + (keysIterator.key()) + "\"=?";
            qDebug() << set;
            keys << set;
            ++keysIterator;
        }

        qDebug() << keys;
        QSqlQuery query;
        query.prepare("UPDATE " + innerTableName + " SET " + keys.join(", ") + " WHERE " + innerPrimaryKey + "=?");

        QVariantMap::const_iterator valuesIterator = object.cbegin();
        while ( valuesIterator != object.cend()) {
            query.addBindValue(*valuesIterator);
            ++valuesIterator;
        }
        query.addBindValue(keyValue);
        qDebug() << "updated values" << query.boundValues();

        query.exec();
        setQuery(query);

        qDebug() << query.lastQuery();

        updated();
        return !query.lastError().isValid();
    }
}
