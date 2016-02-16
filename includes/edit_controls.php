<div id="edit_controls">
    <h1 id="entity_name"></h1>


  <span id="ingest_buttons" class="main_edit">
  <button id="ingest_worldcat" class="ingest_button pure-button pure-button-primary main_edit">Ingest WorldCat
      Identities
  </button>
      <button id="ingest_viaf" class="ingest_button pure-button pure-button-primary main_edit">Ingest VIAF</button>
  </span>

    <button id="save_eac" class="pure-button pure-button-primary main_edit">Save XML</button>
    <button id="convert_to_wiki" class="pure-button pure-button-primary main_edit">Convert to Wiki Markup</button>


    <form id="download_form" method="post" target="_blank" action="download.php">
        <input id="download_xml" type="hidden" name="xml" value=""/>
        <input id="file_name" type="hidden" name="path" value="">
        <button id="download_submit" class="pure-button pure-button-primary main_edit" type="submit">Export Current
            EAC-CPF
        </button>
    </form>


</div>