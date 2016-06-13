$(document).ready(function () {

    //register click event that will start viaf ingest
    $('#ingest_viaf').on('click', function () {



        //diable module buttons
        disableAllModuleButtons();

        //clear any flash messages
        clearFlashMessage();

        clearHelpTemplateContainer();

        startViaf();
    });

    function startViaf() {

        viewSwitch.reset();

        viewSwitch.showViafStepOne();

        record.onWiki = false; // Unset "onWiki" status
        record.eacXml = editor.getValue();

        //cannot start ingestion without XML being loaded
        if (record.eacXml == '') {
            //display error
            $('#flash_message').append("<div class=\"error-message\"><p>Must load EAC first!</p></div>");
            return;
        }

        showLoadingImage();

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
                        //display response
                        $('body').append("<div id=\"dialog_main\"><p>" + lstrMessage + "</p></div>");
                        makeDialog('#dialog_main', 'Response');

                    });
                });
            } else {
                //display error when xml is not valid
                $('body').append("<div id=\"dialog\"><p>XML must be valid!</p></div>");
                makeDialog('#dialog', 'Error!');

                hideLoadingImage();

                viewSwitch.showAceEditor();
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

                                //scroll to top to view form correctly
                                scrollToFormTop();

                                // display results
                                renderFlashMessage('<div class=\"success-message\"><p>Success! XML elements added.</p></div>');


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

        //register click event to continue process once user chosesviaf results
        $('#ingest_viaf_chosen_viaf').on('click', function () {
            var lstrChosenViaf = $('input[name="chosen_viaf_id"]:checked').val();

            if (typeof lstrChosenViaf == 'undefined') {
                $('body').append("<div id=\"dialog\"><p>Please choose a match or click \"Cancel\"!</p></div>");
                makeDialog('#dialog', 'Error!');
                // display error
            } else {
                callback(lstrChosenViaf);
                $('.form_container').remove();
                $('.help_container').remove();
                viewSwitch.hideAceEditor();;
            }
        });

        //register click event to cancel process
        $('#ingest_viaf_chosen_viaf_cancel').on('click', function () {

            viewSwitch.removeViafStepOne();

            viewSwitch.showHome();

            renderFlashMessage('<div class=\"success-message\"><p>VIAF Ingest Canceled</p></div>');


            enableAllModuleButtons();
        });

        //scroll to top to view form correctly
        scrollToFormTop();

        //render contextual help template
        renderHelpTemplate('viaf_template_help_step_one');
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

                    //scroll to top to view form correctly
                    scrollToFormTop();

                    callback('No matches for Named Entity Recognition.');

                    $('.form_container').remove();
                    $('.help_container').remove();

                    viewSwitch.showAceEditor();

                    //set ace editor value to new xml from EAC Dom Document with ingested source and name entries
                    //added to show changes immediately
                    editor.getSession().setValue(lobjEac.getXML());



                    return;
                }

                //display all possible names for editor to choose correct/desired names to search viaf and create relations
                display_possible_name_form(PossibleNameList, function (lobjChosenNames) {
                    if (lobjChosenNames.length == 0) {

                        //scroll to top to view form correctly
                        scrollToFormTop();

                        //callback("!Canceled!");
                        //done if no names where chosen

                        viewSwitch.showAceEditor();

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
                                    viewSwitch.showAceEditor();
                                }
                            }
                            catch (e) //response should be JSON so if not, throw error
                            {
                                return;
                            }

                            //display results from viaf relation nodes search so editor can choose which relations they want to ingest
                            display_viaf_results_form(lobjData, function (lobjResultsChosen) {

                                if (typeof lobjResultsChosen[ 'names'] == 'undefined' || typeof lobjResultsChosen[ 'names'][ 'entity'][ 'all'] == 'undefined' || lobjResultsChosen[ 'names'][ 'entity'][ 'all'].length == 0) {

                                    //scroll to top to view form correctly
                                    scrollToFormTop();

                                    //callback("Canceled!");

                                    //finish process if no results chosen
                                    viewSwitch.showAceEditor();

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

                                        lobjEac.addCPFRelationCustom(lobjData[chosen_result_custom], lobjData[chosen_roles], lobjData[chosen_rels]);
                                    }


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
                                    
                                    editor.getSession().setValue(lobjEac.getXML());

                                    //scroll to top to view form correctly
                                    scrollToFormTop();

                                    renderFlashMessage('<div class=\"success-message\"><p>Success! XML updated with new CPF Relation element(s).</p></div>');

                                    //display the aceEditor and xml action buttons
                                    viewSwitch.showAceEditor();
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

        //render help template
        renderHelpTemplate('viaf_template_help_step_two');

        // jQuery added by timathom to include "Add New Row" and "Delete Row" buttons and functionality.
        $("input.ner_empty_add").on('click', function () {
            var tr = "<tr><td><input type=\"checkbox\" class=\"ner_check\" name=\"chosen_names\" value=\"\" checked/></td><td><input type=\"text\" class=\"ner_text\" name=\"modified_names\" size=\"60\" value=\"\" /></td><td><input type=\"button\" name=\"rm\" value=\"Delete Row\" class=\"ner_empty_rm ramp-button\"/></td></tr>";
            $(this).closest("tr").after(tr);

            $("input.ner_empty_rm").on('click', function () {
                $(this).closest("tr").remove();
            });
        });

        //able to select all checkboxes
        setupSelectAll('input#select_all');

        //scroll to top to view form correctly
        scrollToFormTop();

        //register click event to continue process once user choses names
        $('#ingest_viaf_chosen_names_relations').on('click', function () {
            var lobjChosenNames =[];

            renderFlashMessage('<div class="processing-message"><p>Searching VIAF for matches. Depending on the number of queries, this may take some time.</p></div>');

            $('input.ner_check').each(function () {
                if (this.checked) {
                    lobjChosenNames.push(encode_utf8($(this).closest('td').next('td').children('input').val()));
                }
            });

            // Display/notification logic added by timathom
            if (lobjChosenNames.length == 0) {
                // display error
                $('body').append("<div id=\"dialog\"><p>Please choose a relation element or click \"Cancel\"!</p></div>");
                makeDialog('#dialog', 'Error!');

            } else {
                callback(lobjChosenNames);
                $('.form_container').remove();
                $('.help_container').remove();

                viewSwitch.hideAceEditor();

                renderFlashMessage('<div class="processing-message"><p>Searching VIAF for matches. Depending on the number of queries, this may take some time.</p></div>');

                showLoadingImage();
            }
        });

        //register click event to cancel process
        $('#ingest_viaf_chosen_names_relations_cancel').on('click', function () {
            var lobjChosenNames =[];
            callback(lobjChosenNames);

            viewSwitch.removeViafStepTwo()

            //cancel ingest and viewSwitch.showHome
            viewSwitch.showHome();

            renderFlashMessage('<div class=\"success-message\"><p>VIAF Ingest Process Canceled</p></div>');

            enableAllModuleButtons();


        });
    }

    /*
     * display_viaf_results_form displays a form for the editor to choose which viaf results that editor wants to ingest as relations
     * @method display_viaf_results_form
     */
    function display_viaf_results_form(lobjViafResults, callback) {

        clearFlashMessage();

        hideLoadingImage();

        // Render the first template
        _.templateSettings.variable = "lobjViafResults";

        var template = _.template(
            $("#viaf-template-step-three").html()
        );

        $( "#form_viewport" ).append(
            template( lobjViafResults )
        );

        //render help template
        renderHelpTemplate('viaf_template_help_step_three');

        //functionality to select all checkboxes
        setupSelectAll('input#select_all');

        //scroll to top to view form correctly
        scrollToFormTop();

        //register click event to continue process once user choses results
        $('#ingest_viaf_add_relations').on('click', function () {

            console.log('viaf');
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
                $('body').append("<div id=\"dialog\"><p>Please choose or click \"Cancel\"!</p></div>");
                makeDialog('#dialog', 'Error!');
                // display error
            } else {
                callback(lobjChosenResults);
                $('.form_container').remove();
                $('.help_container').remove();
                $('#viaf_load').remove();

                // display ace editor
                viewSwitch.showAceEditor();

                //render help template
                renderHelpTemplate('viaf_template_help_step_four');

            }


        });

        //register click event to cancel process
        $('#ingest_viaf_add_relations_cancel').on('click', function () {
            var lobjChosenResults =[];

            callback(lobjChosenResults);

            viewSwitch.removeViafStepThree();

            viewSwitch.showHome();

            renderFlashMessage('<div class=\"success-message\"><p>VIAF Ingest Process Canceled</p></div>');

            enableAllModuleButtons();

        });
    }

});