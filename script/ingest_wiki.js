$('#convert_to_wiki').click(function () {

    //diable module buttons
    disableAllModuleButtons();

    //clear any flash messages
    clearFlashMessage();

    startWiki();

});



function startWiki() {
    viewSwitch.showWikiStepOne();

    renderHelpTemplate('wiki_template_help_step_one');

    // Set status for showing wiki screen on dialog close.
    if (record.onWiki !== true) {
        record.onWiki = true;
    }


    var fullName = normalizeEntityName(record.entityName);
    console.log(fullName);

    autoSearchWikipedia(fullName);
}

function showWikiLoginButton() {
    $('#wiki_login').show();
}

function hideWikiLoginButton() {
    $('#wiki_login').hide();
}

function normalizeEntityName(name) {
    var nameSplit = name.split(',');
    var fullName = nameSplit[1] + ' ' + nameSplit[0];
    return fullName;
}


function wikiCheck(eacId) {


    $.get('ajax/get_record.php', {eac_id: eacId}, function (markup) {


        if (markup.wiki_text != "") {
            // Hide this stuff if there is wiki markup
            $('#wiki_switch_button').css({"background": "gray"});

            viewSwitch.hideAceEditor();

            //Append some controls for dealing with the wikimarkup

            if ($('#wikieditor').length == 0) {
                $('#main_content').append("<div id=\"wikieditor\" class=\"wiki_edit\"><div class=\"wiki_container wiki_edit\"><h2 id=\"local_wiki\">Local article (transformed from EAC-CPF record) <a target=\"_blank\" href=\"https://en.wikipedia.org/wiki/Help:Wiki_markup\">Help with wiki markup</a></h2> \
<textarea id=\"wikimarkup\" class=\"wiki_edit\">" + markup.wiki_text + "</textarea></div></div>");
            } else {
                $('#wikieditor').append("<div class=\"wiki_container wiki_edit\"><h2 id=\"local_wiki\">Local article (transformed from EAC-CPF record) <a target=\"_blank\" href=\"https://en.wikipedia.org/wiki/Help:Wiki_markup\">Help with wiki markup</a></h2> \
<textarea id=\"wikimarkup\">" + markup.wiki_text + "</textarea></div>");
            }

            $('#module_controls').append("<button class=\"update_button pure-button ramp-button wiki_edit\" id=\"wiki_update\">Save Local Article</button><button id=\"get_wiki\" class=\"pure-button pure-button-primary wiki_edit\">Check Wikipedia for Existing Article</button>");

            setupGetWiki();

            $(window).resize(function () {

            });


            $('#edit_xml').on('click', function () {

                //Show the XML editor ui and wiki markup editor
                viewSwitch.showAceEditor();
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

        hideLoadingImage();

        $('#main_content').append('<div id="wikieditor" class="wiki_edit"><div class="wiki_container"><h1>Local article (transformed from EAC-CPF record)</h1> \
<textarea id="wikimarkup">' + data + '</textarea></div></div>');
        $('#module_controls').append("<button class=\"save_button pure-button pure-button-primary wiki_edit\"  id=\"wiki_save\">Save Local Article</button>");


        $('#wiki_login').show();

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

                //$('#wiki_switch_button').unbind();

                wikiCheck(record.eacId);

                var wiki_height = $(window).height() / 1.3;

                $(window).resize(function () {

                });


                $('#edit_xml').on('click', function () {
                    //Show the XML editor ui and wiki markup editor
                    viewSwitch.showAceEditor();
                    $('.wiki_edit').remove();

                });

                $('#wiki_update').on('click', function () {

                    renderFlashMessage('<p>Local article saved</p>');

                    var updated_markup = $('#wikimarkup').val();

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
    viewSwitch.showAceEditor();

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

function get(url) {
    // Return a new promise.
    return new Promise(function(resolve, reject) {
        // Do the usual XHR stuff
        var req = new XMLHttpRequest();
        req.open('GET', url);

        req.onload = function() {
            // This is called even on 404 etc
            // so check the status
            if (req.status == 200) {
                // Resolve the promise with the response text
                resolve(req.response);
            }
            else {
                // Otherwise reject with the status text
                // which will hopefully be a meaningful error
                reject(Error(req.statusText));
            }
        };

        // Handle network errors
        req.onerror = function() {
            reject(Error("Network Error"));
        };

        // Make the request
        req.send();
    });
}


function getJSON(url) {
    return get(url).then(JSON.parse);
}




function getLocalWikiMarkup(eacId) {

    showLoadingImage();

    getJSON('ajax/get_record.php?eac_id=' + eacId).then(function(response) {
        //console.log("Success!", response);

        addMarkupToLocalEditor(response.wiki_text);

    }).catch(function(err) {
        // Catch any error that happened along the way
        renderFlashMessage('<p>Local wiki markup does not exist.</p>');

    }).then(function() {
        // hide the spinner
        hideLoadingImage();
    });

}



function autoSearchWikipedia(entityName) {

    lstrUserSearch = encode_utf8(entityName);

    showLoadingImage();

    //post to ajax wiki controller to search wiki and get results
    $.post('ajax/wiki_api.php', {'action': 'search', 'title': lstrUserSearch}, function (response) {
        try {
            lobjData = JSON.parse(response);
        }
        catch (e) {
            renderFlashMessage('<p>' + e.message + '</p>');
            return;
        }

        hideLoadingImage();
        //display wiki results in form for editor to chose
        displayWikiSearch(lobjData, function (lstrChosenTitle, lstrOrigWiki) {
            //get wiki markup of chosen result
            getWiki(lstrChosenTitle, lstrOrigWiki);
        });
    });

}

