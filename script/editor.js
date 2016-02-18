$(document).ready(function () {


    //initially disable module buttons
    disableAllModuleButtons();

    //initially hide xml buttons
    /*
     * @TODO - refactor into underscore templates?
     */
    hideXmlButtons();

    $('.ead_files').change(function () {

        //set record object
        record.eadFile = this.value;
        record.entityName = $(this).children("option:selected").text();
        record.savedXml = "";
        record.wikiConversion = "";
        record.eacId = $(this).children("option:selected").data().id;

        //set the page header with name of person/file
        $('#record_entityName_header').text(record.entityName);

        //build the ace editor
        build_editor(record.eacId);

        //but hide it initially
        hideAceEditor();

    });

    toggleReadOnly();



});

function build_editor(eacId) {

    //enable module buttons
    enableAllModuleButtons();

    // When one of the files is selected...
    $.get('ajax/get_record.php?eac_id=' + eacId, function (data) {

        // Set up Ace editor
        editor.getSession().setValue(data.eac_xml);
        editor.resize();
        editor.focus();
        //set editor to ready only
        editor.setReadOnly(true);

        // Stick the XML in Ace editor
        var edited_xml = editor.getSession().setUseWrapMode(true); // Set text wrap --timathom
        edited_xml = editor.getValue();
        record.eacXml = edited_xml;

        // then validate the XML
        validateXML(undefined, record.eacXml);
    });


}




$('#save_eac').click(function (data) {
    // This saves the XML by getting the the text from Ace editor

    // Set "saved" status
    if (record.savedXml !== true) {
        record.savedXml = true;
    }
    record.eacXml = editor.getSession().getValue();

    // POST XML to update_eac_xml
    $.post('ajax/update_eac_xml.php', {xml: record.eacXml, ead_file: record.eadFile}, function (data) {


    }).done(function () {
        //$savedialog.dialog('open');

        //clear flash message
        $('#flash_message').html();

        //display success message
        $('#flash_message').text('XML Successfully Saved.');

        //hide aceEditor
        hideAceEditor();

        //hide xmlButtons
        hideXmlButtons();

        //disable worldcat button
        disableSingleModuleButton('ingest_worldcat');

        //add class to worldcat that indicates step complete

    });

});

$('#download_submit').click(function () {
    var fetch_xml = editor.getValue();

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
    validateXML(undefined, record.eacXml);


}));


$('#convert_to_wiki').click(function () {

    startWiki();



});


function wikiCheck(eacId) {

    $.get('ajax/get_record.php', {eac_id: eacId}, function (markup) {


        $('.main-edit').show();


        if (markup.wiki_text != "") {
            // Hide this stuff if there is wiki markup

            $('#wiki_switch_button').css({"background": "gray"});

            $('.main_edit').hide();

            $('html').css("min-width", "1250px");

            //Append some controls for dealing with the wikimarkup

            if ($('#wikieditor').length == 0) {
                $('#main_content').append("<div id=\"wikieditor\" class=\"wiki_edit\"><div class=\"wiki_container wiki_edit\"><h1 id=\"local_wiki\">Local article (transformed from EAC-CPF record) <a style=\"font-size:small; float:right; margin-top:3px;\" target=\"_blank\" href=\"https://en.wikipedia.org/wiki/Help:Wiki_markup\">Help with wiki markup</a></h1> \
<textarea id=\"wikimarkup\" class=\"wiki_edit\">" + markup.wiki_text + "</textarea></div></div>");
            } else {
                $('#wikieditor').append("<div class=\"wiki_container wiki_edit\"><h1 id=\"local_wiki\">Local article (transformed from EAC-CPF record) <a style=\"font-size:small; float:right; margin-top:3px;\" target=\"_blank\" href=\"https://en.wikipedia.org/wiki/Help:Wiki_markup\">Help with wiki markup</a></h1> \
<textarea id=\"wikimarkup\">" + markup.wiki_text + "</textarea></div>");
            }

            $('#module_controls').append("<button class=\"update_button pure-button pure-button-primary wiki_edit\" id=\"wiki_update\">Save Local Article</button><button id=\"get_wiki\" class=\"pure-button pure-button-primary wiki_edit\">Check Wikipedia for Existing Article</button>");

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

                $.post('ajax/update_wiki.php', {media_wiki: updated_markup, ead_path: eadFile}, function (data) {

                    $savewikidialog.dialog('open');

                });
            });
        }
    });
}


