.import 'qrc:///twitter-text-js/twitter-text-1.9.1.js' as Tw

function autoLink(str) {
    console.log(typeof (Tw));
    for (var prop in Tw) {
        console.log(prop + '--->' + Tw[prop]);
    }

    return Tw.autoLink(str);
}
