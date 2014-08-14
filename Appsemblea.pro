TEMPLATE = app

QT += qml quick sql xml xmlpatterns svg
# QTPLUGIN += qtquick2plugin

SOURCES += main.cpp

#OBJECTIVE_SOURCES += \
#    ios/ioscalendar.mm

RESOURCES += \
    qml.qrc \
    autolink-js.qrc \
    twitter-text-js.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

OTHER_FILES += \
    android/AndroidManifest.xml \
    twitter-text-js/LICENSE.txt \
    ios/Info.plist

HEADERS += \
    qmlclipboardadapter.h

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android


ios {
    QMAKE_INFO_PLIST = ios/Info.plist
}

OBJECTIVE_SOURCES +=

