$(document).ready(function () {

    //register click event that will start worlcat ingestion
    $('#ingest_worldcat').on('click', function () {
        /**
         * @TODO create function to make sure form_viewport is empty
         */
        startWorldCat();
    });

    //register click event that will start viaf ingest
    $('#ingest_viaf').on('click', function () {
        startViaf();
    });


});


function startWorldCat() {

    //show the loading image
    showLoadingImage();

    record.wikiConversion = false; // Unset "onWiki" status.
    record.eacXml = editor.getValue();

    //cannot start ingestion without XML being loaded
    if (record.eacXml == '') {
        $('flash_message').append("<p>Must load EAC first!</p>");
        return;
    }

    validateXML(function (lboolValid) {

        //xml must be valid in order for worlcat ingestion to begin
        if (lboolValid) {

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
                    $('body').append("<div id=\"dialog_main\"><p>" + lstrMessage + "</p></div>");
                    makeDialog('#dialog_main', 'Response');
                    //display response
                }

                $('.ingest_button').show();
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

function startViaf() {
    $('.main_edit').hide();


    record.onWiki = false; // Unset "onWiki" status

    record.eacXml = editor.getValue();

    //cannot start ingestion without XML being loaded
    if (record.eacXml == '') {
        $('body').append("<div id=\"dialog\"><p>Must load EAC first!</p></div>");
        makeDialog('#dialog', 'Error!');
        //display error

        $('.ingest_button').show();

        $('.main_edit').show();
        return;
    }

    validateXML(function (lboolValid) {

        //xml must be valid in order for viaf ingestion to begin
        if (lboolValid) {
            var lobjeac = new eac();
            lobjeac.loadXMLString(record.eacXml);

            //get first name entry part element in order to get name to search viaf

            var lobjNameEntryPart;
            var lobjNameEntryPartFore;
            var lobjNameEntryPartSur;

            if (lobjeac.getElement('//*[local-name()=\'cpfDescription\']/*[local-name()=\'identity\']/*[local-name()=\'nameEntry\'][1]/*[local-name()=\'part\'][not(@localType)]')) {
                lobjNameEntryPart = lobjeac.getElement('//*[local-name()=\'cpfDescription\']/*[local-name()=\'identity\']/*[local-name()=\'nameEntry\'][1]/*[local-name()=\'part\']');
                //= lobjeac.getElement('//*[local-name()=\'cpfDescription\']/*[local-name()=\'identity\']/*[local-name()=\'nameEntry\'][1]/*[local-name()=\'part\']');
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

            ingest_viaf_NameEntry_Sources(lobjeac, eac_name, function () {

                ingest_viaf_Relations(lobjeac, function (lstrMessage) {
                    $('body').append("<div id=\"dialog_main\"><p>" + lstrMessage + "</p></div>");
                    makeDialog('#dialog_main', 'Response');
                    //display response


                    $('.ingest_button').show();

                });
            });
        } else {
            //display error when xml is not valid
            $('body').append("<div id=\"dialog\"><p>XML must be valid!</p></div>");
            makeDialog('#dialog', 'Error!');

            $('.main_edit').show();
            $('.ingest_button').show();

        }
    }, record.eacXml);
}


/*
 * ingest_viaf_NameEntry_Sources ingest name entries and sources from viaf using API into passed EAC DOM Document. Using passed name to search Viaf.
 * @method ingest_viaf_NameEntry_Sources
 */
function ingest_viaf_NameEntry_Sources(lobjEac, lstrName, callback) {

    lstrName = encode_utf8(lstrName);

    //post to ajax viaf ingestor controller to search viaf
    $.post('ajax/viaf_ingest_api.php', {
            'action': 'search', 'name': lstrName
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

            display_possible_viaf_form(lobjData, function (lstrChosenViaf) {

                //post to ajax viaf ingestor controller to get source and name entry nodes from viaf record of chosen result
                $.post('ajax/viaf_ingest_api.php', {
                        'action': 'source_and_name_entry', 'viaf_id': lstrChosenViaf
                    },
                    function (response) {
                        try {
                            var lobjData = JSON.parse(response);
                            //console.log(lobjData);
                        }
                        catch (e) //response should be JSON so if not, throw error
                        {

                            callback();
                            return;
                        }

                        var lobjNameEntryList = typeof lobjData.name_entry_list == 'undefined' ?[]: lobjData.name_entry_list;
                        var lobjSource = typeof lobjData.source == 'undefined' ?[]: lobjData.source;


                        if (lobjNameEntryList.length != 0 || lobjNameEntryList != '') {
                            for (var i = 0; i < lobjNameEntryList.length; i++) {
                                var NameEntry = lobjNameEntryList[i];
                                console.log(NameEntry);
                                lobjEac.addNameEntry(NameEntry);
                            }

                            lobjEac.addSource(lobjSource);

                            jQuery('html,body').animate({
                                    scrollTop: 0
                                },
                                0);
                            //scroll to top to view form correctly

                            $('body').append("<div id=\"dialog\"><p>&lt;source&gt; and &lt;nameEntry&gt; elements added!</p></div>");
                            makeDialog('#dialog', 'Results');
                            // display results
                            var d = new Date;

                            var maintEvent = {

                                "elements": {
                                    "eventType": "updated",
                                    "eventDateTime": d.getMonth() + "-" + d.getDate() + "-" + d.getFullYear(),
                                    "agentType": "machine",
                                    "agent": "ramp/viaf",
                                    "eventDescription": "Ingested VIAF"
                                }
                            }


                            lobjEac.addMaintenanceEvent(maintEvent);

                            //set ace editor value to new xml from EAC Dom Document with ingested source and name entries
                            editor.getSession().setValue(lobjEac.getXML());

                            $('.form_container').remove();
                            $('.help_container').remove();

                            // Results notification added by timathom
                            callback();
                        } else {

                        }
                    });
            });
        });
}

/*
 * display_possible_viaf_form displays a form for the editor to choose which viaf results is the correct one from the passed viaf results list
 *
 * This is the first step in the VIAF process. Pick a name that matches, or more fancily: Authority Control
 *
 * @method display_possible_viaf_form
 */
function display_possible_viaf_form(lobjPossibleViaf, callback) {


    // Render the first template

    _.templateSettings.variable = "lobjPossibleViaf";

    var template = _.template(
        $("#viaf-template-step-one").html()
    );

    $( "#form_viewport" ).append(
        template( lobjPossibleViaf )
    );

    //scroll to top to view form correctly
    
    //register click event to continue process once user chosesviaf results
    $('#ingest_viaf_chosen_viaf').on('click', function () {
        var lstrChosenViaf = $('input[name="chosen_viaf_id"]:checked').val();
        
        if (typeof lstrChosenViaf == 'undefined') {
            $('body').append("<div id=\"dialog\"><p>Please choose or click Cancel!</p></div>");
            makeDialog('#dialog', 'Error!');
            // display error
        } else {
            callback(lstrChosenViaf);
            $('.form_container').remove();
            $('.help_container').remove();
            $('.main_edit').hide();
        }
    });
    
    //register click event to cancel process
    $('#ingest_viaf_chosen_viaf_cancel').on('click', function () {
        
        jQuery('html,body').animate({
            scrollTop: 0
        },
        0);
        //scroll to top to view form correctly
        
        $('body').append("<div id=\"dialog\"><p>Skipped VIAF ingest.</p></div>");
        makeDialog('#dialog', 'Results');
        // display results
        $('.form_container').remove();
        $('.help_container').remove();
        callback();

    });
}

/*
 * ingest_viaf_Relations ingest relations from viaf using API into passed EAC DOM Document.
 *
 * This function has regex based named entity recognition. It goes through the eac record and attempts to find all the strings that look like names.
 *
 *
 * @method ingest_viaf_Relations
 */
function ingest_viaf_Relations(lobjEac, callback) {
    //need to get ead to get possible names and titles list
    $.get('ajax/get_record.php', {
        'eac_id': record.eacId
    },
    function (data) {
        var lobjead = new ead();
        lobjead.loadXMLString(data.ead_xml);
        
        var PossibleNameList =[];
        var PossibleNameListBio =[];
        var PossibleNameListUnit =[];
        var PossibleNameListIngest =[];
        
        var lobjParagraphList = lobjEac.getElementList('//*[local-name()=\'p\']');        
        var lobjUnitTitleList = lobjead.getElementList('//*[local-name()=\'unittitle\']');
        var lobjIngestList = lobjEac.getElementList('//*[local-name()=\'chronItem\']/*[local-name()=\'event\'] | //*[local-name()=\'resourceRelation\'][@resourceRelationType=\'creatorOf\']/*[local-name()=\'relationEntry\'][1] | //*[local-name()=\'resourceRelation\'][not(@resourceRelationType)]/*[local-name()=\'relationEntry\'][1] | //*[local-name()=\'resourceRelation\'][@resourceRelationType=\'subjectOf\']/*[local-name()=\'relationEntry\'][@localType=\'creator\'] | //*[local-name()=\'resourceRelation\'][@resourceRelationType=\'subjectOf\']/*[local-name()=\'relationEntry\'][1]');

        for (var i = 0; i < lobjParagraphList.length; i++) {
            if (typeof lobjParagraphList[i].childNodes[0] == 'undefined')
            continue;
            
            var lstrParagraph = lobjParagraphList[i].textContent.trim();
            
            if (lstrParagraph == null || lstrParagraph == '')
            continue;
            
            //apply regex to elements to find all possible names to search viaf for relations
            var lobjPossibleNamesBio = lstrParagraph.match(/([\(A-Z\u00C0\u00C1\u00C3\u00C7\u00C9\u00CA\u00CD\u00D3\u00DA\u00DC\u00D4\u00D5\u00D6][\.]?[a-z\u00E0\u00E1\u00E3\u00E7\u00E9\u00EA\u00ED\u00F0\u00F3\u00F4\u00F5\u00FA\u00FC\u00F1\u0026\-\'\)]*((\s?[0-9][0-9][\)]?\s?)*(\s?[0-9][0-9][\)]?\s?)*(\s?[-]\s?)*)*([,]\s?)*?(\sof\sthe|\sof|\s\u0026|\sf\u00FCr|\sdes|\set|\sde\sla|\sde\s|\sdel|\sde|\svon|\svan)?\s*([A-Z\u00C1\u00C9\u00CD\u00D3\u00DA\u00DC\u00D6]\s?[\.]\s?)*\s*(of\sthe\s|of\s|f\u00FCr\s|des\s|et\s|y\sde\sla\s|y\sdel\s|de\sla\s|del\s|de\slos\s|de\s|do\s|da\s|dos\s|das\s|e\s|y\s|von\s|van\s)?){2,9}/g);
            
            if (lobjPossibleNamesBio == null || lobjPossibleNamesBio.length == 0) {
                continue;
            } else {
                for (var j = 0; j < lobjPossibleNamesBio.length; j++) {
                    
                    var lstrPossibleNameBio = lobjPossibleNamesBio[j];
                    
                    lstrPossibleNameBio = lstrPossibleNameBio.trim();
                    
                    PossibleNameListBio.push(lstrPossibleNameBio);

                }
            }
        }
        for (var i = 0; i < lobjUnitTitleList.length; i++) {
            if (typeof lobjUnitTitleList[i].childNodes[0] == 'undefined')
            continue;
            
            var lstrUnitTitle = lobjUnitTitleList[i].childNodes[0].nodeValue;
            
            if (lstrUnitTitle == null || lstrUnitTitle == '')
            continue;
            
            var lobjPossibleNamesUnit = lstrUnitTitle.match(/([\(A-Z\u00DC\u0300\u0301\u0302\u0303\u0304\u0305\u0306\u0307\u0308\u00C0\u00C1\u00C3\u00C7\u00C9\u00CA\u00CD\u00D3\u00DA\u00DC\u00D4\u00D5\u00D6][a-z\u00FC\u0026\u0300\u0301\u0303\u0308\u030B\u030E\u00E0\u00E1\u00E3\u00E7\u00E9\u00EA\u00ED\u00F0\u00F3\u00F4\u00F5\u00FA\u00FC\u00F1\-\'\,\.\)]*((\s?[0-9][0-9][\)]?\s?)*(\s?[0-9][0-9][\)]?\s?)*(\s?[-]\s?)*)*(\s\u0026|\sof\sthe|\sof|\sf\u00FCr|\sdes|\set|\sde\sla|\sdel|\sde\s|\svon|\svan)?\s*([A-Z\u00C1\u00C9\u00CD\u00D3\u00DA\u00DC\u00D6]\s?[\.]\s?)*\s*(of\sthe\s|of\s|f\u00FCr\s|des\s|et\s|y\sde\sla\s|y\sdel\s|de\sla\s|del\s|de\slos\s|de\s|do\s|da\s|dos\s|das\s|e\s|y\s|von\s|van\s)?){2,9}/g);
            if (lobjPossibleNamesUnit == null || lobjPossibleNamesUnit.length == 0) {
                continue;
            } else {
                for (var j = 0; j < lobjPossibleNamesUnit.length; j++) {
                    var lstrPossibleNameUnit = lobjPossibleNamesUnit[j];
                    lstrPossibleNameUnit = lstrPossibleNameUnit.trim();
                    
                    // Strip any trailing commas. --timathom
                    var lstrLastChar = lstrPossibleNameUnit.substr(lstrPossibleNameUnit.length - 1);
                    
                    if (lstrLastChar == ",") {
                        lstrPossibleNameUnit = lstrPossibleNameUnit.slice(0, -1);
                    }
                    PossibleNameListUnit.push(lstrPossibleNameUnit);
                }
            }
        }

        PossibleNameList = PossibleNameListBio.concat(PossibleNameListUnit);
        PossibleNameList = unique(PossibleNameList);
        PossibleNameList.sort();
        
        if (PossibleNameList.length == 0) {
            
            jQuery('html,body').animate({
                scrollTop: 0
            },
            0);
            //scroll to top to view form correctly
            
            callback('No matches for Named Entity Recognition.');
            //$('body').append("<div id=\"dialog\"><p>Canceled!</p></div>");
            //makeDialog('#dialog', 'Results'); // display results
            $('.form_container').remove();
            $('.help_container').remove();

            $('.main_edit').show();
            
            //set ace editor value to new xml from EAC Dom Document with ingested source and name entries
            //added to show changes immediately
            editor.getSession().setValue(lobjEac.getXML());

            
            return;
        }
        
        //display all possible names for editor to choose correct/desired names to search viaf and create relations
        display_possible_name_form(PossibleNameList, function (lobjChosenNames) {
            if (lobjChosenNames.length == 0) {
                
                jQuery('html,body').animate({
                    scrollTop: 0
                },
                0);
                //scroll to top to view form correctly
                
                callback("Canceled!");
                //done if no names where chosen
                

                $('.main_edit').show();
                
                //added to show changes immediately
                editor.getSession().setValue(lobjEac.getXML());
                
                return;
            }
            
            
            var ljsonChosenNames = JSON.stringify(lobjChosenNames);
            
            //post to ajax viaf ingestor controller to get relation nodes from viaf based on posted lists
            $.post('ajax/viaf_ingest_api.php', {
                'action': 'relations', 'chosen_names': ljsonChosenNames
            },
            function (response) {
                try {
                    var lobjOrigNames = JSON.parse(ljsonChosenNames);
                    // Keep the original name strings, in case there's no VIAF match.
                    var lobjData = JSON.parse(response);
                    //console.log(response);
                    if (lobjData.length == 0) {
                        callback('');
                        $('.form_container').remove();
                        $('.help_container').remove();
                        $('.main_edit').show();
                        

                    }
                }
                catch (e) //response should be JSON so if not, throw error
                {

                    return;
                }
                
                
                //display results from viaf relation nodes search so editor can choose which relations they want to ingest
                display_viaf_results_form(lobjData, function (lobjResultsChosen) {
                    if (typeof lobjResultsChosen[ 'names'] == 'undefined' || typeof lobjResultsChosen[ 'names'][ 'entity'][ 'all'] == 'undefined' || lobjResultsChosen[ 'names'][ 'entity'][ 'all'].length == 0) {
                        
                        jQuery('html,body').animate({
                            scrollTop: 0
                        },
                        0);
                        //scroll to top to view form correctly
                        
                        callback("Canceled!");
                        //finish process if no results chosen
                        $('.main_edit').show();
                        $('#entity_name').show();
                        // Check to see if there is already wiki markup. If so, show switcher. --timathom
                        if (record.wikiStatus === true) {
                            $('#wiki_switch').show();
                        } else {
                            $('#wiki_switch').hide();
                        }
                        return;
                    } else {
                        //ingest into EAC all chosen results from viaf
                        for (var i = 0; i < lobjResultsChosen[ 'names'][ 'entity'][ 'viaf'].length; i++) {
                            var chosen_result_viaf = lobjResultsChosen[ 'names'][ 'entity'][ 'viaf'][i];
                            

                            lobjEac.addCPFRelationViaf(lobjData[chosen_result_viaf]);
                            

                        }
                        
                        for (var i = 0; i < lobjResultsChosen[ 'names'][ 'entity'][ 'custom'].length; i++) {
                            var chosen_result_custom = lobjResultsChosen[ 'names'][ 'entity'][ 'custom'][i];
                            var chosen_roles = lobjResultsChosen[ 'names'][ 'roles'][i];
                            var chosen_rels = lobjResultsChosen[ 'names'][ 'rels'][i];
                            lobjEac.addCPFRelationCustom(lobjData[chosen_result_custom], chosen_roles, chosen_rels);
                        }
                        
                        editor.getSession().setValue(lobjEac.getXML());
                        
                        jQuery('html,body').animate({
                            scrollTop: 0
                        },
                        0);
                        //scroll to top to view form correctly
                        
                        callback('&lt;cpfRelation&gt; elements added!');
                        // Notify that <cpfRelation> elements have been added. --timathom
                        $('.main_edit').show();
                        $('#entity_name').show();
                    }
                });
            });
        });
    });
}

/*
 * display_possible_name_form displays a form for the editor to choose which names to search viaf to create relations.
 *
 * This is the second step in the VIAF process. It displays a list of names that are then selected and used to search in VIAF
 *
 * @method display_possible_name_form
 */
function display_possible_name_form(lobjPossibleNames, callback) {

    // Render the first template

    _.templateSettings.variable = "lobjPossibleNames";

    var template = _.template(
        $("#viaf-template-step-two").html()
    );

    $( "#form_viewport" ).append(
        template( lobjPossibleNames )
    );

    // jQuery added by timathom to include "Add New Row" and "Delete Row" buttons and functionality.
    $("input.ner_empty_add").on('click', function () {
        var tr = "<tr><td><input type=\"checkbox\" class=\"ner_check\" name=\"chosen_names\" value=\"\" checked/></td><td><input type=\"text\" class=\"ner_text\" name=\"modified_names\" size=\"60\" value=\"\" /></td><td><input type=\"button\" name=\"rm\" value=\"Delete Row\" class=\"ner_empty_rm pure-button pure-button-secondary\"/></td></tr>";
        $(this).closest("tr").after(tr);
        
        $("input.ner_empty_rm").on('click', function () {
            $(this).closest("tr").remove();
        });
    });
    
    setupSelectAll('input#select_all');
    //able to select all checkboxes
    jQuery('html,body').animate({
        scrollTop: 0
    },
    0);
    //scroll to top to view form correctly
    
    //register click event to continue process once user choses names
    $('#ingest_viaf_chosen_names_relations').on('click', function () {
        var lobjChosenNames =[];
        
        $('#main_content').append('<div id="viaf_load">Searching VIAF for matches. Depending on the number of queries, this may take some time.</div>');
        
        $('input.ner_check').each(function () {
            if (this.checked) {
                lobjChosenNames.push(encode_utf8($(this).closest('td').next('td').children('input').val()));
            }
        });
        // Display/notification logic added by timathom
        if (lobjChosenNames.length == 0) {
            $('body').append("<div id=\"dialog\"><p>Please choose or click Cancel!</p></div>");
            makeDialog('#dialog', 'Error!');
            // display error
            //$('.main_edit').hide();
        } else {
            callback(lobjChosenNames);
            $('.form_container').remove();
            $('.help_container').remove();
            $('.main_edit').hide();

        }
    });
    
    //register click event to cancel process
    $('#ingest_viaf_chosen_names_relations_cancel').on('click', function () {
        var lobjChosenNames =[];
        callback(lobjChosenNames);

        $('.form_container').remove();
        $('.help_container').remove();
        $('#viaf_load').remove();
        $('.main_edit').show();

    });
}

/*
 * display_viaf_results_form displays a form for the editor to choose which viaf results that editor wants to ingest as relations
 * @method display_viaf_results_form
 */
function display_viaf_results_form(lobjViafResults, callback) {

    // Render the first template

    _.templateSettings.variable = "lobjViafResults";

    var template = _.template(
        $("#viaf-template-step-three").html()
    );

    $( "#form_viewport" ).append(
        template( lobjViafResults )
    );


    setupSelectAll('input#select_all');
    //functionality to select all checkboxes
    jQuery('html,body').animate({
        scrollTop: 0
    },
    0);
    //scroll to top to view form correctly
    
    //register click event to continue process once user choses results
    $('#ingest_viaf_add_relations').on('click', function () {
        
        var lobjChosenResults =[];
        lobjChosenResults[ 'names'] =[];
        lobjChosenResults[ 'names'][ 'entity'] =[];
        lobjChosenResults[ 'names'][ 'entity'][ 'all'] =[];
        lobjChosenResults[ 'names'][ 'entity'][ 'viaf'] =[];
        lobjChosenResults[ 'names'][ 'entity'][ 'custom'] =[];
        lobjChosenResults[ 'names'][ 'rels'] =[];
        lobjChosenResults[ 'names'][ 'roles'] =[];

        $('input.viaf_check').each(function () {
            if (this.checked) {
                if ($(this).val() != "") {
                    lobjChosenResults[ 'names'][ 'entity'][ 'viaf'].push($(this).val());
                    lobjChosenResults[ 'names'][ 'entity'][ 'all'].push($(this).val());
                } else {
                    //lobjChosenResultsTest['names']['entity']['custom'].push($(this).closest('td').siblings('#plainText').children('#textSpan').text());
                    //console.log($(this).closest('td').siblings('#plainText').children('#textSpan').text());
                    
                    lobjChosenResults[ 'names'][ 'entity'][ 'all'].push($(this).closest('td').siblings('#plainText').children('#textSpan').text());
                    lobjChosenResults[ 'names'][ 'entity'][ 'custom'].push($(this).closest('td').siblings('#plainText').children('#textSpan').text());
                    
                    if ($(this).closest('td').siblings('#plainText').children('#select_wrap').children('#ents').children('option:selected').val() != '') {
                        lobjChosenResults[ 'names'][ 'roles'].push("http://rdvocab.info/uri/schema/FRBRentitiesRDA/" + $(this).closest('td').siblings('#plainText').children('#select_wrap').children('#ents').children('option:selected').text());
                    }
                    
                    if ($(this).closest('td').siblings('#plainText').children('#select_wrap').children('#rels').children('option:selected').val() != '') {
                        lobjChosenResults[ 'names'][ 'rels'].push($(this).closest('td').siblings('#plainText').children('#select_wrap').children('#rels').children('option:selected').text());
                    } else //( lobjChosenResults['names']['rels'].length == 0 )
                    {
                        lobjChosenResults[ 'names'][ 'rels'].push("associative");
                    }
                }
            }
        });
        
        // Display/notification added by timathom
        if (lobjChosenResults['names']['entity']['custom'].length != 0 && (lobjChosenResults['names']['roles'].length == 0 || typeof lobjChosenResults['names']['roles'] == 'undefined' || lobjChosenResults['names']['roles'] == '')) {
            $('body').append("<div id=\"dialog\"><p>Please select an Entity Type.</p></div>");
            makeDialog('#dialog', 'Error!');
            // display error
        } else if (lobjChosenResults['names']['entity']['all'].length == 0) {
            $('body').append("<div id=\"dialog\"><p>Please choose or click Cancel!</p></div>");
            makeDialog('#dialog', 'Error!');
            // display error
        } else {
            callback(lobjChosenResults);
            $('.form_container').remove();
            $('.help_container').remove();
            $('#viaf_load').remove();

        }
    });
    
    //register click event to cancel process
    $('#ingest_viaf_add_relations_cancel').on('click', function () {
        var lobjChosenResults =[];
        
        callback(lobjChosenResults);
        $('.form_container').remove();
        $('.help_container').remove();
        $('#viaf_load').remove();

    });
}

/*
 * ingest_worldcat_elements ingest subject headings and relationships from worldcat using API into passed EAC DOM Document.
 * @method ingest_worldcat_elements
 */

function ingest_worldcat_elements(lobjEac, lstrName, callback) {
    console.log(lstrName);

    lstrName = encode_utf8(lstrName);

    console.log(record.eacId);

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

                    jQuery('html,body').animate({
                            scrollTop: 0
                        },
                        0);
                    //scroll to top to view form correctly

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

                        // Result text added by timathom.
                        var lstrOtherRecId;
                        var lstrSources;
                        var lstrCpfResults;
                        var lstrResourceResults;

                        if (lobjOtherRecList.length == 0) {
                            lstrOtherRecId = '';
                        } else {
                            lstrOtherRecId = "<li>&lt;otherRecordId&gt; element(s) added.</li>";
                        }

                        if (lobjSourceList.length == 0) {
                            lstrSources = '';
                        } else {
                            lstrSources = "<li>&lt;source&gt; element added.</li>";
                        }

                        if (lobjCpfRelationList.length == 0) {
                            lstrCpfResults = '';
                        } else {
                            lstrCpfResults = "<li>&lt;cpfRelation&gt; element(s) added.</li>";
                        }
                        if (lobjResourceRelationList.length == 0) {
                            lstrResourceResults = '';
                        } else {
                            lstrResourceResults = "<li>&lt;resourceRelation&gt; element(s) added.</li>";
                        }


                        // Notification logic added by timathom.
                        if (lobjSubjectList.length == 0) {

                            $('body').append("<div id=\"dialog\"><p>No matching subjects.</p><br/>" + lstrOtherRecId + lstrSources + lstrCpfResults + lstrResourceResults + "</div>");
                            makeDialog('#dialog', 'Results');
                            // display results

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

                                    $('flash_message').append("<div id=\"dialog\"><p>No subjects added.</p><br/>" + lstrOtherRecId + lstrSources + lstrCpfResults + lstrResourceResults + "</div>");

                                    // display results
                                    $('.form_container').remove();
                                    //$('.help_container').remove();

                                    editor.getSession().setValue(lobjEac.getXML());
                                    return;

                                } else {

                                    $('#flash_message').append("<ul><li>&lt;localDescription&gt; element(s) added with chosen subject(s).</li>" + lstrOtherRecId + lstrSources + lstrCpfResults + lstrResourceResults + "</ul>");



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


    jQuery('html,body').animate({
        scrollTop: 0
    },
    0);
    //scroll to top to view form correctly
    
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

        $('.main_edit').show();
        

        jQuery('html,body').animate({
            scrollTop: 0
        },
        0);
        //scroll to top to view form correctly
        
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

    setupSelectAll('input#select_all');
    //setup to select all checkboxes

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
            // display error
            //$('.main_edit').hide();
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


function render_help_template(div_id) {

    // Render the first help template
    var help_template = _.template(
        $("#" + div_id).html()
    );

    $("#help_viewport").append(
        help_template()
    );
}