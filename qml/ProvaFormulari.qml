import QtQuick 2.3

Item {
    function getContents() {
        return '
    {
        "name": "Visita inspectors",
        "version": "1.2",
        "language": "1.0",
        "author": "Joan Miquel Payeras Crespi",
        "postTo": "",
        "title": "Visita dels inspectors",
        "description": "Formulari per recollir les impressions de la visita dels inspectors",
        "background": "#AAFFFF",
        "fields": [
            {
                "name": "adrecaelectronica",
                "type": "text",
                "title": "Correu electronic",
                "description": "",
                "required": 1
            },
            {
                "name": "codicentre",
                "type": "enumeration",
                "title": "Codi del centre",
                "description": "Centre en què estau",
                "values": [
                    {
                        "code": "100",
                        "title": "IES Clara Hammerl (Port de Pollença)"
                    },
                    {
                        "code": "101",
                        "title": "IES Binissalem (Mallorca)"
                    }
                ],
                "required": 1
            },
            {
                "name": "datadades",
                "type": "date",
                "title": "Data de les dades",
                "description": "Quan s\'han enregistrat les dades",
                "required": 1
            },
            {
                "name": "ambits",
                "type": "enumeration",
                "title": "Àmbits afectats",
                "description": "A quins àmbits va afectar la visita",
                "values": [
                    {
                        "code": "ambitCEIPClaustre",
                        "title": "Claustre"
                    },
                    {
                        "code": "ambitCEIPED",
                        "title": "Equip directiu"
                    },
                    {
                        "code": "ambitCEIPCE",
                        "title": "Consell Escolar"
                    },
                    {
                        "code": "ambitCEIPCCP",
                        "title": "Comissió de Coordinació Pedagògica"
                    },
                    {
                        "code": "ambitCEIParees",
                        "title": "Reunió d\'àrees d\'aprenentatge"
                    },
                    {
                        "code": "ambitCEIPcoordTutors",
                        "title": "Reunió de coordinació de tutors de cicle"
                    },
                    {
                        "code": "ambitCEIPcoordEspecialistes",
                        "title": "Reunió de coordinació de mestres especialistes"
                    },
                    {
                        "code": "ambitCEIPprofessorsTIL",
                        "title": "Professors que apliquen TIL"
                    },
                    {
                        "code": "ambitCEIPindividual",
                        "title": "Individualment amb un docent"
                    },
                    {
                        "code": "ambitCEIPaltres",
                        "title": "Altres situacions"
                    }
                ]
            }
        ]
    }

    ';
    }
}