function eacToMediaWiki() {

    var edited_xml = editor.getValue();

    $.post('ajax/eac_mediawiki.php', {eac_text: edited_xml}, function (data) {
        $('#wiki_load').remove();
        $('#main_content').append('<div id="wikieditor" class="wiki_edit"><div class="wiki_container"><h1>Local article (transformed from EAC-CPF record)</h1> \
<textarea id="wikimarkup">' + data + '</textarea></div></div>');
        $('#module_controls').append("<button class=\"save_button pure-button pure-button-primary wiki_edit\"  id=\"wiki_save\">Save Local Article</button>");


        var wiki_height = $(window).height() / 1.3;

        $(window).resize(function () {

            var wiki_height = $(window).height() / 1.3;

        });


        // Save the wikimarkup
        function saveWiki(eadFile) {
            var wiki_markup_data = $('#wikimarkup').val();

            $('.wiki_edit').remove();

            $('#xml_switch_button').css({"background": "#0078e7"});


            $.post('ajax/post_wiki.php', {media_wiki: wiki_markup_data, ead_path: eadFile}, function (data) {

                // Hide this stuff if there is wiki markup

                $('.wiki_edit').hide();

                setupGetWiki();

                $('#wiki_switch').show();
                //$('#wiki_switch_button').unbind();

                wikiCheck(record.eacId);

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
                    $.post('update_wiki.php', {media_wiki: updated_markup, ead_path: eadFile}, function (data) {


                    });


                });

            });

        }


        $('#wiki_save').on('click', function () {
            saveWiki(record.eadFile);
        });


        $('#wiki_switch_button').click(function () {

            // Set status for showing wiki screen on dialog close.

            if (record.onWiki !== true) {
                record.onWiki = true;
            }

            $('.wiki_edit').remove();

            wikiCheck(record.eacId);

        });


        $('#xml_switch_button').click(function () {
            // Unset "onWiki" status. --timathom
            if (record.onWiki == true) {
                record.onWiki = false;
            }
            editXML(record.eadFile);
        });
    });
}
function editXML(eadFile) {
    //Show the XML editor ui and wiki markup editor


    $('#wiki_switch_button').css({"background": "#0078e7"});
    $('#xml_switch_button').css({"background": "gray"});
    $('.wiki_edit').remove();
    $('.main_edit').show();

    $('#wiki_update').on('click', function () {

        $('#dialog_box').html("<p>File saved</p>");
        makeDialog('#dialog_box', ' ');
        updated_markup = document.getElementById('wikimarkup').value;
        $.post('ajax/update_wiki.php', {media_wiki: updated_markup, ead_path: eadFile}, function (data) {
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
            "OK": function () {
                $(this).dialog("close");
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

        buttons: {
            "OK": function () {
                callback(this);
                if (record.onWiki === true) {
                    //$('#entity_name').hide();
                    $('.wiki_edit').hide();
                    $('#get_wiki').hide();
                    $('#wiki_switch').hide();
                    $('#post_wiki').hide();
                }
                else {
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
};


/* added by cbrownroberts 02-2016 */

function hideReadOnlyBtn() {
    $('#readonly_toggle_btn').hide();
}

function showReadOnlyBtn() {
    $('#readonly_toggle_btn').show();
}

function toggleReadOnly() {
    $('#editor_readonly_button').on('click', function () {

        if ($('#editor_readonly_button').data('readonly') === 'on') {

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

function startWiki() {
    // Show all the Wiki buttons for right now

    $('#wiki_login').show();
    $('#wiki_update').show();
    $('#get_wiki').show();
    $('#post_wiki').show();

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
}

function getIngestStatus(record_id) {

    var eac_id = record_id;
    var url = 'ajax/get_ingest_status.php';

    $.ajax({
        url: url,
        data: {eac_id : eac_id},
        success: function(response){
            console.log(response);
            return response;
        },
        dataType: "json"
    });
}

function showLoadingImage() {
    $('#loading_image').text('Loading...').show();
}

function hideLoadingImage() {
    $('#loading_image').hide();
}


function clearFlashMessage() {
    $('#flash_message').html();
}

function showAceEditor() {
    $('#aceEditor').show();
    $('.main_edit').show();
}

function hideAceEditor() {
    $('#aceEditor').hide();
    $('.main_edit').hide();
}

function showModuleControls() {
    $('#module_controls').hide();}

function hideModuleControls() {
    $('#module_controls').hide();
}

function enableAllModuleButtons() {
    var module_buttons = $('#ingest_buttons > button');
    $.each(module_buttons, function() {
        $(this).removeAttr('disabled');
    });
}

function disableAllModuleButtons() {
    var module_buttons = $('#ingest_buttons > button');
    $.each(module_buttons, function() {
        $(this).attr('disabled', 'disabled').css('background-color', 'f7f7f7');
    });
}

function enableSingleModuleButton(button_id) {
    $('#' + button_id).removeAttr('disabled');
}

function disableSingleModuleButton(button_id) {
    $('#' + button_id).attr('disabled', 'disabled');
}





function showXmlButtons() {
    $('#xml_buttons_container').show();
}

function hideXmlButtons() {
    $('#xml_buttons_container').hide();
}

function scrollToFormTop() {
    //scroll to top to view form correctly
    $('html,body').animate({
        scrollTop: 0
    }, 0);
}