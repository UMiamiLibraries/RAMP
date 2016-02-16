//functions that can be used by multiple js files

/*
 * encode_utf8 encodes passed string to utf8
 * @method encode_utf8
 */
function encode_utf8(s) {
    return unescape(encodeURIComponent(s));
}

/*
 * decode_utf8 decodes passed string from utf8
 * @method decode_utf8
 */
function decode_utf8(s) {
    return decodeURIComponent(escape(s));
}

/*
 * unique removes duplicates from passed array and retuns it
 * @method unique
 */
var unique = function (origArr) {
    var newArr = [],
        origLen = origArr.length,
        found,
        x, y;

    for (x = 0; x < origLen; x++) {
        found = undefined;
        for (y = 0; y < newArr.length; y++) {
            if (origArr[x] === newArr[y]) {
                found = true;
                break;
            }
        }
        if (!found) newArr.push(origArr[x]);
    }
    return newArr;
};

/*
 * html_decode decoded html entities
 * @method html_decode
 */
function html_decode(lstrEncodedHTML) {
    return lstrEncodedHTML.replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"');
}
