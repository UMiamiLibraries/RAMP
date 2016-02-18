<?php
include('header.php');
?>

    <!--HOMEPAGE content (top)-->
    <div id="feature-heading" class="feature-heading">
        
        <div class="inner-area">
            <div class="ramp-intro">
                <div class="ramp-intro-text">
                    <div class="pure-g">
                        <div class="pure-u-7-12 pure-u-lg-2-3">
                                <p>The <strong>RAMP (The Remixing Archival Metadata Project)</strong> editor is a web-based tool that allows users to: (1) generate enhanced authority records, and (2) publish the content of those records as Wikipedia pages. <a href="#">[more]</a></p>
                        </div>
                        <div class="pure-u-5-12 pure-u-lg-1-3">&nbsp;</div>
                    </div>
                </div>
            </div>
        </div> 

        <div class="project-title">
            <div class="inner-area">
                <h1><span class="titleup">R</span>emixing <span class="titleup">A</span>rchival <span class="titleup">M</span>etadata <span class="title-light">Project</span></h1>
            </div>
        </div>
    </div><!--end HOMEPAGE content (top)-->


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
            <div id="help_viewport">
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