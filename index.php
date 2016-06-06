<?php
include('header.php');
?>



    <!--HOMEPAGE content (top)-->
    <div id="feature-heading" class="feature-heading home-view">
        
        <div class="inner-area">
            <div class="ramp-intro">
                <div class="ramp-intro-text">
                    <div class="pure-g">
                        <div class="pure-u-7-12">
                                <p>The <strong>RAMP (Remixing Archival Metadata Project)</strong> editor is a web-based tool that allows users to: (1) generate enhanced authority records, and (2) publish the content of those records as Wikipedia pages. <a href="#ramp-more">[more]</a></p>
                        </div>
                        <div class="pure-u-5-12">&nbsp;</div>
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


    <!--APP content-->
    <div class="app-content"> 

        <div class="recordtitle-bkg">    
           <div class="recordtitle">
                <div class="inner-area"><h2 id="record_entityName_header"></h2></div>
           </div>
        </div>

            <div class="decoration-bar">
                <div class="pure-g">
                    <div class="pure-u-1-4 decor1"></div>
                    <div class="pure-u-1-4 decor2"></div>
                    <div class="pure-u-1-4 decor3"></div>
                    <div class="pure-u-1-4 decor4"></div>
                </div>
            </div>

        <div class="inner-area"> 

            <div class="select-panel">
                <div class="pure-g">
                    <div class="pure-u-2-3">
                            <div class="content_box" id="intro_box">
                                <?php
                                use RAMP\Util\RecordList;
                                use RAMP\Util\Database;

                                $db = Database::getInstance();
                                $rl = new RecordList($db);
                                $rl->getDropdown();

                                ?>
                            </div>
                            <div class="import_now home-view">Can't find a record? <a href="ead_convert.php">Import it now!</a></div>
                    </div>
                    <div class="pure-u-1-3">
                        <div class="all_items-btn-container home-view">
                            <button id="view_all_items" class="viewall_button pure-button"><i class="fa fa-list-ul"></i> <a href="all-items.php">All Items</a></button>
                        </div>                            
                    </div>
                </div>
            </div>

            <div class="controls-panel">
                <div class="pure-g">
                    <div class="pure-u-1 pure-u-md-2-3">
                        <?php include('includes/module_controls.php'); ?>
                        <p id="controls_panel_instructions">- Click on a process to continue -</p>
                    </div>
                    <div class="pure-u-1 pure-u-md-1-3">&nbsp;</div>
                </div>
                
            </div>


            <div class="actions-area">
                
                <div class="pure-g">
                    <div class="pure-u-1 pure-u-lg-2-3" id="form_viewport_area">
                            <div id="flash_message"></div>

                            <div id="form_viewport">
                                <div id="loading_image"></div>
                                <?php include('includes/worldcat/worldcat.php'); ?>
                                <?php include('includes/viaf/viaf.php') ?>
                                <?php include('includes/wiki/wiki.php') ?>
                                <?php include('includes/wiki/wiki_dialogs.php') ?>


                            </div>

                            <?php include('includes/editor.php') ?>
                    </div>
                    <div class="pure-u-1 pure-u-lg-1-3" id="help_viewport_area">
                            <div id="help_viewport">
                                <?php include 'includes/worldcat/help.php'; ?>
                                <?php include 'includes/viaf/help.php'; ?>
                                <?php include 'includes/wiki/help.php'; ?>
                            </div>
                    </div>
                </div>
            </div>

        </div>

    </div><!--end APP content-->

    
    <!--HOMEPAGE content (bottom)-->
    <div class="homepage-content home-view">
        <div class="inner-area">
            <div class="homepage-content-text">
                <a name="ramp-more"></a><h3>How Does RAMP Work?</h3>
                <p>The RAMP editor extracts biographical and historical data from <a href="https://www.loc.gov/ead/" target="_blank">EAD</a> Finding Aids to create new authority records for persons, corporate bodies, and families associated with archival and special collections. Users can enhance those records with additional data from sources like <a href="http://viaf.org/" traget="_blank">VIAF</a> and <a href="http://www.oclc.org/research/themes/data-science/identities.html" target="_blank">WorldCat Identities</a> and RAMP will transform them into wiki markup suitable for publication to the English Wikipedia. New content can then be edited and added to an existing Wikipedia page or be used to start a new one from within the RAMP editor.</p> 
            </div>

            <div class="glossary-feature">
                <div class="pure-g">
                    <div class="pure-u-1-2 pure-u-lg-1-4">
                        <div class="glossary-term">
                            <h5>Authority Record</h5>
                            <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer luctus sapien vitae metus ultrices ultrices. Integer pulvinar ligula id urna hendrerit aliquam.</p>
                        </div>
                    </div>
                    <div class="pure-u-1-2 pure-u-lg-1-4">
                        <div class="glossary-term">
                            <h5>EAC-CPF</h5>
                            <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer luctus sapien vitae metus ultrices ultrices. Integer pulvinar ligula id urna hendrerit aliquam.</p>
                        </div>
                    </div>
                    <div class="pure-u-1-2 pure-u-lg-1-4">
                        <div class="glossary-term">
                            <h5>EAD Finding Aid</h5>
                            <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer luctus sapien vitae metus ultrices ultrices. Integer pulvinar ligula id urna hendrerit aliquam.</p>
                        </div>
                    </div>
                    <div class="pure-u-1-2 pure-u-lg-1-4">
                        <div class="glossary-term">
                            <h5>VIAF</h5>
                            <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer luctus sapien vitae metus ultrices ultrices. Integer pulvinar ligula id urna hendrerit aliquam.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div><!--end HOMEPAGE content (bottom)-->


    <script src="script/external/ace/ace.js" type="text/javascript" charset="utf-8"></script>

    <script>
        var editor = ace.edit("editor");
        editor.getSession().setMode("ace/mode/xml");
    </script>
    <!-- End Ace Editor -->


    <!-- Select2: the jQuery Plugin for Autocomplete -->

    <script type="text/javascript">
        $('select').select2({
            placeholder: "Select a name", 
            containerCssClass: 'tpx-select2-container select2-grey',
            dropdownCssClass: 'tpx-select2-drop select2-blue'           
        });
    </script>
    <!-- End Select 2 -->




<?php
include('footer.php');
?>
<script>
    <?php if (isset($_GET['eac_id'])) {
        echo "var eacId = ";
        echo (int) $_GET['eac_id'];
        echo ";";
        echo " $(document).ready(function() {
        build_editor(eacId);
    });";

    } ?>


</script>


