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

#ifndef QMLCLIPBOARDADAPTER_H
#define QMLCLIPBOARDADAPTER_H

#include <QtGui/QGuiApplication>
#include <QClipboard>
#include <QQmlExtensionPlugin>
#include <QQmlExtensionInterface>
#include <QObject>

class QmlClipboardAdapter : public QObject
{
    Q_OBJECT
public:
    explicit QmlClipboardAdapter(QObject *parent = 0) : QObject(parent) {
        //clipboard = QApplication::clipboard();
        clipboard = QGuiApplication::clipboard();
    }

    Q_INVOKABLE void copia(QString text){
        clipboard->setText(text, QClipboard::Clipboard);
        clipboard->setText(text, QClipboard::Selection);
    }

private:
    QClipboard *clipboard;
};

/*
class QmlClipboardAdapterPlugin : public QQmlExtensionPlugin {
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri)
    {
        Q_ASSERT(uri == QLatin1String("tipuspersonals"));
        qmlRegisterType<QmlClipboardAdapter>(uri, 1, 0, "QClipboard");
    }
};
*/

#endif // QMLCLIPBOARDADAPTER_H
