<?php
include('header.php');
?>

    <div id="feature-heading" class="feature-heading">

    </div>

    <div class="pure-g">
        <div class="pure-u-6-24"></div>
        <div class="pure-u-10-24">

            <div class="content_box" id="intro_box">
                <?php
                use RAMP\Util\RecordList;
                use RAMP\Util\Database;

                $db = Database::getInstance();
                $rl = new RecordList($db);
                $rl->getDropdown();

                ?>
            </div>
            <span class="import_now"><a href="ead_convert.php">Can't find a record? Import it now!</a></span>

        </div>
        <div class="pure-u-6-24"></div>
    </div>

    <div class="pure-g">

        <div class="pure-u-18-24">

            <h1 id="record_entityName_header"></h1>

            <?php include('includes/module_controls.php'); ?>

            <div id="flash_message"></div>

            <div id="form_viewport">
                <div id="loading_image"></div>
                <?php include('includes/worldcat/worldcat.php'); ?>
                <?php include('includes/viaf/viaf.php') ?>
            </div>

            <?php include('includes/editor.php') ?>

        </div>


        <div class="pure-u-6-24">
            <div id="context_help_viewport">
                <?php include 'includes/worldcat/help.php'; ?>
            </div>
        </div>

    </div>



    <script src="script/external/ace/ace.js" type="text/javascript" charset="utf-8"></script>

    <script>
        var editor = ace.edit("editor");
        editor.getSession().setMode("ace/mode/xml");
    </script>
    <!-- End Ace Editor -->

    <!-- Select2 -- the jQuery Plugin for Autocomplete -->

    <script type="text/javascript">
        $('select').select2({
            placeholder: "Select a name",
        });
    </script>

    <!-- End Select 2 -->
<?php
include('footer.php');
?>