$(document).ready(function () {
   
   // Show select box by default, so that we can refresh after import.   
   $("#menu_3").show(); 
   
   // Added jQuery UI example tooltip. --timathom
   $(this).tooltip(
    		      {
                        position: {
                        my: "center bottom-10",
                        at: "center top",
                        using: function( position, feedback ) {
                        $( this ).css( position );
                        $( "<div>" )
                        .addClass( "arrow" )
                        .addClass( feedback.vertical )
                        .addClass( feedback.horizontal )
                        .appendTo( this );
                       }
                    }
                  });    
$( function() {
    $("button[data-href]").click( function() {
        location.href = $(this).attr("data-href");
    });
});

$('#menu_button').click(function () {

	$('#menu_2').toggle();

});


$("#eac_edit a").on("click",function() {

	$("#menu_3").toggle();


});

// Refresh page to populate select box.
$('.ead_files').on("click",function(){
	
	if (getCookie('convert')) {
	
        if (getCookie('convert') == 'true') 
        {
            document.cookie = "convert=";
            location.reload();            		            		              		
        }	            
        
	}
	
})

$('.ead_files').change(function () {

console.log(this.value);
document.cookie = "ead_file=" + this.value;
document.cookie = "ead_file_last=" + this.value;
document.cookie = "entity_name=" + $(this).children("option:selected").text();
//this.options[this.selectedIndex].innerHTML;
document.cookie = "saved="; // Unset "saved" cookie. --timathom
document.cookie = "wiki="; // Unset "wiki" cookie. --timathom

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
