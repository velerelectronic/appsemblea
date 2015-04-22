import QtQuick 2.2

Item {
    id: imageButton
    property string image
    property int size: units.fingerUnit
    property bool available: true
    signal clicked

    clip: true

    width: (available)?size:0
    height: (available)?size:0
    visible: available

    Image {
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: (image)?('qrc:///Imatges/imatges/' + image + '.svg'):''
    }

    MouseArea {
        anchors.fill: parent
        onClicked: imageButton.clicked()
    }
}

