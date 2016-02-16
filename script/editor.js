$(document).ready(function () {

    hideReadOnlyBtn();
    toggleReadOnly();

});

function build_editor(eac_xml_file) {

    //hide the wiki xml swith buttons initially
    $('#xml_switch').hide();

    // When one of the files is selected...
    var eac_xml_path = eac_xml_file;




    $.get('ajax/get_eac_xml.php?eac=' + eac_xml_path, function (data) {

        // Set up Ace editor
        editor.getSession().setValue(data);
        editor.resize();
        editor.focus();

        // Stick the XML in Ace editor
        edited_xml = editor.getSession().setUseWrapMode(true); // Set text wrap --timathom
        edited_xml = editor.getValue();

        //set editor to ready only
        editor.setReadOnly(true);

        //enable ingest buttons
        $('.ingest_button').removeAttr('disabled');

        // then validate the XML
        validateXML();


    });

    // Check to see if there is already wiki markup. If so, show switcher. --timathom
    $.get('ajax/get_wiki.php', {ead_path: eac_xml_path}, function (markup) {

        if (markup == '') {
           // do nothing with markup
        }
        else {
            // Set the wiki conversion status
            if (record.wikiConversion !== true) {
                record.wikiConversion = true;
            }
        }
    });
}

$('.ead_files').change(function () {

    record.eadFile = this.value;
    record.entityName = $(this).children("option:selected").text();
    record.savedXml = "";
    record.wikiConversion = "";

    build_editor(record.eadFile);




});


$('#save_eac').click(function (data) {
    // This saves the XML by getting the the text from Ace editor

    // Set "saved" status
    if (record.savedXml !== true) {
        record.savedXml = true;
    }
    record.eacXml = editor.getSession().getValue();

    // POST XML to update_eac_xml

    $.post('ajax/update_eac_xml.php', {xml: record.eacXml, ead_file: eac_xml_path}, function (data) {


    }).done(function () {
        $savedialog.dialog('open');


    });

});

$('#download_submit').click(function () {
    fetch_xml = editor.getSession();
    fetch_xml = editor.getValue();

    $('#download_xml').val(fetch_xml);

    // Get file name from status.
    var file_path = record.eadFile;

    var find_ead = "ead/";

    file_path = file_path.substring(file_path.indexOf(find_ead) + find_ead.length);

    file_path = file_path.toLowerCase(); // file name as entity name
    file_path = file_path.replace(/(,\s)|(\s)/g, "_");

    $('#file_name').val(file_path);
});



$('#editor').keyup(throttle(function () {
    // When the user is typing, validate it

    record.eacXml = editor.getValue();
    validateXML();


}));


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


$('#convert_to_wiki').click(function () {

    // Set status for showing wiki screen on dialog close.
    if (record.onWiki !== true) {
        record.onWiki = true;
    }

    // Added logic for save dialog. --timathom
    if (record.savedXml !== true) {
        $unsaveddialog.dialog('open');
    }

    else {
        $('.main_edit').hide();
        eacToMediaWiki();
    }

});


