import QtQuick 2.2

Rectangle {
    id: loadingBox

    property string actualitzat
    height: textContents.height + 2 * units.nailUnit

    state: 'loading'
    states: [
        State {
            name: 'loading'
            PropertyChanges {
                target: loadingBox
                color: 'yellow'
            }
            PropertyChanges {
                target: textContents
                color: 'gray'
                font.pixelSize: units.readUnit
                text: qsTr('Actualitzant...')
            }
            PropertyChanges {
                target: timeout
                running: true
            }
        },
        State {
            name: 'perfect'
            PropertyChanges {
                target: loadingBox
                color: 'white'
            }
            PropertyChanges {
                target: textContents
                color: 'gray'
                font.pixelSize: units.smallReadUnit
                text: qsTr('Actualitzat ') + loadingBox.actualitzat
            }
            PropertyChanges {
                target: timeout
                running: false
            }
        },
        State {
            name: 'updateable'
            PropertyChanges {
                target: loadingBox
                color: 'white'
            }
            PropertyChanges {
                target: textContents
                color: 'black'
                font.pixelSize: units.glanceUnit
                text: qsTr('Estira cap avall per actualitzar.')
            }
        },
        State {
            name: 'timeout'
            PropertyChanges {
                target: loadingBox
                color: 'white'
            }
            PropertyChanges {
                target: textContents
                color: 'red'
                font.pixelSize: units.glanceUnit
                text: qsTr("Temps d'espera sobrepassat. Torna a intentar-ho.")
            }
        },
        State {
            name: 'nodata'
            PropertyChanges {
                target: loadingBox
                color: 'white'
            }
            PropertyChanges {
                target: textContents
                color: 'red'
                font.pixelSize: units.glanceUnit
                text: qsTr("No s'han rebut dades.")
            }
        }

    ]

    Text {
        id: textContents
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: units.nailUnit
        height: implicitHeight
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Timer {
        id: timeout
        interval: 30 * 1000

        onTriggered: loadingBox.state = 'timeout'
    }
}
