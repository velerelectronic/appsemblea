import QtQuick 2.2
import QtGraphicalEffects 1.0

Item {
    id: button
    signal clicked

    property alias text: continguts.text
    property alias textColor: continguts.color
    property alias fontSize: continguts.font.pixelSize
    property string color: 'yellow'
    property bool available: true

    height: (available)?units.fingerUnit:0
    width: (available)?continguts.paintedWidth + units.nailUnit * 2:0
    visible: available

    states: [
        State {
            name: ''
            PropertyChanges {
                target: buttonShadow
                glowRadius: Math.round(units.nailUnit / 2)
            }
            PropertyChanges {
                target: buttonRect
                color: button.color
            }
        },
        State {
            name: 'pressing'
            PropertyChanges {
                target: buttonShadow
                glowRadius: Math.round(units.nailUnit / 4)
            }
            PropertyChanges {
                target: buttonRect
                color: '#eeeeee'
            }
        },

        State {
            name: 'pressed'
            PropertyChanges {
                target: buttonShadow
                glowRadius: units.nailUnit
            }
            PropertyChanges {
                target: buttonRect
                color: '#eeeeee'
            }
        }
    ]

    state: ''
    transitions: [
        Transition {
            NumberAnimation {
                target: buttonShadow
                properties: 'glowRadius'
                easing.type: Easing.InOutQuad
                duration: 200
            }
        },
        Transition {
            PropertyAnimation {
                target: buttonRect
                properties: 'color'
                duration: 200
            }
        }

    ]

    RectangularGlow {
        id: buttonShadow
        color: '#444444'
        anchors.fill: buttonRect
        glowRadius: Math.round(units.nailUnit / 2)
        cornerRadius: glowRadius + buttonRect.radius
        spread: 0.5
    }

    Rectangle {
        id: buttonRect
        anchors.fill: parent
        anchors.margins: Math.round(units.nailUnit / 2)

        color: button.color
        radius: units.nailUnit

        Text {
            id: continguts
            anchors.fill: parent
            font.pixelSize: units.readUnit
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }
        MouseArea {
            anchors.fill: parent
            onPressed: button.state = 'pressing';

            onClicked: {
                button.state = 'pressed';
                button.clicked();
            }
            onExited: button.state = ''
            onCanceled: button.state = ''
        }
    }

    function returnToNormalState() {
        button.state = '';
    }
}

