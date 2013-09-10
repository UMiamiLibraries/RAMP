$(document).ready(function () {

$( function() {
    $("button[data-href]").click( function() {
        location.href = $(this).attr("data-href");
    });
});

$('#menu_button').click(function () {

$('#menu_2').toggle();


});


$("#eac_edit a").click(function() {

$('#menu_3').toggle();

});



$('.ead_files').change(function () {

console.log(this.value);
document.cookie = "ead_file=" + this.value;
document.cookie = "ead_file_last=" + this.value;
document.cookie = "entity_name=" + this.options[this.selectedIndex].innerHTML;
//console.log($(this).html().text());
console.log(getCookie("ead_file"));
window.location = "eac_edit.php";

});



$('#new_select').change(function () {

document.cookie = "entity_type=" + this.value; 

window.location="new_eac.php"; 


});

});




function getCookies() {
    var c = document.cookie, v = 0, cookies = {};
    if (document.cookie.match(/^\s*\$Version=(?:"1"|1);\s*(.*)/)) {
        c = RegExp.$1;
        v = 1;
    }
    if (v === 0) {
        c.split(/[,;]/).map(function(cookie) {
            var parts = cookie.split(/=/, 2),
                name = decodeURIComponent(parts[0].trimLeft()),
                value = parts.length > 1 ? decodeURIComponent(parts[1].trimRight()) : null;
            cookies[name] = value;
        });
    } else {
        c.match(/(?:^|\s+)([!#$%&'*+\-.0-9A-Z^`a-z|~]+)=([!#$%&'*+\-.0-9A-Z^`a-z|~]*|"(?:[\x20-\x7E\x80\xFF]|\\[\x00-\x7F])*")(?=\s*[,;]|$)/g).map(function($0, $1) {
            var name = $0,
                value = $1.charAt(0) === '"'
                          ? $1.substr(1, -1).replace(/\\(.)/g, "$1")
                          : $1;
            cookies[name] = value;
        });
    }
    return cookies;
}
function getCookie(name) {
    return getCookies()[name];
}
