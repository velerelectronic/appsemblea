#ifndef DATADOWNLOADER_H
#define DATADOWNLOADER_H

#include <QQuickItem>
#include <QByteArray>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>

class DataDownloader : public QQuickItem
{
    Q_OBJECT
public:
//    DataDownloader(QObject *parent = 0);
    explicit DataDownloader(QQuickItem *parent = 0);
    virtual ~DataDownloader();

    Q_INVOKABLE void open(QUrl dataUrl);
    Q_INVOKABLE QByteArray downloadedData() const;

signals:
    void downloaded();

private slots:
    void dataDownloaded(QNetworkReply* pReply);

private:
    QNetworkAccessManager inner_WebCtrl;
    QByteArray inner_DownloadedData;
    int redirects;

public slots:
};

#endif // DATADOWNLOADER_H
