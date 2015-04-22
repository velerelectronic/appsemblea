import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

Rectangle {
    property string title: 'Visita dels inspectors'
    property alias inspector: fieldInspector.text

    property int sectionSpacing: units.fingerUnit / 2

    color: 'yellow'
    width: 100
    height: childrenRect.height + 2 * units.nailUnit

    ColumnLayout {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: units.nailUnit
        spacing: units.nailUnit

        FormBoxColumn {
            caption: "Identificació"
            Layout.fillWidth: true
            Layout.preferredHeight: height

            FormParagraph {
                Layout.fillWidth: true
                Layout.preferredHeight: height
                text: "Aquest és el formulari per recollir informació sobre la visita dels inspectors als centres educatius. En el cas que hi hagi diversos sectors afectats, podeu emplenar i enviar el formulari tantes vegades com us resulti necessari."
            }
            FormParagraph {
                Layout.fillWidth: true
                Layout.preferredHeight: height
                text: "Al final de tot, es mostrarà un comprovant en pantalla, i si s'escau, també el rebreu al correu electrònic."
            }
            Item {
                height: sectionSpacing
            }
            FormParagraph {
                Layout.fillWidth: true
                Layout.preferredHeight: height
                text: "La teva adreça electrònica"
            }
            TextField {
                id: adrecaElectronica
                Layout.fillWidth: true
                Layout.preferredHeight: height
            }
            FormParagraph {
                Layout.fillWidth: true
                Layout.preferredHeight: height
                text: "* S'enviarà un comprovant a aquesta adreça."
            }
            Item {
                height: sectionSpacing
            }

            Text {
                text: 'Centre'
            }
            TriaCentre {
                Layout.fillWidth: true
            }
        }

        Item {
            height: sectionSpacing
        }

        FormBoxColumn {
            caption: "Data de la visita"
            Layout.fillWidth: true
            Layout.preferredHeight: height

            FormParagraph {
                text: "Quin dia ha estat la visita de l'inspector?"
            }
            TextField {
                Layout.fillWidth: true
            }

        }

        Item {
            height: sectionSpacing
        }

        ExclusiveGroup {
            id: quiSollicita
        }

        FormBoxColumn {
            caption: "Sol·licitud"
            Layout.fillWidth: true
            Layout.preferredHeight: height

            FormParagraph {
                Layout.fillWidth: true
                text: "Qui ha sol·licitat la visita?"
            }

            RadioButton {
                text: 'El mateix centre'
                exclusiveGroup: quiSollicita
            }
            RadioButton {
                text: 'Inspecció'
                exclusiveGroup: quiSollicita
            }

        }


        Item {
            height: sectionSpacing
        }

        FormBoxColumn {
            caption: "Inspector/s"
            Layout.fillWidth: true
            Layout.preferredHeight: height

            FormParagraph {
                text: "Quins inspectors han fet la visita?"
            }

            TextField {
                id: inspector1
                Layout.fillWidth: true
            }
            TextField {
                id: inspector2
                Layout.fillWidth: true
            }
            TextField {
                id: inspector3
                Layout.fillWidth: true
            }
            FormParagraph {
                text: "* Emplenau una casella per a cada inspector/a que hi hagi anat."
            }
        }

        Text {
            text: 'Inspector'
        }
        TextField {
            id: fieldInspector
            Layout.fillWidth: true
        }

        Text {
            text: 'Afectats'
        }

        ExclusiveGroup {
            id: afectats
        }

        FormBoxColumn {
            caption: "Afectats"
            Layout.fillWidth: true
            Layout.preferredHeight: height
            FormParagraph {
                Layout.fillWidth: true
                text: "Amb qui s'han reunit els inspectors?"
            }
            FormParagraph {
                Layout.fillWidth: true
                text: "* En cas que hi hagi més d'un àmbit afectat, emplenau un formulari diferent per a cada un."
            }
            FormBoxColumn {
                id: afectatsCEIP
                border.width: 0
                RadioButton {
                    text: 'Claustre'
                    exclusiveGroup: afectats
                }
                RadioButton {
                    text: 'Equip directiu'
                    exclusiveGroup: afectats
                }
                RadioButton {
                    text: 'Consell Escolar'
                    exclusiveGroup: afectats
                }
                RadioButton {
                    text: 'Comissió de Coordinació Pedagògica'
                    exclusiveGroup: afectats
                }
                RadioButton {
                    text: "Reunió d'àrees d'aprenentatge"
                    exclusiveGroup: afectats
                }
                RadioButton {
                    text: "Reunió de coordinació de tutors de cicle"
                    exclusiveGroup: afectats
                }
                RadioButton {
                    text: "Reunió de coordinació de mestres especialistes"
                    exclusiveGroup: afectats
                }
                RadioButton {
                    text: "Professors que apliquen TIL"
                    exclusiveGroup: afectats
                }
                RadioButton {
                    text: 'Individualment amb un docent'
                    exclusiveGroup: afectats
                }
                RadioButton {
                    text: 'Altres situacions'
                    exclusiveGroup: afectats
                }
            }
            FormBoxColumn {
                id: afectatsIES
                border.width: 0
                RadioButton {
                    text: 'Claustre'
                    exclusiveGroup: afectats
                }
                RadioButton {
                    text: 'Equip directiu'
                    exclusiveGroup: afectats
                }
                RadioButton {
                    text: 'Consell Escolar'
                    exclusiveGroup: afectats
                }
                RadioButton {
                    text: 'Comissió de Coordinació Pedagògica'
                    exclusiveGroup: afectats
                }
                RadioButton {
                    text: "Reunió de departament"
                    exclusiveGroup: afectats
                }
                RadioButton {
                    text: "Reunió de tutors"
                    exclusiveGroup: afectats
                }
                RadioButton {
                    text: "Professors que apliquen TIL"
                    exclusiveGroup: afectats
                }
                RadioButton {
                    text: 'Individualment amb un docent'
                    exclusiveGroup: afectats
                }
                RadioButton {
                    text: 'Altres situacions'
                    exclusiveGroup: afectats
                }
            }
        }

        FormBoxColumn {
            caption: "Motius de la visita"
            Layout.fillWidth: true
            Layout.preferredHeight: gridMotius.height

            GridLayout {
                id: gridMotius
                height: childrenRect.height

                columns: 2
                CheckBox {
                    id: motiuTIL
                    text: 'TIL'
                    Layout.columnSpan: (checked)?1:2
                }
                TextArea {
                    id: motiuTILexplicacio
                    visible: motiuTIL.checked
                    Layout.fillWidth: true
                }

                CheckBox {
                    id: motiuPGA
                    text: 'PGA'
                    Layout.columnSpan: (checked)?1:2
                }
                TextArea {
                    id: motiuPGAexplicacio
                    visible: motiuPGA.checked
                    Layout.fillWidth: true
                }

                CheckBox {
                    id: motiuDIM
                    text: 'Dimissions'
                    Layout.columnSpan: (checked)?1:2
                }
                TextArea {
                    id: motiuDIMexplicacio
                    visible: motiuDIM.checked
                    Layout.fillWidth: true
                }

                CheckBox {
                    id: motiuDEN
                    text: 'Denuncies'
                    Layout.columnSpan: (checked)?1:2
                }
                TextArea {
                    id: motiuDENexplicacio
                    visible: motiuDEN.checked
                    Layout.fillWidth: true
                }

                CheckBox {
                    id: motiuSIM
                    text: 'Simbols'
                    Layout.columnSpan: (checked)?1:2
                }
                TextArea {
                    id: motiuSIMexplicacio
                    visible: motiuSIM.checked
                    Layout.fillWidth: true
                }

                CheckBox {
                    id: motiuAltres
                    text: 'Altres'
                    Layout.columnSpan: (checked)?1:2
                }
                TextArea {
                    id: motiuAltresExplicacio
                    visible: motiuAltres.checked
                    Layout.fillWidth: true
                }
            }

        }

    }
}
