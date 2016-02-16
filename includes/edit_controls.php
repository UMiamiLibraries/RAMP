<div id="edit_controls">
    <h1 id="entity_name"></h1>

    <div class="pure-g">
        <div class="pure-u-6-24"></div>
        <div class="pure-u-10-24">
          <span id="ingest_buttons" class="main_edit">
  <button id="ingest_worldcat" class="ingest_button pure-button pure-button-primary main_edit">WorldCat
      Identities
  </button>
      <button id="ingest_viaf" class="ingest_button pure-button pure-button-primary main_edit">VIAF</button>
  </span>

            <button id="convert_to_wiki" class="pure-button pure-button-primary main_edit">Wikipedia</button>
        </div>
        <div class="pure-u-6-24"></div>

    </div>


    <div class="pure-g">
        <div class="pure-6-24"></div>
        <div class="pure-10-24">
            <div class="xml_buttons">
                <button id="save_eac" class="pure-button pure-button-primary main_edit">Save XML</button>


                <form id="download_form" method="post" target="_blank" action="download.php">
                    <input id="download_xml" type="hidden" name="xml" value=""/>
                    <input id="file_name" type="hidden" name="path" value="">
                    <button id="download_submit" class="pure-button pure-button-primary main_edit" type="submit">Export
                        Current
                        EAC-CPF
                    </button>
                </form>
            </div>
        </div>
        <div class="pure-6-24"></div>
    </div>

    <div class="pure-g">
        <div class="pure-u-1">
            <div class="wiki_buttons">
                <button id="wiki_login" class="pure-button pure-button-primary">Wikipedia Login</button>

            </div>
        </div>
    </div>
</div>