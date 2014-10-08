$(document).ready(function() {    
    function cookie_check () {

        if (getCookie('ead_file')) {

            if (getCookie('ead_file') === '""') 
            {		                
		        $('#ead_files').hide();
		        $('.main_edit').hide();
                $('#editor_mask').hide();
		
		        $('#entity_name').html('Please select a record to edit from the menu.');
		        $('#entity_name').show();
            } 
            else 
            {
                console.log(getCookie('ead_file'));
                build_editor(getCookie('ead_file'));
                $('#entity_name').html('Now Editing: ' + getCookie('entity_name'));
		        $('#ead_files').hide();
            }
	     }
	     else 
	     {
	
	     }
    }
    function build_editor(eac_xml_file) {       
		
	$('#xml_switch_button').css({"background":"gray"});

	$('.main_edit').show();
	
	// When one of the files is selected...
	eac_xml_path = eac_xml_file;
	
	// Check to see if there is already wiki markup. If so, show switcher. --timathom
	$.get('get_wiki.php', {ead_path : eac_xml_path}, function(markup) {
    
        if ( markup == '')
        {
            $('#wiki_switch').hide();              
        }
        else
        {
            $('#wiki_switch').show();
            // Set "saved" cookie. --timathom
	        if ( getCookie('wiki') != 'present' )
	        {
	            document.cookie = 'wiki=present';
	        }
        }    		
	});
	
	//Get the XML

	$.get('get_eac_xml.php?eac=' + eac_xml_path , function (data) {

	    // Set up Ace editor        
  	    editor.getSession().setValue(data); 
  	    editor.resize();  	    
	    editor.focus();  	      	      	      	   

	    // Stick the XML in Ace editor
	    edited_xml = editor.getSession().setUseWrapMode(true); // Set text wrap --timathom
	    edited_xml = editor.getValue();	    	    

	    //enable ingest buttons
	    $('.ingest_button').removeAttr('disabled');

	    document.cookie = 'ead_file=""';
	    	   
	    // then validate the XML
	    validateXML();

	    // Check to see if there is some existing wiki markup
	    // wikiCheck();
	   
   	});


	$('#save_eac').click(function(data) {
	    // This saves the XML by getting the the text from Ace editor
	    
	    // Set "saved" cookie. --timathom
	    if ( getCookie('saved') != 'saved' )
	    {
	        document.cookie = 'saved=saved';
	    }
	    editor_xml = editor.getSession().getValue();
	    	   
	    // POST XML to update_eac_xml

	    $.post('update_eac_xml.php', {xml: editor_xml, ead_file: eac_xml_path} , function(data) {
	        	        

	    }).done(function () { 
		$('.save_arrow').html("&#10003;");
		$savedialog.dialog('open');
		

	    });
	    
        });
        
        $('#download_submit').click(function() {
            fetch_xml = editor.getSession();
	        fetch_xml = editor.getValue();
        
            $('#download_xml').val(fetch_xml);
            
            // Get file name from cookie.
            var file_path = getCookie('ead_file_last');
            
            var find_ead = "ead/";
            
            file_path = file_path.substring(file_path.indexOf(find_ead) + find_ead.length); 
                        
            //file_path = file_path.match(/\/ead\/(.*)/)[1]; // file name as ID
            file_path = file_path.toLowerCase(); // file name as entity name            
            file_path = file_path.replace(/(,\s)|(\s)/g, "_");
            //file_path = file_path.replace(/(.)/g, "");
            
            /*
            var last_char = file_path.substr( file_path.length - 1 );
                   
            if( last_char == "." )
            {
                file_path = file_path.slice(0, -1);
            }
            */
            //file_path += ".xml";
                                  
            $('#file_name').val(file_path);
            
            //$('#download_link').attr('href','download.php/' + file_path);
            
	        });                        
                	       	                                                      
    }

    $('#ead_files').ready(function () {
	cookie_check();


    });

    $('#ead_files').change (function()  {
	cookie_check();

    });


    $('#editor').keyup(throttle(function() {
	// When the user is typing, validate it

	edited_xml = editor.getValue();

	validateXML();



    }));


    // This function delays the function that a keystroke triggers. You can change the delay at the bottom of the function.

    function throttle(f, delay){
	var timer = null;
	return function(){
            var context = this, args = arguments;
            clearTimeout(timer);
            timer = window.setTimeout(function(){
		f.apply(context, args);
            },
				      delay || 500);
	};
    }

    window.validateXML = function( callback ) {


	// POST some XML to validate.php and get back some JSON that includes either an response that says that it's valid or a JSON document that includes the errrors
	$.post('validate.php', {eac_xml: edited_xml}, function(data) {

	    if(typeof callback == 'undefined')
		callback = function(){};

	    if (data.status === "valid") {
		// Make the little Oxygen-esque square green if valid

		$('#validation').css({"background-color":"green"});

		// Make the valdiation text area blank

		$('#validation_text').html('Valid XML');

		callback(true);

	    } else {
		response = data;
		// Make the Oxygen-esque square red
		$('#validation').css({"background-color":"red"});

		// Stick the error message into the validation_text div
		$('#validation_text').html('<p>Error: ' + response[0].message + '</p><p>Line: ' + response[0].line + '</p>');

		callback(false);
	    }

	},"json").fail(function() {
            $('#validation').css({"background-color":"red"});
	    $('#validation_text').html('<p>Your XML is not well-formed or there is an issue with the validation service</p>');

	    if(typeof callback == 'undefined')
		callback = function(){};

            console.log("error");
            callback(false);
        });
    }


    $('#convert_to_wiki').click(function() {
    
        // Set cookie for showing wiki screen on dialog close.
        if ( getCookie('onWiki') != 'true' )
        {
            document.cookie = 'onWiki=true';
        }
   
       // Added logic for save dialog. --timathom
       if ( getCookie('saved') != 'saved')
       {
           $unsaveddialog.dialog('open');
       }
              
       else 
       {    
           $('.main_edit').hide();
           $('#loading-image').remove();
           $('#main_content').append('<img id="loading-image" src="style/images/loading.gif" alt="loading"/><div id="wiki_load">Converting to wiki markup... This may take a minute or two.</div>');
           eacToMediaWiki();
       }     
        	                   
    });


    function wikiCheck() {

	$.get('get_wiki.php', {ead_path : eac_xml_path}, function(markup) {


	    $('.main-edit').show();


	    if (markup != "") {
		// Hide this stuff if there is wiki markup
		
		$('#wiki_switch_button').css({"background" : "gray" });

		$('.main_edit').hide();
		
		$('html').css("min-width","1250px");

		//Append some controls for dealing with the wikimarkup

		if( $('#wikieditor').length == 0)
		{
		    $('#main_content').append("<div id=\"wikieditor\" class=\"wiki_edit\"><div class=\"wiki_container wiki_edit\"><h1 id=\"local_wiki\">Local article (transformed from EAC-CPF record) <a style=\"font-size:small; float:right; margin-top:3px;\" target=\"_blank\" href=\"https://en.wikipedia.org/wiki/Help:Wiki_markup\">Help with wiki markup</a></h1> \
<textarea id=\"wikimarkup\" class=\"wiki_edit\">" + markup + "</textarea></div></div>");
		}else
		{
		    $('#wikieditor').append("<div class=\"wiki_container wiki_edit\"><h1 id=\"local_wiki\">Local article (transformed from EAC-CPF record) <a style=\"font-size:small; float:right; margin-top:3px;\" target=\"_blank\" href=\"https://en.wikipedia.org/wiki/Help:Wiki_markup\">Help with wiki markup</a></h1> \
<textarea id=\"wikimarkup\">" + markup + "</textarea></div>");
		}		

		$('#edit_controls').append("<button class=\"update_button pure-button pure-button-primary wiki_edit\" id=\"wiki_update\">Save Local Article</button><button id=\"get_wiki\" class=\"pure-button pure-button-primary wiki_edit\">Check Wikipedia for Existing Article</button>");

		setupGetWiki();

		$(window).resize(function() {

		});


	   	$('#edit_xml').on('click', function() {

    		//Show the XML editor ui and wiki markup editor

		    $('.main_edit').show();

		    $('.wiki_edit').remove();

	   	});

	   	$('#wiki_update').on('click', function() {

	   	    updated_markup = document.getElementById('wikimarkup').value;

		    $.post('update_wiki.php', {media_wiki: updated_markup, ead_path: eac_xml_path}, function(data) {
			
			$savewikidialog.dialog('open');
			//console.log("ahh!");

	    	});


		});

	    }


	});

    }


    function eacToMediaWiki() {    

	edited_xml = editor.getValue();

	$.post('eac_mediawiki.php', {eac_text: edited_xml}, function(data) {	    
        $('#loading-image').remove();
        $('#wiki_load').remove();
	    $('#main_content').append('<div id="wikieditor" class="wiki_edit"><div class="wiki_container"><h1>Local article (transformed from EAC-CPF record)</h1> \
<textarea id="wikimarkup">' + data + '</textarea></div></div>');
	    $('#edit_controls').append("<button class=\"save_button pure-button pure-button-primary wiki_edit\"  id=\"wiki_save\">Save Local Article</button>");


	    var wiki_height = $(window).height() / 1.3;

	    $(window).resize(function() {

		var wiki_height = $(window).height() / 1.3;


	    });


	    // Save the wikimarkup

	    $('#wiki_save').on('click', function() {

		wiki_markup_data = $('#wikimarkup').val();

		$('.wiki_edit').remove();

	        $('#xml_switch_button').css({"background":"#0078e7"});



	    	$.post('post_wiki.php', {media_wiki: wiki_markup_data, ead_path: eac_xml_path}, function(data) {

	    	    // Hide this stuff if there is wiki markup

		    $('.wiki_edit').hide();

		    setupGetWiki();

  		    $('#wiki_switch').show();
  		    //$('#wiki_switch_button').unbind();

		    wikiCheck();

		    var wiki_height = $(window).height() / 1.3;

		    $(window).resize(function() {

		    });


		    $('#edit_xml').on('click', function() {
		    	//Show the XML editor ui and wiki markup editor
			$('.main_edit').show();
			$('.wiki_edit').remove();

		    });

		    $('#wiki_update').on('click', function() {
			$('#dialog_box').html("<p>Local article saved</p>");
			makeDialog('#dialog_box', ' ');
			updated_markup = document.getElementById('wikimarkup').value;
			$.post('update_wiki.php', {media_wiki: updated_markup, ead_path: eac_xml_path}, function(data) {



			});


		    });

		});

	    });

	    $('#wiki_save').click();
	});


    }


    $('#wiki_switch_button').click(function() {
        
        // Set cookie for showing wiki screen on dialog close.
        if ( getCookie('onWiki') != 'true' )
        {
            document.cookie = 'onWiki=true';
        }
        $('.wiki_edit').remove();

	    wikiCheck();


        $('#xml_switch_button').css({"background":"#0078e7"});

    });

    $('#xml_switch_button').click(function() {
    
    $('html').css("min-width","1100px");
    
    // Unset "onWiki" cookie. --timathom
    if ( getCookie('onWiki') == 'true' )
    {
        document.cookie = 'onWiki=';
    }
    
	editXML();

    });

    function editXML() {
    	//Show the XML editor ui and wiki markup editor


	$('#wiki_switch_button').css({"background":"#0078e7"});
	$('#xml_switch_button').css({"background":"gray"});
    $('.wiki_edit').remove();
	$('.main_edit').show();

	$('#wiki_update').on('click', function() {

	    $('#dialog_box').html("<p>File saved</p>");
	    makeDialog('#dialog_box', ' ');


	    updated_markup = document.getElementById('wikimarkup').value;

	    $.post('update_wiki.php', {media_wiki: updated_markup, ead_path: eac_xml_path}, function(data) {



	    });




	});

    }


    function remove_wiki() {
        $('#wikieditor').remove();
        $('.wiki_edit').remove();
    }


    //depenging on value of the cookie, display login or logout
    if( getCookie('ramp_wiki_li') == null )
    {
	$('#menu').append("<li id=\"wiki_login\" class=\"wiki_login menu_slice\"><a href=\"#\">Wiki Login</a></li>");
    }else
    {
	$('#menu').append("<li id=\"wiki_logout\" class=\"wiki_login menu_slice\"><a href=\"#\">| Wiki Logout |</a></li>");
    }

    var ace_height = $(window).height() / 1.5;
    $('#editor_container').css ( { "height" : ace_height });


    $(window).resize(function() {

	var ace_height = $(window).height() / 1.5;
	$('#editor_container').css ( { "height" : ace_height });

    });

    


    // Save dialogs 


    var $savedialog = $('<div></div>')
        
    	.html('XML Saved!')
    	.dialog({
    	    autoOpen: false,
    	    closeOnEscape: true,
            title: 'Saved',
    	    buttons: {
		"OK" : function () {
		    $( this ).dialog( "close" );
		}
	    }

    	});
    
    // Added save confirmation to "Convert to Wiki Markup" --timathom
    var $unsaveddialog = $('<div></div>')
        .html('Your record has not been saved. If you have changes, they will be lost. Do you want to proceed?')
        .dialog({
            autoOpen: false,
            title : 'Confirm',
            buttons : {                
                "Yes" : function() {            
                    $( this ).dialog( "close" );
                    $('.main_edit').hide();                                                                                                          
                    $('#main_content').append('<img id="loading-image" src="style/images/loading.gif" alt="loading"/><div id="wiki_load">Converting to wiki markup... This may take a minute or two.</div>');
                    eacToMediaWiki();
                },
                "No" : function() {
                    $( this ).dialog( "close" );
                }                
            }
        });        

    var $savewikidialog = $('<div></div>')
    	.html('Your local Wikipedia article has been saved.')
    	.dialog({
    	    autoOpen: false,
    	    closeOnEscape: true,
            title: 'Saved',
    	    buttons: {
		"OK" : function () {
		    $( this ).dialog( "close" );
		}
	    }
	    
    	});
        
});


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
var unique = function(origArr) {
    var newArr = [],
	origLen = origArr.length,
	found,
	x, y;

    for ( x = 0; x < origLen; x++ ) {
        found = undefined;
        for ( y = 0; y < newArr.length; y++ ) {
            if ( origArr[x] === newArr[y] ) {
		found = true;
		break;
            }
        }
        if ( !found) newArr.push( origArr[x] );
    }
    return newArr;
};

