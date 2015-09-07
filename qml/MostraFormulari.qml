import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import 'qrc:///Core/core' as Core
import PersonalTypes 1.0


Rectangle {
    id: showForm
    color: 'transparent'
    anchors.margins: units.nailUnit

    property string url: ''
    property var formObject

    signal goBack()

    states: [
        State {
            name: 'right'
            PropertyChanges {
                target: formTitle
                color: 'black'
                horizontalAlignment: Text.AlignLeft
            }
            PropertyChanges {
                target: formList
                visible: true
            }
        },
        State {
            name: 'wrong'
            PropertyChanges {
                target: formTitle
                color: 'red'
                horizontalAlignment: Text.AlignHCenter
            }
            PropertyChanges {
                target: formList
                visible: false
            }
        }
    ]
    Core.UseUnits { id: units }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Core.MainBar {
            id: mainBar
            Layout.fillWidth: true
            pageTitle: qsTr('Formulari')
            onGoBack: showForm.goBack()
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.max(formTitle.contentHeight,units.fingerUnit) + 2 * units.nailUnit

            Text {
                id: formTitle
                anchors.fill: parent
                anchors.margins: units.nailUnit
                font.pixelSize: units.glanceUnit
                font.bold: true
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }
        }

        Rectangle {
            id: mainBackground
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: 'white'

            ListView {
                id: formList
                anchors.fill: parent

                orientation: ListView.Vertical
                // boundsBehavior: Flickable.StopAtBounds

                spacing: units.fingerUnit
                leftMargin: units.fingerUnit
                rightMargin: units.fingerUnit
                topMargin: units.fingerUnit
                bottomMargin: units.fingerUnit

                clip: true

                header: Rectangle {
                    width: formList.width - formList.leftMargin - formList.rightMargin
                    height: units.fingerUnit
                    color: 'white'
                    Text {
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: qsTr('Inici del formulari')
                    }
                }

                footer: Rectangle {
                    width: formList.width - formList.leftMargin - formList.rightMargin
                    height: units.fingerUnit
                    color: 'white'
                    Text {
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: qsTr('Final del formulari')
                    }
                }

                delegate: Rectangle {
                    id: wholeField

                    states: [
                        State {
                            name: 'show'
                            PropertyChanges {
                                target: closeEditorButton
                                visible: false
                                enabled: false
                            }
                        },
                        State {
                            name: 'edit'
                            PropertyChanges {
                                target: closeEditorButton
                                visible: true
                                enabled: true
                            }
                        }
                    ]
                    state: 'show'

                    objectName: 'fieldShow'

                    clip: true

                    border.color: 'black'
                    width: formList.width - formList.leftMargin - formList.rightMargin

                    height: columnLayout.height + 3 * units.nailUnit
                    property string fieldType: (typeof modelData['type'] !== 'undefined')?modelData['type']:''

                    property string value: (typeof modelData['value'] !== 'undefined')?modelData['value']:''
                    property string textualValue: value

                    onValueChanged: fieldLoader.item.value = value;
                    onTextualValueChanged: fieldLoader.item.textualValue = textualValue;

                    Behavior on height {
                        NumberAnimation {
                            duration: 250
                        }
                    }

                    ColumnLayout {
                        id: columnLayout
                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                            margins: units.nailUnit * 2
                        }
                        spacing: units.nailUnit

                        Text {
                            id: fieldTitle
                            Layout.fillWidth: true
                            Layout.preferredHeight: contentHeight
                            font.pixelSize: units.readUnit
                            font.bold: true
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            text: modelData.title + ((modelData.required == 1)?" *":"")
                        }

                        Text {
                            id: fieldDescription
                            Layout.fillWidth: true
                            Layout.preferredHeight: contentHeight
                            font.pixelSize: units.readUnit
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            text: modelData.description
                        }
                        Loader {
                            id: fieldLoader
                            Layout.fillWidth: true
                            Layout.preferredHeight: Math.max(units.fingerUnit, ((typeof (item.requiredHeight)) !== 'undefined')?item.requiredHeight:0)
                            sourceComponent: showField
                            onLoaded: {
                                item.textualValue = wholeField.textualValue;
                                item.value = wholeField.value;
                            }
                        }

                    }

                    Core.ImageButton {
                        id: closeEditorButton
                        anchors {
                            top: wholeField.top
                            right: wholeField.right
                            margins: units.nailUnit
                        }
                        size: units.fingerUnit
                        image: 'red-31176'
                        onClicked: wholeField.closeEditor()
                    }

                    MouseArea {
                        anchors.fill: parent
                        enabled: wholeField.state == 'show';

                        onClicked: {
                            // The state is "show" because it's the only condition when the mousearea is enabled

                            formList.closeAllEditors();
                            //wholeField.state = 'edit';
                            wholeField.showEditor();
                        }
                    }

                    function closeEditor() {
                        if (typeof fieldLoader.item.textualValue !== 'undefined')
                            wholeField.textualValue = fieldLoader.item.textualValue;
                        if (typeof fieldLoader.item.value !== 'undefined')
                            wholeField.value = fieldLoader.item.value;

                        fieldLoader.sourceComponent = showField;

                        wholeField.state = 'show';
                    }

                    function showEditor() {
                        wholeField.state = 'edit';
                        switch(fieldType) {
                        case 'enumeration':
                            fieldLoader.sourceComponent = fieldEnumeration;
                            fieldLoader.item.values = modelData['values']
                            break;
                        case 'integer':
                            fieldLoader.sourceComponent = fieldInteger;
                            break;
                        case 'range':
                            fieldLoader.sourceComponent = fieldRange;
                            break;
                        case 'text':
                            fieldLoader.sourceComponent = fieldText;
                            break;
                        default:
                            fieldLoader.sourceComponent = fieldText;
                        }
                    }
                }

                function closeAllEditors() {
                    for (var i=0; i<contentItem.children.length; i++) {
                        if (contentItem.children[i].objectName === 'fieldShow') {
                            contentItem.children[i].closeEditor();
                        }
                    }
                }

            }


        }

        Rectangle {
            color: 'white'
            Layout.fillWidth: true
            Layout.preferredHeight: units.fingerUnit * 2
            RowLayout {
                anchors.fill: parent

                Core.Button {
                    text: qsTr('Envia')
                    color: 'white'
                    onClicked: {
                        formList.closeAllEditors();
                        writeToObject();
                    }
                }
                Core.Button {
                    text: qsTr('Buida')
                    color: 'red'
                    textColor: 'white'
                    onClicked: {
                        formList.closeAllEditors();
                        confirmDeletion.open();
                    }
                }
            }
        }

    }

    Component {
        id: showField

        Text {
            property int requiredHeight: contentHeight
            property string value: ''
            property string textualValue: ''

            text: (textualValue == '')?qsTr('-- Polsa per editar --'):textualValue
            color: (textualValue == '')?'red':'black'
            font.pixelSize: units.readUnit
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }
    }

    Component {
        id: fieldEnumeration
        Item {
            id: mainItem
            property int requiredHeight: childrenRect.height

            property var values: []

            property string value: ''
            property string textualValue: ''

            function filterValues() {
                var newValues = [];
                for (var i=0; i<values.length; i++) {
                    if (searchBox.stringContainsSearchTerms(values[i]['title'])) {
                        newValues.push(values[i]);
                    }
                }
                if (newValues.length>10) {
                    enumerationList.model = [];
                    listMessage.visible = true;
                    listMessage.text = qsTr('Hi ha massa resultats per mostrar: ' + newValues.length + ". Afita la cerca!");
                } else {
                    listMessage.visible = false;
                    enumerationList.model = newValues;
                }

                return newValues;
            }

            ColumnLayout {
                id: columnLayout
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                spacing: units.nailUnit
                height: searchBox.height + enumerationList.height + spacing

                Core.SearchBox {
                    id: searchBox
                    Layout.fillWidth: true
                    Layout.preferredHeight: units.fingerUnit

                    onPerformSearch: mainItem.filterValues()
                }

                ListView {
                    id: enumerationList
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.max(contentItem.height, units.fingerUnit)
                    interactive: false
                    //model: variableEnumeration.values

                    highlight: Rectangle {
                        width: mainItem.width
                        height: units.fingerUnit * 2
                        color: 'yellow'
                    }

                    delegate: Rectangle {
                        border.color: 'black'
                        color: 'transparent'
                        width: mainItem.width
                        height: units.fingerUnit * 2
                        Text {
                            anchors.fill: parent
                            font.pixelSize: units.readUnit
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            text: modelData['title']
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                enumerationList.currentIndex = model.index;
                                mainItem.textualValue = modelData['title'];
                                mainItem.value = modelData['code'];
                            }
                        }
                    }

                }
                Text {
                    id: listMessage
                    anchors.fill: enumerationList
                    color: 'red'
                }
            }

            onValuesChanged: filterValues()
        }
    }

    Component {
        id: fieldInteger
        Item {
            id: fieldIntegerItem
            property int requiredHeight: units.fingerUnit

            property alias value: mainField.text
            property alias textualValue: fieldIntegerItem.value

            TextField {
                id: mainField
                width: parent.width
                height: units.fingerUnit
            }
        }
    }

    Component {
        id: fieldRange
        Item {
            property int requiredHeight: units.fingerUnit

        }
    }

    Component {
        id: fieldText
        Item {
            id: fieldTextItem

            property int requiredHeight: editBar.height + mainField.height
            property alias value: mainField.text
            property alias textualValue: fieldTextItem.value

            Core.EditBar {
                id: editBar
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                height: units.fingerUnit * 2

                onRedo: mainField.redo()
                onUndo: mainField.undo()
                onCopy: mainField.copy()
                onCut: mainField.cut()
                onPaste: mainField.paste()

                onRemove: mainField.remove(0,mainField.length)
            }

            TextArea {
                id: mainField
                anchors {
                    top: editBar.bottom
                    left: parent.left
                    right: parent.right
                }
                height: units.fingerUnit * 4
            }
        }
    }


    ProvaFormulari {
        id: provaFormulari
    }

    function readFormObject(formContents) {
        try {
            formObject = JSON.parse(formContents);
            if (formObject.language !== "1.0") {
                showForm.state = 'wrong';
                formTitle.text = qsTr("El formulari «") + formObject.title + qsTr("» no s'ha pogut processar perquè es necessita una versió de l'aplicació més recent que la que s'està utilitzant. Intenti actualitzar l'aplicació.");
            } else {
                showForm.state = 'right';
                formTitle.text = formObject.title + qsTr(" (versió ") + formObject.version + ")";
                formList.model = formObject.fields;
                if (typeof formObject.background !== 'undefined')
                    mainBackground.color = formObject.background;
            }
        }catch(e) {
            showForm.state = 'wrong';
            formTitle.text = qsTr("S'ha detectat un error en el moment de processar el formulari.\n" + e);
        }
    }

    function writeToObject() {
        var fieldSet = formList.contentItem.children;
        var j=0;
        for (var i=0; i<fieldSet.length; i++) {
            if (fieldSet[i].objectName === 'fieldShow') {
                console.log(formObject.fields[i]);
                formObject.fields[j]['value'] = fieldSet[i]['value'];
                j++;
            }
        }
        console.log(JSON.stringify(formObject));
    }

    MessageDialog {
        id: confirmDeletion
        title: qsTr('Buidar tots els camps')
        text: title
        informativeText: qsTr("Es buidarà el contingut de tots els camps. Vols continuar?")

        standardButtons: StandardButton.Ok | StandardButton.Cancel

        onAccepted: {
            var list = formList.contentItem.children;
            for (var i=0; i<list.length; i++) {
                if (list[i].objectName === 'fieldShow') {
                    list[i].value = '';
                    list[i].textualValue = '';
                }
            }
        }

        onRejected: {}
    }

    DataDownloader {
        id: dataDownloader

        onDownloaded: readFormObject(dataDownloader.downloadedData())
    }

    onUrlChanged: dataDownloader.open(url)
}
