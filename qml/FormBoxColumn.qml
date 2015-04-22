import QtQuick 2.2
import QtQuick.Layouts 1.1
import 'qrc:///Core/core' as Core

Rectangle {
    Core.UseUnits {
        id: units
    }

    border.color: 'black'
    property alias caption: caption.text
    default property alias subWidgets: column.children
    height: column.height + units.fingerUnit

    ColumnLayout {
        id: column
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: units.fingerUnit / 2
        height: childrenRect.height
        spacing: units.nailUnit

        Text {
            id: caption
            Layout.fillWidth: true
            Layout.preferredHeight: (text != '')?contentHeight:0
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.bold: true
        }
    }
}