function wikiCheck() {

    $.get('ajax/get_wiki.php', {ead_path: eac_xml_path}, function (markup) {


        $('.main-edit').show();


        if (markup != "") {
            // Hide this stuff if there is wiki markup

            $('#wiki_switch_button').css({"background": "gray"});

            $('.main_edit').hide();

            $('html').css("min-width", "1250px");

            //Append some controls for dealing with the wikimarkup

            if ($('#wikieditor').length == 0) {
                $('#main_content').append("<div id=\"wikieditor\" class=\"wiki_edit\"><div class=\"wiki_container wiki_edit\"><h1 id=\"local_wiki\">Local article (transformed from EAC-CPF record) <a style=\"font-size:small; float:right; margin-top:3px;\" target=\"_blank\" href=\"https://en.wikipedia.org/wiki/Help:Wiki_markup\">Help with wiki markup</a></h1> \
<textarea id=\"wikimarkup\" class=\"wiki_edit\">" + markup + "</textarea></div></div>");
            } else {
                $('#wikieditor').append("<div class=\"wiki_container wiki_edit\"><h1 id=\"local_wiki\">Local article (transformed from EAC-CPF record) <a style=\"font-size:small; float:right; margin-top:3px;\" target=\"_blank\" href=\"https://en.wikipedia.org/wiki/Help:Wiki_markup\">Help with wiki markup</a></h1> \
<textarea id=\"wikimarkup\">" + markup + "</textarea></div>");
            }

            $('#edit_controls').append("<button class=\"update_button pure-button pure-button-primary wiki_edit\" id=\"wiki_update\">Save Local Article</button><button id=\"get_wiki\" class=\"pure-button pure-button-primary wiki_edit\">Check Wikipedia for Existing Article</button>");

            setupGetWiki();

            $(window).resize(function () {

            });


            $('#edit_xml').on('click', function () {

                //Show the XML editor ui and wiki markup editor
                $('.main_edit').show();
                $('.wiki_edit').remove();

            });

            $('#wiki_update').on('click', function () {

                updated_markup = document.getElementById('wikimarkup').value;

                $.post('ajax/update_wiki.php', {media_wiki: updated_markup, ead_path: eac_xml_path}, function (data) {

                    $savewikidialog.dialog('open');

                });


            });

        }


    });

}


function eacToMediaWiki() {

    edited_xml = editor.getValue();

    $.post('ajax/eac_mediawiki.php', {eac_text: edited_xml}, function (data) {
        $('#wiki_load').remove();
        $('#main_content').append('<div id="wikieditor" class="wiki_edit"><div class="wiki_container"><h1>Local article (transformed from EAC-CPF record)</h1> \
<textarea id="wikimarkup">' + data + '</textarea></div></div>');
        $('#edit_controls').append("<button class=\"save_button pure-button pure-button-primary wiki_edit\"  id=\"wiki_save\">Save Local Article</button>");


        var wiki_height = $(window).height() / 1.3;

        $(window).resize(function () {

            var wiki_height = $(window).height() / 1.3;


        });


        // Save the wikimarkup

        $('#wiki_save').on('click', function () {

            var wiki_markup_data = $('#wikimarkup').val();

            $('.wiki_edit').remove();

            $('#xml_switch_button').css({"background": "#0078e7"});


            $.post('ajax/post_wiki.php', {media_wiki: wiki_markup_data, ead_path: eac_xml_path}, function (data) {

                // Hide this stuff if there is wiki markup

                $('.wiki_edit').hide();

                setupGetWiki();

                $('#wiki_switch').show();
                //$('#wiki_switch_button').unbind();

                wikiCheck();

                var wiki_height = $(window).height() / 1.3;

                $(window).resize(function () {

                });


                $('#edit_xml').on('click', function () {
                    //Show the XML editor ui and wiki markup editor
                    $('.main_edit').show();
                    $('.wiki_edit').remove();

                });

                $('#wiki_update').on('click', function () {
                    $('#dialog_box').html("<p>Local article saved</p>");
                    makeDialog('#dialog_box', ' ');
                    updated_markup = document.getElementById('wikimarkup').value;
                    $.post('update_wiki.php', {media_wiki: updated_markup, ead_path: eac_xml_path}, function (data) {


                    });


                });

            });

        });

        $('#wiki_save').click();
    });


}


$('#wiki_switch_button').click(function () {

    // Set status for showing wiki screen on dialog close.

    if (record.onWiki !== true) {
        record.onWiki = true;
    }

    $('.wiki_edit').remove();

    wikiCheck();


    $('#xml_switch_button').css({"background": "#0078e7"});

});

$('#xml_switch_button').click(function () {

    $('html').css("min-width", "1100px");

    // Unset "onWiki" status. --timathom
    if (record.onWiki == true) {
        record.onWiki = false;
    }
    editXML();

});

function editXML() {
    //Show the XML editor ui and wiki markup editor


    $('#wiki_switch_button').css({"background": "#0078e7"});
    $('#xml_switch_button').css({"background": "gray"});
    $('.wiki_edit').remove();
    $('.main_edit').show();

    $('#wiki_update').on('click', function () {

        $('#dialog_box').html("<p>File saved</p>");
        makeDialog('#dialog_box', ' ');
        updated_markup = document.getElementById('wikimarkup').value;
        $.post('ajax/update_wiki.php', {media_wiki: updated_markup, ead_path: eac_xml_path}, function (data) {
        });
    });

}


