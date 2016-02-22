//global variables
var mstrTitle = '';
var mboolIsNew = false;

jQuery(document).ready(function ($) {
    //register click event to login to wiki
    $("#wiki_login").on("click", setupWikiLogin);
    //register click event to logout to wiki
    $("#wiki_logout").on("click", setupWikiLogout);
});

function confirmWikiSubmit(callback) {
    //display login form
    makePromptDialog('#dialog-form-confirm', 'Confirm', function (dialog) {
        $(dialog).dialog("close");
        $(dialog).remove();
    });
}

/*
 * setupWikiLogin displays a form for the editor to login to wikipedia
 * @method setupWikiLogin
 */
function setupWikiLogin(callback) {

    //display login form
    makePromptDialog('#dialog-form-login', 'Please log in to Wikipedia.', function (dialog) {
        var lstrUserName = $('input[name="username"]').val();
        var lstrPassword = $('input[name="password"]').val();

        $(dialog).dialog("close");
        $(dialog).remove();


        //post to ajax wiki controller to log into wiki and get whether successful or not
        $.post('ajax/wiki_api.php', {
            'action': 'login',
            'username': lstrUserName,
            'password': lstrPassword
        }, function (response) {
            if (response.toLowerCase().indexOf("success") != -1) {
                user.rampWikiLi = true;

                $('#wiki_login').replaceWith("<li id=\"wiki_logout\" class=\"wiki_login menu_slice\"><a href=\"#\">| Wiki Logout |</a></li>");
                $("#wiki_logout").on("click", setupWikiLogout);
            }

            $('body').append("<div id=\"dialog\"><p>" + response + "</p></div>");
            makeDialog('#dialog', '', callback);


            return;
        });
    });
}

/*
 * setupWikiLogout logouts of wiki and deletes cookie that states user is logged in
 * @method setupWikiLogout
 */
function setupWikiLogout() {
    //post to ajax wiki controller to log out of wiki and get whether successful or not
    $.post('ajax/wiki_api.php', {'action': 'logout'}, function (response) {
        $('#wiki_logout').replaceWith("<li id=\"wiki_login\" class=\"wiki_login menu_slice\"><a href=\"#\">| Wiki Login |</a></li>");
        $("#wiki_login").on("click", setupWikiLogin);

        $('body').append("<div id=\"dialog\"><p>" + response + "</p></div>");
        makeDialog('#dialog');
    });
}

/*
 * setupGetWiki setup click event to search wiki
 * @method setupGetWiki
 */
