<?php
include('header.php');
?>

    <link rel="stylesheet" href="style/jquery.phpdiffmerge.min.css"/>
    <script src="script/external/jquery.phpdiffmerge.min.js"></script>

    <script type="text/javascript">
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
        function convertEad(lstrDir, lobjUnprocessed, lstrDiffs) {
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
                        lstrDiffs += lobjData.diffs;
                        if (lobjData.status == "done") {

                            $('#file_estimator').html('Done');

                            $('#exporting').html("<a style=\"font-size:1.4em; margin:1%;\" href=\"export.php\">Export EAC-CPF Records</a>");


                            $('#results').html(lstrDiffs);
                            $('#convertEad2Eac').removeAttr('disabled');
                        } else {
                            $('#file_estimator').html(lobjData.unprocessed.length + " files left.");
                            lobjUnprocessed = lobjData.unprocessed;
                            convertEad(lstrDir, lobjUnprocessed, lstrDiffs);
                        }
                    },
                    async: true
                });
        }
    </script>


    <div class="pure-g">
        <div class="pure-u-1-2">
            <h1>Upload from the EAD Folder</h1>
            <div class="content_box">

                <p id="convert_message">On this page you can convert EAD files or import EAC-CPF files that you have
                    placed in the 'ead' folder during the install process.</p>

                <form action="ead_convert_class.php">

                    <input type="hidden" name='dir' value="<?php echo $ead_path ?>"></input>
                    <button type="button" id="convertEad2Eac" name="convertEad2Eac"
                            class="pure-button pure-button-primary">Import
                    </button>
                    <span id="file_estimator" style="display: none;"></span>
                    <div id="results"></div>
                </form>
                <p> After importing you can export and download the records.</p>
                <div id="exporting"></div>
            </div>


        </div>
        <div class="pure-u-1-2">
            <h1>Upload an EAD</h1>
            <form enctype="multipart/form-data" action="ajax/uploader.php" method="POST">
                <input type="hidden" name="MAX_FILE_SIZE" value="30000000"/>
                Upload an EAD: <input name="ead" type="file"/>
                <input type="submit" value="Upload EAD"/>
            </form>

        </div>


    </div> <!-- end pure-g -->

<?php include('footer.php'); ?>