$(document).ready(function () {


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

});