function setupGetWiki() {
    jQuery('#get_wiki').on('click', function () {
        viewSwitch.hideAceEditor();
        $('.wiki_edit').hide();
        
        $('#get_wiki').hide();

        record.eacXml = editor.getValue();

        //xml must exist to continue
        if (record.eacXml == '') {

            //alert("Cannot read XML!");
            $('body').append("<div id=\"dialog\"><p>Cannot read XML!</p></div>");
            makeDialog('#dialog', 'Error!');

            $('#get_wiki').show();

            $('.wiki_edit').show();
            return;
        }

        //xml must be valid to continue
        validateXML(function (lboolValid) {

            if (lboolValid) {
                var lobjeac = new eac();
                lobjeac.loadXMLString(record.eacXml);

                var lobjNameEntryPart;
                var lobjNameEntryPartFore;
                var lobjNameEntryPartSur;
                if (lobjeac.getElement('//*[local-name()=\'control\']/*[local-name()=\'otherRecordId\'][@localType=\'WCI:DBpedia\']')) {
                    lobjNameEntryPart = lobjeac.getElement('//*[local-name()=\'control\']/*[local-name()=\'otherRecordId\'][@localType=\'WCI:DBpedia\']');
                    //= lobjeac.getElement('//*[local-name()=\'cpfDescription\']/*[local-name()=\'identity\']/*[local-name()=\'nameEntry\']/*[local-name()=\'part\']');
                    eac_name = lobjNameEntryPart.childNodes[0].nodeValue;
                    eac_name = eac_name.trim();
                    eac_name = encode_utf8(eac_name);
                    eac_name = eac_name.substring(28);

                }
                else if (lobjeac.getElement('//*[local-name()=\'cpfDescription\']/*[local-name()=\'identity\']/*[local-name()=\'nameEntry\']/*[local-name()=\'part\'][not(@localType)]')) {
                    lobjNameEntryPart = lobjeac.getElement('//*[local-name()=\'cpfDescription\']/*[local-name()=\'identity\']/*[local-name()=\'nameEntry\']/*[local-name()=\'part\']');
                    //= lobjeac.getElement('//*[local-name()=\'cpfDescription\']/*[local-name()=\'identity\']/*[local-name()=\'nameEntry\']/*[local-name()=\'part\']');
                    eac_name = lobjNameEntryPart.childNodes[0].nodeValue;
                    eac_name = eac_name.trim();
                    eac_name = encode_utf8(eac_name);
                }
                else if (lobjeac.getElement('//*[local-name()=\'cpfDescription\']/*[local-name()=\'identity\']/*[local-name()=\'nameEntry\']/*[local-name()=\'part\'][@localType=\'surname\' or @localType=\'forename\']')) {
                    lobjNameEntryPartFore = lobjeac.getElement('//*[local-name()=\'cpfDescription\']/*[local-name()=\'identity\']/*[local-name()=\'nameEntry\']/*[local-name()=\'part\'][@localType=\'forename\']');
                    eac_name = lobjNameEntryPartFore.childNodes[0].nodeValue;
                    eac_name += ' ';
                    lobjNameEntryPartSur = lobjeac.getElement('//*[local-name()=\'cpfDescription\']/*[local-name()=\'identity\']/*[local-name()=\'nameEntry\']/*[local-name()=\'part\'][@localType=\'surname\']');
                    eac_name += lobjNameEntryPartSur.childNodes[0].nodeValue;
                    eac_name = eac_name.trim();
                    eac_name = encode_utf8(eac_name);
                }
                searchWiki(eac_name);
            } else {
                $('body').append("<div id=\"dialog\"><p>XML must be valid!</p></div>");
                makeDialog('#dialog', 'Error!');

                //alert("XML must be valid!");
                $('#get_wiki').show();
                
                $('.wiki_edit').show();
                $('#entity_name').show();

            }
        }, record.eacXml);
    });
}

/*
 * searchWiki search wikipedia with passed search string and display results
 * @method searchWiki
 */
function searchWiki(lstrSearch) {
    viewSwitch.hideAceEditor();
    $('.wiki_edit').hide();
    
    $('#get_wiki').hide();
    //$('#entity_name').hide();


    //propt user to enter search string for wiki search
    makePromptDialog('#dialog-form-search', 'Search Wikipedia', function (dialog) {
        var lstrUserSearch = $('input[name="search"]').val();

        if (lstrUserSearch == '') {
            $('.validate-prompt').show();
        }
        else {
            $('#get_wiki').hide();

            lstrUserSearch = encode_utf8(lstrUserSearch);

            $(dialog).dialog("close");
            $(dialog).remove();

            //post to ajax wiki controller to search wiki and get results
            $.post('ajax/wiki_api.php', {'action': 'search', 'title': lstrUserSearch}, function (response) {
                try {
                    var lobjData = JSON.parse(response);
                }
                catch (e) {
                    $('body').append("<div id=\"dialog\"><p>" + response + "</p></div>");
                    makeDialog('#dialog');

                    //alert(response);
                    $('#get_wiki').show();

                    return;
                }

                //display wiki results in form for editor to chose
                displayWikiSearch(lobjData, function (lstrChosenTitle, lstrOrigWiki) {
                    //get wiki markup of chosen results
                    getWiki(lstrChosenTitle, lstrOrigWiki);

                });
            });
        }
    });
}

