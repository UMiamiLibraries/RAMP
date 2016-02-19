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


// This function delays the function that a keystroke triggers. You can change the delay at the bottom of the function.

function throttle(f, delay) {
    var timer = null;
    return function () {
        var context = this, args = arguments;
        clearTimeout(timer);
        timer = window.setTimeout(function () {
                f.apply(context, args);
            },
            delay || 500);
    };
}

function render_help_template(div_id) {

    // Render the first help template
    var help_template = _.template(
        $("#" + div_id).html()
    );

    $("#help_viewport").append(
        help_template()
    );
}

function clear_help_template_container() {
    $('.help_container').remove();
}


function showLoadingImage() {
    $('#loading_image').html("<div class=\"loader\"><i class=\"fa fa-spinner fa-pulse\"></i> Loading...</div>").show();
}

function hideLoadingImage() {
    $('#loading_image').hide();
}

function renderFlashMessage(message) {
    $('#flash_message').html(message);
}

function clearFlashMessage() {
    $('#flash_message').html('');
}