function remove_wiki() {
    $('#wikieditor').remove();
    $('.wiki_edit').remove();
}




// Save dialogs
var $savedialog = $('<div></div>')

    .html('XML Saved!')
    .dialog({
        autoOpen: false,
        closeOnEscape: true,
        title: 'Saved',
        buttons: {
            "OK": function () {
                $(this).dialog("close");
            }
        }

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
            title: 'Confirm',
            buttons: {
                "Yes": function () {
                    $(this).dialog("close");
                    $('.main_edit').hide();
                    //$('#main_content').append('<img id="loading-image" src="style/images/loading.gif" alt="loading"/><div id="wiki_load">Converting to wiki markup... This may take a minute or two.</div>');
                    eacToMediaWiki();
                },
                "No": function () {
                    $(this).dialog("close");
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
            "OK": function () {
                $(this).dialog("close");
            }
        }


    });


/*
 * makeDialog creates dialog box from passed selector with passed title
 * @method makeDialog
 */
function makeDialog(lstrSelector, lstrTitle, callback) {
    if (typeof lstrTitle == 'undefined' || lstrTitle == '')
        lstrTitle = 'Response';

    $(lstrSelector).dialog({
        autoOpen: true,
        resizable: false,
        modal: true,
        closeOnEscape: true,
        title: lstrTitle,
        buttons: {
            "OK": function () {
                $(this).dialog("close");
                $(this).remove();
            }
        },
        close: function () {
            $(this).remove();

            if (typeof callback != 'undefined')
                callback();
        }
    });
}

/*
 * makePromptDialog creates dialog prompt box from passed selector with passed title and calls callback once OK is clicked
 * @method makePromptDialog
 */
function makePromptDialog(lstrSelector, lstrTitle, callback) {
    $(lstrSelector).dialog({
        autoOpen: true,
        resizable: true,
        modal: true,
        width: 'auto',
        closeOnEscape: true,
        title: lstrTitle,

        buttons:{
            "OK":function(){            	            	                
                callback(this);     
                if ( record.onWiki === true )
                {
                    //$('#entity_name').hide();
           	        $('.wiki_edit').hide();
           	        $('#get_wiki').hide();
           	        $('#wiki_switch').hide();
           	        $('#post_wiki').hide();
           	    }
           	    else
           	    {
           	        $('.main_edit').hide();
           	        //$('#entity_name').hide();
           	        $('#wiki_switch').hide();
           	    }
            }
        },
        close: function () {
            $(this).remove();
            if (record.onWiki === true) {
                $('#entity_name').show();
                $('.wiki_edit').show();
                $('#get_wiki').show();
                $('#wiki_switch').show();
                $('#post_wiki').show();
                $('.main_edit').hide();
            }
            else {
                $('.main_edit').show();
                $('#entity_name').show();
                // Check to see if there is already wiki markup. If so, show switcher. --timathom
                if (record.onWiki === true) {
                    $('#wiki_switch').show();
                }
                else {
                    $('#wiki_switch').hide();
                }
            }
        }
    });

    $(lstrSelector).find("form").submit(function (event) {
        $(this).parent().parent().find('span:contains("Ok")').click();
        event.preventDefault();
    });
}



/* added by cbrownroberts 02-2016 */

function hideReadOnlyBtn() {
    $('#readonly_toggle_btn').hide();
}

function showReadOnlyBtn() {
    $('#readonly_toggle_btn').show();
}

function toggleReadOnly() {
    $('#editor_readonly_button').on('click', function () {

        if($('#editor_readonly_button').data('readonly') === 'on') {

            editor.setReadOnly(false);
            $('#editor_readonly_button').data('readonly', 'off');
            $('#readonly_status').text('XML Editing Enabled');

        } else {

            editor.setReadOnly(true);
            $('#editor_readonly_button').data('readonly', 'on');
            $('#readonly_status').text('XML Editing Disabled');

        }
    });
}




