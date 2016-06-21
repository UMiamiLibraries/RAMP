 jQuery(document).ready(function ($) {
        // Show select box by default, so that we can refresh after import.
        $("#menu_3").show();
        var lstrDir = $('input[name="dir"]').val();
        $('#convertEad2Eac').on('click', function () {
            document.cookie = "convert=true";
            var lboolContinue = true;
            var lobjUnprocessed = [];
            $('#convertEad2Eac').attr('disabled', 'disabled');
            $('#file_estimator').html('Processing...');
            $('#file_estimator').show("fast");
            $('#results').html('');
            convertEad(lstrDir, lobjUnprocessed, '');
        });
    });
function convertEad(lstrDir, lobjUnprocessed) {
    console.log(lobjUnprocessed);
    $.ajax(
        {
            url: 'ajax/convert_ead_to_eac.php?dir=' + encodeURI(lstrDir),
            data: {'files': lobjUnprocessed},
            type: "POST",
            success: function (response) {
                try {
                    var lobjData = JSON.parse(response);
                }
                catch (e) //response should be JSON so if not, throw error
                {
                    alert(response);
                    return;
                }

                if (lobjData.status == "done") {
                    $('#file_estimator').html('Done');
                    $('#exporting').html("<a style=\"font-size:1.4em; margin:1%;\" href=\"export.php\">Export EAC-CPF Records</a>");
                    $('#results').html();
                    $('#convertEad2Eac').removeAttr('disabled');
                } else {
                    $('#file_estimator').html(lobjData.unprocessed.length + " files left.");
                    lobjUnprocessed = lobjData.unprocessed;
                    convertEad(lstrDir, lobjUnprocessed);
                }
            },
            async: true
        });
}
