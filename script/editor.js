$(document).ready(function () {


    //initially disable module buttons
    disableAllModuleButtons();

    viewSwitch.hideAceEditor();


    //enable toggle switch for ace editor read only
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



/*
 * setupSelectAll registers passed element selector's change event in order to have check all visible checkboxes functionality.
 * @method setupSelectAll
 */
function setupSelectAll(lstrSelector) {
    $(lstrSelector).change(function () {
        if ($(lstrSelector).prop("checked") == true)
            $('input[type="checkbox"]:visible').prop('checked', true); else
            $('input[type="checkbox"]:visible').prop('checked', false);
    })
}


$('#save_eac').click(function (data) {
    // This saves the XML by getting the the text from Ace editor

    // Set "saved" status
    if (record.savedXml !== true) {
        record.savedXml = true;
    }
    record.eacXml = editor.getSession().getValue();


    //hide aceEditor
    viewSwitch.hideAceEditor();

    renderFlashMessage('<p>Converting XML to Wiki Markup...please be patient</p>');
    showLoadingImage();

    // POST XML to update_eac_xml
    $.post('ajax/update_eac_xml.php', {xml: record.eacXml, ead_file: record.eadFile}, function (data) {


    }).done(function () {


    });

    // POST XML to update_eac_xml
    $.post('ajax/save_xml_as_wikimarkup.php', {editor_xml: record.eacXml, ead_path: record.eadFile}, function (data) {

        console.log(data);

    }).done(function () {

        hideLoadingImage();

        //clear flash message
        clearFlashMessage();

        //display success message
        renderFlashMessage('<div class=\"success-message\"><p>XML Successfully Saved.</p></div>');


        enableAllModuleButtons();

    });

});


function convertXmlToWikiMarkup() {



}


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
                viewSwitch.hideAceEditor();
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

                    $('.wiki_edit').hide();
                    $('#get_wiki').hide();
                    $('#post_wiki').hide();
                }
                else {
                    viewSwitch.hideAceEditor();
                }
            }
        },
        close: function () {
            $(this).remove();
            if (record.onWiki === true) {
                $('.wiki_edit').show();
                $('#get_wiki').show();
                $('#post_wiki').show();
                viewSwitch.hideAceEditor();
            }
            else {
                viewSwitch.showAceEditor();
                // Check to see if there is already wiki markup. If so, show switcher. --timathom
                if (record.onWiki === true) {
                    
                }
                else {
                    
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


function scrollToFormTop() {
    //scroll to top to view form correctly
    $('html,body').animate({
        scrollTop: 0
    }, 0);
}