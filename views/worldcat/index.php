<?php
/**
 * Created by PhpStorm.
 * User: cbrownroberts
 * Date: 2/11/16
 * Time: 10:04 AM
 */

?>


<div id="worldcat_viewport">

    <h1 id="worldcat_search_term_text"></h1>

    <div id="main_edit_bar">
      <span id="ingest_buttons" class="main_edit">
          <button id="ingest_worldcat" class="ingest_button pure-button pure-button-primary main_edit">Ingest WorldCat Identities</button>
          <button id="ingest_viaf" class="ingest_button pure-button pure-button-primary main_edit">Ingest VIAF</button>
      </span>
    </div>

    <hr>

    <div id="wiki_switch">
        <button id="xml_switch_button" class="pure-button pure-button-primary">XML</button>
        <button id="wiki_switch_button" class="pure-button pure-button-primary">Wiki</button>
    </div>


    <div id="validation" class="main_edit"></div>
    <div id="validation_text" class="main_edit">Valid XML</div>
    <button id="editor_readonly_button" data-readonly="on">Toggle XML Edit</button> <span id="readonly_status">XML Editing Disabled</span>

    <div id="editor_mask" class="main_edit">
        <div id="editor_container" class="main_edit">
            <div id="editor" class="main_edit"></div>
        </div>
    </div>





    <?php include 'partials/_form.php'; ?>


    <?php include 'bestmatch/index.php'; ?>


    <?php include 'subjects/index.php'; ?>


    <?php include 'editor/index.php'; ?>


</div>
