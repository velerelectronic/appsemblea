#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QStandardPaths>
#include <QDir>
#include <QSqlDatabase>

#include <QDebug>

#include "ClipboardAdapter/qmlclipboardadapter.h"
#include "DatabaseBackup/databasebackup.h"
#include "SqlTableModel/sqltablemodel.h"

// #include "ios/ioscalendar.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<QmlClipboardAdapter, 1>("tipuspersonals", 1, 0, "QClipboard");

//    qmlRegisterType<IOSCalendar>("iosTypes", 1, 0, "IOSCalendar");

    QQmlApplicationEngine engine;

    qmlRegisterType<DatabaseBackup>("PersonalTypes", 1, 0, "DatabaseBackup");
    qmlRegisterType<SqlTableModel>("PersonalTypes", 1, 0, "SqlTableModel");

    QString specificPath("Appsemblea");
    QDir dir(QStandardPaths::writableLocation(QStandardPaths::CacheLocation));
    qDebug() << dir;
    if (!dir.exists(specificPath)) {
        dir.mkdir(specificPath);
    }

    QSqlDatabase db;
    if (dir.cd(specificPath)) {
        db = QSqlDatabase::addDatabase("QSQLITE");
        db.setDatabaseName(dir.absolutePath() + "/mainDatabase.sqlite");
        if (db.open()) {
            qDebug() << "OPENED";
        }
    }

    engine.load(QUrl(QStringLiteral("qrc:///qml/main.qml")));

    return app.exec();
}
