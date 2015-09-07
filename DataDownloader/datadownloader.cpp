#include "datadownloader.h"

#include <QNetworkProxyQuery>
#include <QNetworkRequest>

DataDownloader::DataDownloader(QQuickItem *parent) : QQuickItem(parent)
{

}

DataDownloader::~DataDownloader() {

}

void DataDownloader::open(QUrl dataUrl) {
    redirects = 0;
    QNetworkAccessManager *manager;
    manager = new QNetworkAccessManager(this);
    //QNetworkProxyQuery npq(a);
    QNetworkProxyQuery npq(QUrl(""));
    QList<QNetworkProxy> listOfProxies = QNetworkProxyFactory::systemProxyForQuery(npq);
    QNetworkProxy pr = listOfProxies.at(0);
    qDebug() << "Count: " << pr.hostName();

    // if (listOfProxies.count() !=0){
    // if (listOfProxies.at(0).type() != QNetworkProxy::NoProxy) {
    // manager->setProxy(listOfProxies.at(0));
    // qDebug() << "listOfProxies.at(0).hostName().toStdString()" ;
    //// qDebug() << "Using Proxy " << listOfProxies.at(0).hostName().toStdString();
    // }


    QNetworkProxyFactory::setUseSystemConfiguration(true);
    connect(
                &inner_WebCtrl,
                SIGNAL (finished(QNetworkReply*)),
                this,
                SLOT (dataDownloaded(QNetworkReply*))
            );

    inner_WebCtrl.get(QNetworkRequest(dataUrl));
}

void DataDownloader::dataDownloaded(QNetworkReply *pReply) {
    qDebug() << "REDIRECT???";
    QVariant newLoc = pReply->attribute(QNetworkRequest::RedirectionTargetAttribute);
    if (!newLoc.isNull()) {
        redirects++;
        if (redirects < 10)
            inner_WebCtrl.get(QNetworkRequest(newLoc.toUrl()));
        else {
            // Too many redirects
        }
    } else {
        inner_DownloadedData = pReply->readAll();
        qDebug() << inner_DownloadedData;
        pReply->deleteLater();
        emit downloaded();
    }
}

QByteArray DataDownloader::downloadedData() const {
    return inner_DownloadedData;
}