/*
 * displayWikiSearch display wiki search results for editor to chose
 * @method displayWikiSearch
 */
function displayWikiSearch(lobjTitles, callback) {

    viewSwitch.hideAceEditor();
    $('.wiki_edit').hide();

    _.templateSettings.variable = "lobjTitles";

    var template = _.template(
        $("#wikipedia-template-step-one").html()
    );

    $("#form_viewport").append(
        template(lobjTitles)
    );


    jQuery('html,body').animate({scrollTop: 0}, 0); //scroll to top to view form correctly

    //register click event to continue process once user choses result
    $('#get_chosen_wiki').on('click', function () {

        if (typeof $('input[name="chosen_title"]:checked').val() == 'undefined') {
            $('body').append("<div id=\"dialog\"><p>Must choose one!</p></div>");
            makeDialog('#dialog', 'Error!');

            //alert('Must choose one!');
            return;
        }

        var lstrWikiLink = $('input[name="chosen_title"]:checked').siblings('dl').children('dd').children('a').attr('href');

        callback($('input[name="chosen_title"]:checked').val(), lstrWikiLink);


        // Hide. --timathom
        $('.form_container').remove();
        viewSwitch.hideAceEditor();
        //$('#entity_name').hide();
        $('.wiki_edit').hide();
        
        $('#get_wiki').hide();
        $('#post_wiki').hide();

    });

    //register click event to cancel process
    $('#get_chosen_wiki_no_match').on('click', function () {

        callback('!new_wiki_page!');

        $('.form_container').remove();
        $('.wiki_edit').show();

    });

    //register click event to cancel process
    $('#get_chosen_wiki_cancel').on('click', function () {

        //callback('');

        $('.form_container').remove();
        $('#entity_name').show();
        $('.wiki_edit').show();


    });
}

/*
 * getWiki display get wikimarkup from wiki api with passed title
 * @method getWiki
 */
function getWiki(lstrTitle, lstrLink) {

    //initialize title so every time new user gets wiki page, new title is saved
    mstrTitle = '';

    //if editor does not see any desired wiki results, append blank textarea and status is new wiki page
    if (lstrTitle == '!new_wiki_page!') {

        mboolIsNew = true;

        $('#wikieditor').append("<div class=\"wiki_container wikipedia-step-one-view\"><h1 id=\"wiki_article\">Wikipedia article (to be submitted to Wikipedia)</h1><textarea id=\"get_wiki_text\"></textarea></div>");
        $('#get_wiki_text').height($('#wikimarkup').height());

        $('#get_wiki').replaceWith('<button id="post_draft_wiki" class=\"pure-button pure-button-primary wikipedia-step-one-view wiki_edit\">Submit to Wikipedia as Draft</button>');
        $('#post_draft_wiki').after('<button id="post_wiki" class=\"pure-button pure-button-primary wikipedia-step-one-view wiki_edit\">Submit to Wikipedia</button>');

        setupPostWiki();
    } else {

        mstrTitle = lstrTitle;

        //post to ajax wiki controller to get wiki markup with posted title
        $.post('ajax/wiki_api.php', {'action': 'get', 'title': lstrTitle}, function (response) {

            // Show. --timathom
            $('#entity_name').show();
            $('.wiki_edit').show();
            $('#get_wiki').show();

            $('#post_wiki').show();

            $('#wikieditor').prepend("<br/><h1>Copy and paste text from the Local article to the Wikipedia article before saving and submitting to Wikipedia.</h1><br/>");
            $('#wikieditor').append("<div class=\"wiki_container\"><h1 id=\"wiki_article\">Wikipedia article (to be submitted to Wikipedia)<a style=\"font-size:small; float:right; margin-top:3px;\" target=\"_blank\" href=\"https://en.wikipedia.org/wiki/" + encodeURI(lstrTitle) + "\">View existing Wikipedia page</a></h1><textarea id=\"get_wiki_text\">" + response + "</textarea></div>");
            $('#get_wiki_text').height($('#wikimarkup').height());

            $('#get_wiki').replaceWith('<button id=\"post_draft_wiki\" class=\"pure-button pure-button-primary wiki_edit\">Submit to Wikipedia as Draft</button>');
            $('#post_draft_wiki').after('<button id=\"post_wiki\" class=\"pure-button pure-button-primary wiki_edit\">Submit to Wikipedia</button>');
            /*
             $('#post_draft_wiki').on('click',function()
             {

             $postdialog.dialog('open');
             $(this).unbind();


             });
             */

            setupPostWiki();

        });
    }
}

