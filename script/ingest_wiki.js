/**
 * Created by cbrownroberts on 2/18/16.
 */
$(document).ready(function () {

    //make sure wiki controls hidden unless needed
    hideWikiLoginButton();


    $('#convert_to_wiki').click(function () {

        //diable module buttons
        disableAllModuleButtons();

        //clear any flash messages
        clearFlashMessage();

        startWiki();
    });



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

    function showWikiLoginButton() {
        $('#wiki_login').show();
    }

    function hideWikiLoginButton() {
        $('#wiki_login').hide();
    }



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




});