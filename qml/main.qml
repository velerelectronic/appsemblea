import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import PersonalTypes 1.0
import 'qrc:///Core/core' as Core

Window {
    id: mainWindow
    visible: true
    width: Screen.width
    height: Screen.height
    color: 'black'
    property bool isVertical: height > width
    property string paginaInicial: 'Portada'
    property int midaMainBar: Math.round(units.fingerUnit * 1.5)
    property bool showMainBar: false
//    property var navegacio: []

    DatabaseBackup {
        id: dbBk
    }

    Rectangle {
        id: rectWindow
        anchors.fill: parent
        color: '#EEEEEE'

        Keys.onPressed: {
            if (event.key == Qt.Key_Back) {
                event.accepted = true;
                stack.pop();
            }
        }

        Core.UseUnits {
            id: units
        }

        Image {
            id: imatgeFons
            anchors.fill: parent
            anchors.topMargin: units.fingerUnit + 2 * units.nailUnit
            source: 'qrc:///Imatges/imatges/Logo assemblea docents.png'
            fillMode: Image.PreserveAspectFit
            smooth: true
            opacity: 0.5
        }

        StackView {
            id: stack
            anchors.fill: parent
            initialItem: Qt.resolvedUrl('Portada.qml')

            Stack.onStatusChanged: {
                if (Stack.status == Stack.Active) {
                    progressAnimation.stop();
                    if (typeof(stack.currentItem.showMainBar) != 'undefined')
                        showMainBar = stack.currentItem.showMainBar;
                    else
                        showMainBar = true;
                } else {
                    progressAnimation.restart();
                }
            }

            Connections {
                target: stack.currentItem
                ignoreUnknownSignals: true
                onObrePagina: obrePagina(pagina,opcions)
                onGoBack: stack.pop()
//                onWorkingChanged: (pageLoader.item.working)?progressAnimation.restart():progressAnimation.stop()
                onShowHelpPage: {
                    mainHelpText.text = stack.currentItem.getHelpText();
                    helpBox.state = 'show';
                }
            }
        }

        Rectangle {
            // Barra de progrés que es mostra quan es carreguen les pàgines
            z: 3
            id: progress
            anchors.top: stack.top
            anchors.horizontalCenter: stack.horizontalCenter
            anchors.margins: 0
            color: 'green'
            height: units.nailUnit
            width: 0
            visible: progressAnimation.running

            PropertyAnimation {
                id: progressAnimation
                target: progress
                property: 'width'
                running: false
                loops: Animation.Infinite
                from: 0
                to: stack.width + 2 * units.nailUnit
                duration: 1000
            }
        }
    }

    Core.SuperposedBox {
        id: helpBox
        anchors.fill: rectWindow

        innerWidget: Rectangle {
            border {
                color: 'green'
                width: units.nailUnit
            }
            anchors.centerIn: parent
            width: parent.width * 0.66
            height: parent.height * 0.66
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: units.fingerUnit
                Text {
                    Layout.fillWidth: true
                    Layout.preferredHeight: contentHeight
                    font.pixelSize: units.glanceUnit
                    font.bold: true
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr('Ajuda')
                }

                Flickable {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    contentWidth: width
                    contentHeight: mainHelpText.height
                    Text {
                        id: mainHelpText
                        width: parent.width
                        height: contentHeight
                        textFormat: Text.RichText
                        font.pixelSize: units.readUnit
                        wrapMode: Text.WordWrap
                    }
                }

                Core.Button {
                    Layout.fillWidth: true
                    color: '#55FF55'
                    text: qsTr("Entesos!")
                    onClicked: helpBox.closeRequested()
                }
            }
        }

        onCloseRequested: {
            console.log('Tancam')
            helpBox.state = 'hide'
        }
    }

    function obrePagina(pagina,opcions) {
        stack.push({item: Qt.resolvedUrl(pagina + '.qml'),properties:opcions});
    }

    Component.onCompleted: {
        mainWindow.visible = true;
//        dbBk.dropTable('feedPosts');
//        dbBk.dropTable('feeds');
        dbBk.createTable('feeds', 'id INTEGER PRIMARY KEY, source TEXT, name TEXT, title TEXT, subtitle TEXT, permalink TEXT, updated TEXT, categories TEXT');
        dbBk.createTable('feedPosts', 'id INTEGER PRIMARY KEY, feed INT, title TEXT, content TEXT, published TEXT, updated TEXT, author TEXT, permalink TEXT, saved INTEGER, FOREIGN KEY(feed) REFERENCES feeds(id) ON DELETE CASCADE');
        dbBk.createTable('cacheData', 'id INT AUTO_INCREMENT PRIMARY KEY,instantRegistrat TEXT, categoria INT, instantDades TEXT, continguts TEXT');
        dbBk.createTable('forms', 'id INT AUTO_INCREMENT PRIMARY KEY,titol TEXT,tipus INT, forma TEXT,contingut TEXT,termini TEXT,enviat TEXT');
    }
}
