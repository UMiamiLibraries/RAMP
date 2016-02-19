$(document).ready(function () {

    //register click event that will start worlcat ingestion
    $('#ingest_worldcat').on('click', function () {

        //diable module buttons
        disableAllModuleButtons();

        //clear any flash messages
        clearFlashMessage();

        startWorldCat();
    });

    $('#cancel-worldcat').on('click', function() {
       cancelWorldCat();
    });

});


function startWorldCat() {

    viewSwitch.showWorldCatStepOne();

    record.wikiConversion = false; // Unset "onWiki" status.
    record.eacXml = editor.getValue();
    console.log(record.eadFile);

    //cannot start ingestion without XML being loaded
    if (record.eacXml == '') {
        $('#flash_message').append("<p>Must load EAC first!</p>");
        return;
    }

    validateXML(function (lboolValid) {

        //xml must be valid in order for worlcat ingestion to begin
        if (lboolValid) {

            //show the loading image
            showLoadingImage();

            var lobjeac = new eac();
            lobjeac.loadXMLString(record.eacXml);

            //get first name entry part element in order to get name to search WorldCat
            var lobjNameEntryPart;
            var lobjNameEntryPartFore;
            var lobjNameEntryPartSur;

            if (lobjeac.getElement('//*[local-name()=\'cpfDescription\']/*[local-name()=\'identity\']/*[local-name()=\'nameEntry\'][1]/*[local-name()=\'part\'][not(@localType)]')) {
                lobjNameEntryPart = lobjeac.getElement('//*[local-name()=\'cpfDescription\']/*[local-name()=\'identity\']/*[local-name()=\'nameEntry\'][1]/*[local-name()=\'part\']');
                eac_name = lobjNameEntryPart.childNodes[0].nodeValue;
                eac_name = eac_name.trim();
                eac_name = encode_utf8(eac_name);
            }
            else if (lobjeac.getElement('//*[local-name()=\'cpfDescription\']/*[local-name()=\'identity\']/*[local-name()=\'nameEntry\'][1]/*[local-name()=\'part\'][@localType=\'surname\' or @localType=\'forename\']')) {
                lobjNameEntryPartFore = lobjeac.getElement('//*[local-name()=\'cpfDescription\']/*[local-name()=\'identity\']/*[local-name()=\'nameEntry\'][1]/*[local-name()=\'part\'][@localType=\'forename\']');
                eac_name = lobjNameEntryPartFore.childNodes[0].nodeValue;
                eac_name += ' ';
                lobjNameEntryPartSur = lobjeac.getElement('//*[local-name()=\'cpfDescription\']/*[local-name()=\'identity\']/*[local-name()=\'nameEntry\'][1]/*[local-name()=\'part\'][@localType=\'surname\']');
                eac_name += lobjNameEntryPartSur.childNodes[0].nodeValue;
                eac_name = eac_name.trim();
                eac_name = encode_utf8(eac_name);
            }


            ingest_worldcat_elements(lobjeac, eac_name, function (lstrMessage) {
                if (typeof lstrMessage != 'undefined' && lstrMessage != '') {
                    //display response
                    renderFlashMessage('<p>' + lstrMessage + '</p>');
                }

                $('.main_edit').show();
            });

        } else {
            //display error when xml is not valid
            $('body').append("<div id=\"dialog\"><p>XML must be valid!</p></div>");
            makeDialog('#dialog', 'Error!');

            $('.main_edit').show();

        }
    }, record.eacXml);

    //render contextual help template
    render_help_template('wc_template_help_step_one');

}

function cancelWorldCat() {
    record = {};
    viewSwitch.showHome();
}

/*
 * ingest_worldcat_elements ingest subject headings and relationships from worldcat using API into passed EAC DOM Document.
 * @method ingest_worldcat_elements
 */

