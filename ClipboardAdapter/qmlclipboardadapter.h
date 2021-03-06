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
