$(document).ready(function () {

    selectFileToIngest();

    //clear ingest instructions after any module button is clicked
    clearInitialIngestInstructions();


    function selectFileToIngest() {

        $('.ead_files').change(function () {

            //set record object;


            record.eadFile = this.value;
            record.entityName = $(this).children("option:selected").text();
            record.savedXml = "";
            record.wikiConversion = "";
            record.eacId = $(this).children("option:selected").data().id;

            //set the page header with name of person/file
            $('#record_entityName_header').text(record.entityName).hide();

            //build the ace editor
            build_editor(record.eacId);

        });
    }

    function clearInitialIngestInstructions() {
        $('#ingest_buttons > button').on('click', function() {
            $('#controls_panel_instructions').remove();
        });
    }

    function disableEadDropDownSelect() {
        //clicking any module button means the process has started and user can no longer click dropdown select
        $('#ingest_buttons > button').on('click', function() {
            $('#ead_files_select_menu').attr('disabled', 'disabled');
        });
    }

    

});