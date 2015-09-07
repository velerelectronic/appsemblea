TEMPLATE = app

QT += qml quick sql xml xmlpatterns svg
# QTPLUGIN += qtquick2plugin

SOURCES += main.cpp \
    DatabaseBackup/databasebackup.cpp \
    SqlTableModel/sqltablemodel.cpp \
    DataDownloader/datadownloader.cpp

#OBJECTIVE_SOURCES += \
#    ios/ioscalendar.mm

RESOURCES += \
    autolink-js.qrc \
    twitter-text-js.qrc \
    qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

OTHER_FILES += \
    android/AndroidManifest.xml \
    twitter-text-js/LICENSE.txt \
    ios/Info.plist \
    LICENSE

HEADERS += \
    qmlclipboardadapter.h \
    DatabaseBackup/databasebackup.h \
    SqlTableModel/sqltablemodel.h \
    ClipboardAdapter/qmlclipboardadapter.h \
    DataDownloader/datadownloader.h

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android


ios {
    QMAKE_INFO_PLIST = ios/Info.plist
}

OBJECTIVE_SOURCES +=

DISTFILES += \
    qml/Prova.json

