import QtQuick 2.2
import QtQuick.Layouts 1.1
import 'qrc:///Core/core' as Core


Rectangle {
    id: abalearsvolem
    property bool working: true
    signal goBack()

    Core.UseUnits { id: units }

    color: 'white'

    ColumnLayout {
        anchors.fill: parent
        spacing: Math.round((parent.height - mainBar.height - units.fingerUnit * 6) / 4)

        Core.MainBar {
            id: mainBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            pageTitle: qsTr('A Balears Volem')
            onGoBack: abalearsvolem.goBack()
        }

        Core.Button {
            text: qsTr('Pàgina web')
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.preferredWidth: parent.width / 2
            Layout.preferredHeight: units.fingerUnit * 2
            color: '#88ff88'
            onClicked: Qt.openUrlExternally('http://abalearsvolem.com/')
        }
        Core.Button {
            text: qsTr('Twitter')
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.preferredWidth: parent.width / 2
            Layout.preferredHeight: units.fingerUnit * 2
            color: '#88ff88'
            onClicked: Qt.openUrlExternally('https://twitter.com/abalearsvolem')
        }
        Core.Button {
            text: qsTr('Facebook')
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.preferredWidth: parent.width / 2
            Layout.preferredHeight: units.fingerUnit * 2
            color: '#88ff88'
            onClicked: Qt.openUrlExternally('https://www.facebook.com/abalearsvolem')
        }
        Item {
            Layout.fillHeight: true
        }
    }

    Component.onCompleted: working = false
}
