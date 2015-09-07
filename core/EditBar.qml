import QtQuick 2.3
import 'qrc:///Core/core' as Core

ListView {
    id: editBar
    signal undo()
    signal redo()
    signal copy()
    signal cut()
    signal paste()
    signal remove()

    orientation: ListView.Horizontal
    model: VisualItemModel {
        Core.ImageButton {
            size: editBar.height
            image: 'undo-97591'
            onClicked: editBar.undo()
        }
        Core.ImageButton {
            size: editBar.height
            image: 'redo-97589'
            onClicked: editBar.redo()
        }
        Core.ImageButton {
            size: editBar.height
            image: 'copy-97584'
            onClicked: editBar.copy()
        }
        Core.ImageButton {
            size: editBar.height
            image: 'scissors-147115'
            onClicked: editBar.cut()
        }
        Core.ImageButton {
            size: editBar.height
            image: 'paste-35946'
            onClicked: editBar.paste()
        }
        Core.ImageButton {
            size: editBar.height
            image: 'erase-34105'
            onClicked: editBar.remove()
        }
    }
}