function ingest_worldcat_elements(lobjEac, lstrName, callback) {
    console.log(lstrName);

    lstrName = encode_utf8(lstrName);

    //post to ajax WorldCat ingestor controller to search worldcat and get results
    $.post('ajax/worldcat_ingest_api.php', {
            'action': 'search', 'name': lstrName
        },
        function (response) {
            try {
                var lobjData = JSON.parse(response);
            }
            catch (e) //response should be JSON so if not, throw error
            {
                callback(response);
                return;
            }

            //display form for editor to choose which WorldCat result is the correct result
            display_possible_worldcat_form(lobjData, function (lstrChosenURI) {
                //if cancelled because no WorldCat results matched
                if (lstrChosenURI == '') {

                    //scroll to top to view form correctly
                    scrollToFormTop();

                    callback('Canceled!');
                    return;
                }


                //post to ajax WorldCat ingestor controller to search worldcat and get results
                $.post('ajax/worldcat_ingest_api.php', {
                        'action': 'get_element_list', 'uri': lstrChosenURI
                    },
                    function (response) {
                        try {
                            var lobjData = JSON.parse(response);
                        }
                        catch (e) //response should be JSON so if not, throw error
                        {
                            callback();
                            return;
                        }

                        var lobjSourceList = typeof lobjData.source == 'undefined' ?[]: lobjData.source;
                        var lobjOtherRecList = typeof lobjData.otherRecordId == 'undefined' ?[]: lobjData.otherRecordId;
                        var lobjCpfRelationList = typeof lobjData.cpfRelation == 'undefined' ?[]: lobjData.cpfRelation;
                        var lobjResourceRelationList = typeof lobjData.resourceRelation == 'undefined' ?[]: lobjData.resourceRelation;
                        var lobjSubjectList = typeof lobjData.subject == 'undefined' ?[]: lobjData.subject;

                        for (var i = 0; i < lobjOtherRecList.length; i++) {
                            var OtherRecs = lobjOtherRecList[i];
                            lobjEac.addOtherRecordId(OtherRecs);
                            editor.getSession().setValue(lobjEac.getXML());
                            // added by timathom
                        }

                        for (var i = 0; i < lobjSourceList.length; i++) {
                            var Sources = lobjSourceList[i];
                            lobjEac.addSource(Sources);
                            editor.getSession().setValue(lobjEac.getXML());
                            // added by timathom
                        }

                        for (var i = 0; i < lobjCpfRelationList.length; i++) {
                            var CpfRelation = lobjCpfRelationList[i];
                            lobjEac.addCPFRelation(CpfRelation);
                            editor.getSession().setValue(lobjEac.getXML());
                            // added by timathom
                        }

                        for (i = 0; i < lobjResourceRelationList.length; i++) {
                            var ResourceRelation = lobjResourceRelationList[i];
                            lobjEac.addResourceRelation(ResourceRelation);
                            editor.getSession().setValue(lobjEac.getXML());
                            // added by timathom
                        }


                        // Notification logic added by timathom.
                        if (lobjSubjectList.length == 0) {

                           renderFlashMessage('<p>No matching subjects.</p>');

                            $('.form_container').remove();

                            editor.getSession().setValue(lobjEac.getXML());
                            return;
                        } else {

                            //display form for editor to chose which subject headings to ingest
                            display_possible_worldcat_subjects(lobjSubjectList, function (lobjChosenSubjects) {

                                for (i = 0; i < lobjChosenSubjects.length; i++) {
                                    var Subject = lobjSubjectList[lobjChosenSubjects[i]];
                                    lobjEac.addSubjectHeading(Subject);
                                    editor.getSession().setValue(lobjEac.getXML());
                                }

                                if (lobjChosenSubjects.length == 0) {

                                    renderFlashMessage('<p>No subjects added.</p>');

                                    $('.form_container').remove();

                                    editor.getSession().setValue(lobjEac.getXML());
                                    return;

                                } else {

                                    //$('#flash_message').append("<ul><li>&lt;localDescription&gt; element(s) added with chosen subject(s).</li>" + lstrOtherRecId + lstrSources + lstrCpfResults + lstrResourceResults + "</ul>");
                                    renderFlashMessage('<p>Success! XML elements added</p>');

                                    // Append a maintenanceEvent to the EAC to keep track that a WorldCat ingest happened
                                    var d = new Date;
                                    var maintEvent = {

                                        "elements": {
                                            "eventType": "updated",
                                            "eventDateTime": d.getMonth() + "-" + d.getDate() + "-" + d.getFullYear(),
                                            "agentType": "machine",
                                            "agent": "ramp/worldcat",
                                            "eventDescription": "Ingested WorldCat"
                                        }
                                    }

                                    lobjEac.addMaintenanceEvent(maintEvent);
                                    editor.getSession().setValue(lobjEac.getXML());

                                    // Enable the module buttons again
                                    enableAllModuleButtons();

                                    return;
                                }

                            });
                        }

                        //scroll to top to view form correctly
                        scrollToFormTop();
                    });
            });
        });
}



