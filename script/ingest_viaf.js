/**
 * Created by cbrownroberts on 2/18/16.
 */
$(document).ready(function () {

    //register click event that will start viaf ingest
    $('#ingest_viaf').on('click', function () {

        //clear any flash messages
        clearFlashMessage();

        clear_help_template_container();

        startViaf();
    });

});



function startViaf() {

    record.onWiki = false; // Unset "onWiki" status
    record.eacXml = editor.getValue();

    //cannot start ingestion without XML being loaded
    if (record.eacXml == '') {
        //display error
        $('body').append("<div id=\"dialog\"><p>Must load EAC first!</p></div>");
        makeDialog('#dialog', 'Error!');

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
                    //display response
                    $('body').append("<div id=\"dialog_main\"><p>" + lstrMessage + "</p></div>");
                    makeDialog('#dialog_main', 'Response');

                });
            });
        } else {
            //display error when xml is not valid
            $('body').append("<div id=\"dialog\"><p>XML must be valid!</p></div>");
            makeDialog('#dialog', 'Error!');
        }
    }, record.eacXml);
}