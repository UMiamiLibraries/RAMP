<?php
/*
  This script displays a form for creating a new EAC record.

  -- Jamie

*/

include('header.php');
?>
<form id="new_eac_form">
  <br/>
  <label style="display:inline;">Entity type</label>
  <select id="entity_type">
    <option>person</option>
    <option>corporate body</option>
    <option>family</option>
  </select>
  <br/>
  <br/>
  <label>Name</label>
  <input id="eac_name" type="text" size="49"/>
  <br/>
  <br/>
  <label>Dates of existence</label>
  <label style="display:inline;">From</label>
  <input id="from" type="text"/>
  <label style="display:inline;">To</label>
  <input id="to" type="text"/>
  <br/>
  <br/>
  <label>Associated places <span style="font-style:italic;">(enter each place on a new line)</span></label>
  <label>Places and associated dates must be preceded by <a href="http://www.loc.gov/marc/authority/ad370.html">MARC 370 subfield delimiters</a> ($a, $b, $c, $e, $f, $g, $s, $t).</label>
  <textarea cols="60" style="margin-left:0; margin-bottom:1%;" id="places"></textarea>
  <br/>
  <br/>
  <label>Associated group <span style="font-style:italic;">(enter each group on a new line)</span></label>
  <label>Groups and associated dates must be preceded by <a href="http://www.loc.gov/marc/authority/ad373.html">MARC 373 subfield delimiters</a> ($a, $s, $t).</label>
  <textarea cols="60" style="height:80px; margin-left:0; margin-bottom:1%;" id="group"></textarea>
  <br/>
  <br/>
  <label>Occupation or field of activity <span style="font-style:italic;">(enter each item on a new line)</span></label>
  <label>Activities and associated dates must be preceded by <a href="http://www.loc.gov/marc/authority/ad374.html">MARC 374 subfield delimiters</a> ($a, $s, $t).</label>
  <textarea cols="60" style="height:80px; margin-left:0; margin-bottom:1%;" id="activity"></textarea>
  <br/>
  <br/>
  <label>Gender</label>
  <select id="gender">
    <option></option>
    <option>female</option>
    <option>male</option>
    <option>other</option>
  </select>
  <br/>
  <br/>
  <label>Language <span style="font-style:italic;">(enter each item on a new line)</span></label>
  <label>Three-letter codes and language names must be preceded by <a href="http://www.loc.gov/marc/authority/ad377.html">MARC 377 subfield delimiters</a> ($a, $l).</label>
  <textarea cols="60" style="height:80px; margin-left:0; margin-bottom:1%;" id="lang"></textarea>
  <br/>
  <br/>
  <label>Biography or history <span style="font-style:italic;">(enter a blank line between each paragraph)</span></label>
  <textarea cols="60" style="margin-left:0; margin-bottom:1%;" id="bioghist"></textarea>
  <br/>
  <br/>
  <label>Sources <span style="font-style:italic;">(enter a blank line between each source)</span></label>
  <textarea cols="60" style="margin-left:0; margin-bottom:2%;" id="sources"></textarea>
  <br/>
  </form>

  <button id="submit_new" class="pure-button pure-button-primary" style="margin-left:39.6%; display:block; clear:left;">Create</button>
  <p id="results" style="margin-left:7px;"></p>
  <br/>
  <br/>



  <script>

   var $savedialog = $('<div></div>')
      .html('Saved New Record')
      .dialog({
        autoOpen: false,
        buttons: {
          "OK" : function () {
            $( this ).dialog( "close" );
          }
        }
    });

  $('#submit_new').click(function() {
      $('#results').html('');

      $.post("save_new.php", {
        type: $('#entity_type').val(),
	    entity: $('#entity_type').val(),
	    name: $('#eac_name').val(),
	    from: $('#from').val(),
	    to: $('#to').val(),
	    places: $('#places').val(),
	    group: $('#group').val(),
	    activity: $('#activity').val(),
	    gender: $('#gender').val(),
	    lang: $('#lang').val(),
	    bioghist: $('#bioghist').val(),
	    sources: $('#sources').val(),
      	dir : <?php echo  '"' . addslashes($ead_path) . '"'; ?>

	    }, function (data) {

	   $savedialog.html(data).dialog('open');

      window.setTimeout(slowreload, 1000);

      function slowreload() {
        location.reload();
      }

	});

    });

</script>

<?php
include('footer.php');
?>