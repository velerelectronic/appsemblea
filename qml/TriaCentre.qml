import QtQuick 2.2
import QtQuick.Controls 1.1
import 'qrc:///Core/core' as Core

Item {
    property string centre
    property string illa
    property string tipus

    height: enterPlace.height + places.height

    TextField {
        id: enterPlace
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: searchButton.left
        anchors.rightMargin: units.nailUnit

    }

    Core.Button {
        id: searchButton
        anchors.right: parent.right
        anchors.top: parent.top
        text: qsTr('Cerca')
        color: 'white'
    }

    ListView {
        id: places
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: contentItem.height
    }
}