/*
 * setupPostWiki register click event to post edit to wiki
 * @method setupPostWiki
 */

function setupPostWiki() {
    $('#post_wiki, #post_draft_wiki').on('click', function () {
        //stored which wiki post button was clicked
        lobjClicked = this;

        // Added confirmation for Wiki submits. --timathom

        if (this.id == 'post_draft_wiki') {
            lstrConfirm = 'Clicking this button will create a draft subpage of your Wikipedia user account (recommended for work-in-progress). Do you want to proceed?';
        }
        else {
            lstrConfirm = 'Clicking this button will publish your article to a public Wikipedia page, for the world to see. Are you sure you want to proceed?';
        }

        var $postdialog = $('<div></div>')
            .html(lstrConfirm)
            .dialog({
                autoOpen: false,
                title: function () {
                    $(this).text('Confirm');
                },
                buttons: {
                    "Yes": function () {
                        setupWikiLogin(function () {
                            $(lobjClicked).click();
                        });
                        $(this).dialog("close");
                    },
                    "No": function () {
                        $(this).dialog("close");
                    }
                }
            });

        //if user is not logged in, notify user and cancel posting process
        if (user.rampWikiLi === false) {

            //if not logged in, show log in screen and then try to post again
            $postdialog.dialog('open');


        } else {
            if (mstrTitle == '') {

                //get wiki page title from editor if new wiki page
                makePromptDialog('#dialog-form-title', 'Wiki Title', function (dialog) {
                    var lstrTitle = $('input[name="title"]').val();

                    if (lstrTitle == '') {
                        $('.validate-prompt').show();
                    }
                    else {
                        $(dialog).dialog("close");
                        $(dialog).remove();

                        mstrTitle = lstrTitle;

                        if ($(lobjClicked).attr("id") == "post_draft_wiki")
                            getUserComments(true);
                        else
                            getUserComments();
                    }
                });

                //mstrTitle = prompt("Please enter title of new Wiki page:");
            } else {
                if ($(lobjClicked).attr("id") == "post_draft_wiki")
                    getUserComments(true);
                else
                    getUserComments();
            }
        }
    });
}

/*
 * getUserComments prompt user for comments for editing wiki page
 * @method getUserComments
 */
function getUserComments(lboolDraft) {
    lboolDraft = typeof lboolDraft == 'undefined' ? false : lboolDraft;


    makePromptDialog('#dialog-form-comment', 'Please summarize your edits. A reference to the RAMP editor has been added for you.', function (dialog) {
        var lstrComments = $('input[name="comments"]').val();

        if (lstrComments == '') {
            $('.validate-prompt').show();
        }
        else {
            $(dialog).dialog("close");
            $(dialog).remove();

            var lstrWiki = $('#get_wiki_text').val();
            postWiki(lstrWiki, lstrComments, lboolDraft);
        }
    });
}

/*
 * postWiki post to wiki api to edit wiki page with wiki markup.
 * @method postWiki
 */