/*
 * display_possible_worldcat_form displays a form for the editor to choose which worldcat results that editor wants to ingest
 * @method display_possible_worldcat_form
 */
function display_possible_worldcat_form(lobjPossibleURI, callback) {

    _.templateSettings.variable = "lobjPossibleURI";

    var template = _.template(
        $("#worldcat-template-step-one").html()
    );

    $( "#form_viewport" ).append(
        template( lobjPossibleURI )
    );

    //scroll to top to view form correctly
    scrollToFormTop();

    //register click event to continue process once user choses result
    $('#ingest_worldcat_chosen_uri').on('click', function () {
        var lstrChosenURI = $('input[name="chosen_worldcat_uri"]:checked').val();

        if (typeof lstrChosenURI == 'undefined') {
            $('body').append("<div id=\"dialog\"><p>Please choose or click Cancel!</p></div>");
            makeDialog('#dialog', 'Error!');
        } else {
            $('.form_container').remove();
            $('.help_container').remove();

            //show loading image
            showLoadingImage();

            callback(lstrChosenURI);
        }
    });

    //register click event to cencel process
    $('#ingest_worldcat_chosen_uri_cancel').on('click', function () {
        //callback('');
        $('.form_container').remove();
        $('.help_container').remove();

        //show aceEditor
        showAceEditor();

        //scroll to top to view form correctly
        scrollToFormTop();

        $('body').append("<div id=\"dialog\"><p>Canceled!</p></div>");
        makeDialog('#dialog', 'Results');
        // display results
    });
}

/*
 * display_possible_worldcat_subjects displays a form for the editor to choose which worldcat subject headings that editor wants to ingest
 * @method display_possible_worldcat_subjects
 */
function display_possible_worldcat_subjects(lobjPossibleSubjects, callback) {


    _.templateSettings.variable = "lobjPossibleSubjects";

    var template = _.template(
        $("#worldcat-template-step-two").html()
    );

    $( "#form_viewport" ).append(
        template( lobjPossibleSubjects )
    );

    //render contextual help template
    render_help_template('wc_template_help_step_two');

    //setup to select all checkboxes
    setupSelectAll('input#select_all');

    //scroll to top to view form correctly
    scrollToFormTop();

    //register click event to continue process once user choses subjects
    $('#ingest_worldcat_chosen_subjects').on('click', function () {
        var lobjChosenSubjects =[];

        $('input[name="chosen_subjects"]').each(function () {
            if (this.checked) {
                lobjChosenSubjects.push($(this).val());
            }
        });

        // Display/notification logic added by timathom
        if (lobjChosenSubjects.length == 0) {
            $('body').append("<div id=\"dialog\"><p>Please choose or click Cancel!</p></div>");
            makeDialog('#dialog', 'Error!');

        } else {
            callback(lobjChosenSubjects);
            $('.form_container').remove();
            $('.help_container').remove();

            // display ace editor
            showAceEditor();

            //display save xml buttons
            showXmlButtons();

            //render help template
            render_help_template('wc_template_help_step_three');

        }
    });

    //register click event to cancel process
    $('#ingest_worldcat_chosen_subjects_cancel').on('click', function () {
        var lobjChosenSubjects =[];

        callback(lobjChosenSubjects);
        $('.form_container').remove();
        $('.help_container').remove();
        $('.main_edit').show();

        return;
    });
}