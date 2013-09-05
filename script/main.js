$(document).ready(function () {

$( function() {
    $("button[data-href]").click( function() {
        location.href = $(this).attr("data-href");
    });
});

$('#menu_button').click(function () {

$('#menu_2').toggle();


});


});