function postWiki(lstrWiki, lstrComments, lboolDraft, lstrCaptchaAnswer, lstrCaptchaId) {
    $('.wiki_edit').hide();
    
    $('#get_wiki').hide();
    $('#post_wiki').hide();
    $('#draft_container').hide();

    //if captcha not necessary, do not post captcha
    if (typeof lstrCaptchaId == 'undefined') {
        //post to ajax wiki controller to edit posted wiki page title with posted wiki markup
        $.post('ajax/wiki_api.php', {
                'action': 'post', 'title': mstrTitle, 'isNew': mboolIsNew, 'wiki': lstrWiki, 'comments': lstrComments,
                'isDraft': lboolDraft
            },
            function (response) {
                try {
                    var lobjData = JSON.parse(response);
                    $('#module_controls').show();
                    $('.wiki_edit').show();
                    $('#get_wiki').show();
                    $('#post_wiki').show();
                    $('#draft_container').show();
                }
                catch (e) //in this case, if response is JSON, Captcha is needed to complete edit request
                {
                    $('body').append("<div id=\"dialog\"><p>" + response + "</p></div>");
                    makeDialog('#dialog');

                    $('#entity_name').show();
                    $('.wiki_edit').show();
                    $('#get_wiki').show();
                    $('#post_wiki').show();
                    return;
                }

                //displays captcha question
                displayCaptcha("http://en.wikipedia.org/" + lobjData.url, lobjData.id, lboolDraft);
            });
    } else {
        //post to ajax wiki controller to edit posted wiki page title with posted wiki markup and captcha answer
        $.post('ajax/wiki_api.php', {
                'action': 'post', 'title': mstrTitle, 'isNew': mboolIsNew,
                'wiki': lstrWiki, 'comments': lstrComments, 'isDraft': lboolDraft,
                'captcha_ans': lstrCaptchaAnswer, 'captcha_id': lstrCaptchaId
            },
            function (response) {
                try {
                    var lobjData = JSON.parse(response);
                    $('#module_controls').show();
                    $('.wiki_edit').show();

                    $('#get_wiki').show();
                    $('#post_wiki').show();
                    $('#draft_container').show();
                }
                catch (e) //in this case, if response is JSON, Captcha is needed to complete edit request
                {
                    $('body').append("<div id=\"dialog\"><p>" + response + "</p></div>");
                    makeDialog('#dialog');

                    $('#entity_name').show();
                    $('.wiki_edit').show();
                    $('#get_wiki').show();
                    $('#post_wiki').show();
                    return;
                }

                //displays captcha question
                displayCaptcha("http://en.wikipedia.org/" + lobjData.url, lobjData.id, lboolDraft);
            });
    }
}

/*
 * displayCaptcha display form with captcha image in order for editor to answer captcha question to complete edit wiki action
 * @method displayCaptcha
 */
function displayCaptcha(lstrUrl, lstrCaptchaId, lboolDraft) {
    _.templateSettings.variable = "lstrUrl";

    var template = _.template(
        $("#wikipedia-template-captcha").html()
    );

    $("#form_viewport").append(
        template(lstrUrl)
    );

    jQuery('html,body').animate({scrollTop: 0}, 0); //scroll to top to display form correctly

    //register click event to continue process once user answers captcha question
    $('#try_with_captcha').on('click', function () {
        var lstrWiki = $('#get_wiki_text').val();
        var lstrCaptchaAnswer = $('input[name="captcha_ans"]').val();

        postWiki(lstrWiki, 'Retry with Captcha', lboolDraft, lstrCaptchaAnswer, lstrCaptchaId);

        $('.form_container').remove();

    });
}

/*
 * getSelection based on passed id, gets currently selected text
 * @method getSelection
 */
function getSelection(lstrid) {
    var textComponent = document.getElementById(lstrid);
    var selectedText;
    // IE version
    if (document.selection != undefined) {
        textComponent.focus();
        var sel = document.selection.createRange();
        selectedText = sel.text;
    }
    // Mozilla version
    else if (textComponent.selectionStart != undefined) {
        var startPos = textComponent.selectionStart;
        var endPos = textComponent.selectionEnd;
        selectedText = textComponent.value.substring(startPos, endPos)
    }
    return selectedText;
}
