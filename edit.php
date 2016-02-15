<?php
/**
 * Created by PhpStorm.
 * User: cbrownroberts
 * Date: 2/11/16
 * Time: 10:21 AM
 */

include('header.php');

?>

    <div>
        <?php include 'views/worldcat/index.php'; ?>
    </div>

    <div>
        <?php include 'views/viaf/index.php'; ?>
    </div>


    <div>
        <?php include 'views/wiki/index.php'; ?>
    </div>

    <script src="script/ace/ace.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript" src="assets/js/rampEditor.js"></script>
    <script type="text/javascript" src="assets/js/worldcatIngest.js"></script>
    <script type="text/javascript" src="assets/js/rampSetup.js"></script>

    <script>
        $(document).ready(function () {
            // Initialize the ramp interface
            var myRampSetup = rampSetup();
            myRampSetup.init();
        });
    </script>

    <script>
        var editor = ace.edit("editor");
        editor.getSession().setMode("ace/mode/xml");
    </script>

<?php include('footer.php'); ?>