/*
 * html_decode decoded html entities
 * @method html_decode
 */
function html_decode( lstrEncodedHTML )
{
    return lstrEncodedHTML.replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"');
}

/*
 * makeDialog creates dialog box from passed selector with passed title
 * @method makeDialog
 */
function makeDialog( lstrSelector, lstrTitle, callback )
{
    if( typeof lstrTitle == 'undefined' || lstrTitle == '')
	lstrTitle = 'Response';

    $(lstrSelector).dialog({
        autoOpen: true,
        resizable: false,
        modal: true,
        closeOnEscape: true,
        title: lstrTitle,
        buttons:{
            "OK":function(){
                $(this).dialog("close");
                $(this).remove();
            }
        },
        close:function(){
            $(this).remove();

            if( typeof callback != 'undefined' )
                callback();
        }
    });
}

/*
 * makePromptDialog creates dialog prompt box from passed selector with passed title and calls callback once OK is clicked
 * @method makePromptDialog
 */
function makePromptDialog( lstrSelector, lstrTitle, callback )
{
    $( lstrSelector ).dialog({
        autoOpen: true,
        resizable: true,
        modal: true,
        width: 'auto',
        closeOnEscape: true,
        title: lstrTitle,
        buttons:{
            "OK":function(){            	            	                
                callback(this);     
                if ( getCookie('onWiki') == 'true' )   
                {
                    $('#entity_name').hide();
           	        $('.wiki_edit').hide();
           	        $('#get_wiki').hide();
           	        $('#wiki_switch').hide();
           	        $('#post_wiki').hide();
           	    }
           	    else
           	    {
           	        $('.main_edit').hide();
           	        $('#entity_name').hide();
           	        $('#wiki_switch').hide();
           	    }
            }
        },
        close:function(){
            $(this).remove();
            if ( getCookie('onWiki') == 'true' )   
            {
                 $('#entity_name').show();
           		 $('.wiki_edit').show();
           		 $('#get_wiki').show();
           		 $('#wiki_switch').show();
           		 $('#post_wiki').show();
                 $('.main_edit').hide();           		 
            }
            else
            {
                 $('.main_edit').show();
                 $('#entity_name').show();
                 // Check to see if there is already wiki markup. If so, show switcher. --timathom
                 if ( getCookie('wiki') == 'present' )   
                 {
                     $('#wiki_switch').show();    	                           	
                 }
                 else
                 {
                     $('#wiki_switch').hide();
                 }                 
            }	                        
        }
    });

    $( lstrSelector ).find( "form" ).submit(function( event ) {
        $(this).parent().parent().find('span:contains("Ok")').click();
        event.preventDefault();
    });
}

/*
 * getCookie gets values of cookie
 * @method getCookie
 */
function getCookie(c_name)
{
    var c_value = document.cookie;
    var c_start = c_value.indexOf(" " + c_name + "=");
    if (c_start == -1)
    {
	c_start = c_value.indexOf(c_name + "=");
    }
    if (c_start == -1)
    {
	c_value = null;
    }
    else
    {
	c_start = c_value.indexOf("=", c_start) + 1;
	var c_end = c_value.indexOf(";", c_start);
	if (c_end == -1)
	{
	    c_end = c_value.length;
	}
	c_value = unescape(c_value.substring(c_start,c_end));
    }
    return c_value;
}

/*
 * deleteCookie deletes cookie
 * @method deleteCookie
 */
function deleteCookie(name)
{
    document.cookie = name + '=; expires=Thu, 01 Jan 1970 00:00:01 GMT;';
}
