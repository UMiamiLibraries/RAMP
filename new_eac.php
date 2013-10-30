<?php
/*
  This script displays a form for creating a new EAC record.

  -- Jamie

*/

include('header.php');
?>

<script>

jQuery(document).ready(function()
{
  $('input[type="text"]').val('');
  $('select').val('');
  $('textarea').val('');
});

</script>

<table id="new_eac_table">
<tr>
  <td><h1>Create a new EAC-CPF record</h1></td>
</tr>
<tr>
  <td style="font-size:1.2em;padding-left:5px;">Except for entity type and name, all other fields are optional.</td>
</tr>
<tr>
<td>
<form id="new_eac_form">
  <table>
    <tr>
      <td>
        <label class="multi">Entity type <span style="font-style:italic;"></span></label>
      </td>
     </tr>
    <tr>
    <td>
    <table class="new_eac_inner">
      <tr>
      <td>
      <select class="entity_type">
        <option> </option>
        <option>Person</option>
        <option>Corporate Body</option>
        <option>Family</option>
      </select>
      </td>
      </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td>
      <label class="multi">Name and dates <span style="font-style:italic;"></span></label>
    </td>
  </tr>
  <tr>
  <td>
  <table class="new_eac_inner">
  <tr>
    <td>
      <label>Name (Last Name, First Name)</label>
      <input class="eac_name" type="text" size="49"/>
    </td>
  <tr>
  <tr>
    <td>
    <label>Dates of existence</label>
      <label style="display:inline;">From</label>
      <input class="from" type="text"/>
      <label style="display:inline;">To</label>
      <input class="to" type="text"/>
    </td>
  </tr>
  </table>
  </td>
  </tr>
  <tr>
    <td>
      <label class="multi">Gender <span style="font-style:italic;"></span></label>
    </td>
  </tr>
  <tr>
  <td>
  <table class="new_eac_inner">
  <tr>
    <td>
      <input type="button" name="addGender" value="Add New Entry" class="add_empty_element add_empty_gender pure-button pure-button-secondary" style="border:none;"/>
    </td>
  </tr>
  <tr class="multilvl">
  <td>
  <table class="new_eac_inner_2" style="width:100%;">
  <tr>
    <td style="width:100%;">
      <select class="genders">
        <option></option>
        <option>female</option>
        <option>male</option>
        <option>other</option>
      </select>
    </td>
  </tr>
  <tr>
    <td style="width:100%;">
    <label>Associated dates (if applicable)</label>
      <label style="display:inline;">From</label>
      <input class="genderDatesFrom" type="text"/>
      <label style="display:inline;">To</label>
      <input class="genderDatesTo" type="text"/>
    </td>
  </tr>
  </table>
  </td>
  </tr>

  <tr class="insert_before" style="display:none;">
    <td></td>
  </tr>

  <script>
    $("input.add_empty_gender").one('click', function () {
        var rm = "<input type=\"button\" name=\"rm\" value=\"Delete Entry\" class=\"rm_empty_element rm_empty_gender pure-button pure-button-secondary\" style=\"border:none;\"/>";
        $(this).after(rm);
        $("input.rm_empty_gender").on('click', function () {
        $(".new_element:last").remove();
      });
    });
    $("input.add_empty_gender").on('click', function () {
      var tr = "<tr class=\"new_element multilvl\"><td><table style=\"width:100%;\"><tr><td style=\"width:100%;\"><select class=\"genders\"><option></option><option>female</option><option>male</option><option>other</option></select></td></tr><tr class=\"new_element\"><td><label>Associated dates</label><label style=\"display:inline;\">From </label><input class=\"genderDatesFrom\" type=\"text\" /><label style=\"display:inline;\"> To </label><input class=\"genderDatesTo\" type=\"text\"/></table></td></tr>";
      $(this).closest("tr").siblings(".insert_before").before(tr);
    });
  </script>
  </table>
  </td>
  </tr>
  <tr>
    <td>
      <label class="multi">Languages <span style="font-style:italic;"></span></label>
    </td>
  </tr>
  <tr>
  <td>
  <table class="new_eac_inner">
  <!--
  <tr>
    <td>
      <label class="multi">Languages <span style="font-style:italic;"></span></label>
    </td>
  </tr>
  -->
  <tr>
    <td>
      <input type="button" name="addLang" value="Add New Entry" class="add_empty_element add_empty_lang pure-button pure-button-secondary" style="border:none;"/>
    </td>
  </tr>
  <tr>
    <td>
      <label style="display:inline;">Name </label>
      <input type="text" class="lang langNames"/>
      <label style="display:inline;">Code <span style="font-style:italic;">(abc) </span></label>
      <input type="text" class="lang langCodes"/>
    </td>
  </tr>

  <tr class="insert_before" style="display:none;">
    <td></td>
  </tr>

  <script>
    $("input.add_empty_lang").one('click', function () {
        var rm = "<input type=\"button\" name=\"rm\" value=\"Delete Entry\" class=\"rm_empty_element rm_empty_lang pure-button pure-button-secondary\" style=\"border:none;\"/>";
        $(this).after(rm);
        $("input.rm_empty_lang").on('click', function () {
        $(".new_element:last").remove();
      });
    });
    $("input.add_empty_lang").on('click', function () {
      var tr = "<tr class=\"new_element\"><td><label style=\"display:inline;\">Name </label><input type=\"text\" class=\"langNames\" name=\"new_lang_name\" value=\"\"/><label style=\"display:inline;\"> Code <span style=\"font-style:italic;\">(abc) </span></label><input type=\"text\" class=\"langCodes\" name=\"new_lang_code\" value=\"\" /></td></tr>";
      $(this).closest("tr").siblings(".insert_before").before(tr);
    });
  </script>
  </table>
  </td>
  </tr>
  <tr>
    <td>
      <label class="multi">Subjects <span style="font-style:italic;"></span></label>
    </td>
  </tr>
  <tr>
  <td>
  <table class="new_eac_inner">
  <tr>
    <td>
      <input type="button" name="addSubject" value="Add New Entry" class="add_empty_element add_empty_subj pure-button pure-button-secondary" style="border:none;"/>
    </td>
  </tr>
  <tr>
    <td>
      <input type="text" size="65" class="subjects"/>
    </td>
  </tr>

  <tr class="insert_before" style="display:none;">
    <td></td>
  </tr>

  <script>
    $("input.add_empty_subj").one('click', function () {
        var rm = "<input type=\"button\" name=\"rm\" value=\"Delete Entry\" class=\"rm_empty_element rm_empty_subj pure-button pure-button-secondary\" style=\"border:none;\"/>";
        $(this).after(rm);
        $("input.rm_empty_subj").on('click', function () {
        $(".new_element:last").remove();
      });
    });
    $("input.add_empty_subj").on('click', function () {
      var tr = "<tr class=\"new_element\"><td><input type=\"text\" size=\"65\" class=\"subjects\"/></td></tr>";
      $(this).closest("tr").siblings(".insert_before").before(tr);
    });
  </script>
  </table>
  </td>
  </tr>
  <tr>
    <td>
      <label class="multi">Genres <span style="font-style:italic;"></span></label>
    </td>
  </tr>
  <tr>
  <td>
  <table class="new_eac_inner">
  <tr>
    <td>
      <input type="button" name="addGenre" value="Add New Entry" class="add_empty_element add_empty_genre pure-button pure-button-secondary" style="border:none;"/>
    </td>
  </tr>
  <tr>
    <td>
      <input type="text" size="65" class="genres"/>
    </td>
  </tr>

  <tr class="insert_before" style="display:none;">
    <td></td>
  </tr>

  <script>
    $("input.add_empty_genre").one('click', function () {
        var rm = "<input type=\"button\" name=\"rm\" value=\"Delete Entry\" class=\"rm_empty_element rm_empty_genre pure-button pure-button-secondary\" style=\"border:none;\"/>";
        $(this).after(rm);
        $("input.rm_empty_genre").on('click', function () {
        $(".new_element:last").remove();
      });
    });
    $("input.add_empty_genre").on('click', function () {
      var tr = "<tr class=\"new_element\"><td><input type=\"text\" size=\"65\" class=\"genres\"/></td></tr>";
      $(this).closest("tr").siblings(".insert_before").before(tr);
    });
  </script>
  </table>
  </td>
  </tr>
  <tr>
    <td>
      <label class="multi">Occupations or fields of activity and associated dates <span style="font-style:italic;"></span></label>
    </td>
  </tr>
  <tr>
  <td>
  <table class="new_eac_inner">
  <tr>
    <td>
      <input type="button" name="addOccu" value="Add New Entry" class="add_empty_element add_empty_occu pure-button pure-button-secondary" style="border:none;"/>
    </td>
  </tr>
  <tr class="multilvl">
  <td>
  <table class="new_eac_inner_2">
  <tr>
    <td>
      <label>Occupation or activity</label>
      <input type="text" size="65" class="occupations"/>
    </td>
  </tr>
  <tr>
    <td>
    <label>Associated dates</label>
      <label style="display:inline;">From</label>
      <input class="occuDatesFrom" type="text"/>
      <label style="display:inline;">To</label>
      <input class="occuDatesTo" type="text"/>
    </td>
  </tr>
  </table>
  </td>
  </tr>

  <tr class="insert_before" style="display:none;">
    <td></td>
  </tr>

  <script>
    $("input.add_empty_occu").one('click', function () {
        var rm = "<input type=\"button\" name=\"rm\" value=\"Delete Entry\" class=\"rm_empty_element rm_empty_occu pure-button pure-button-secondary\" style=\"border:none;\"/>";
        $(this).after(rm);
        $("input.rm_empty_occu").on('click', function () {
        $(".new_element:last").remove();
      });
    });
    $("input.add_empty_occu").on('click', function () {
      var tr = "<tr class=\"new_element multilvl\"><td><table><tr><td><label>Occupation or activity</label><input type=\"text\" size=\"65\" class=\"occupations\"/></td></tr><tr class=\"new_element\"><td><label>Associated dates</label><label style=\"display:inline;\">From </label><input class=\"occuDatesFrom\" type=\"text\" /><label style=\"display:inline;\"> To </label><input class=\"occuDatesTo\" type=\"text\"/></table></td></tr>";
      $(this).closest("tr").siblings(".insert_before").before(tr);
    });
  </script>
  </table>
  </td>
  </tr>
  <tr>
    <td>
      <label class="multi">Places and associated dates <span style="font-style:italic;"></span></label>
    </td>
  </tr>
  <tr>
  <td>
  <table class="new_eac_inner">
  <tr>
    <td>
      <input type="button" name="addPlace" value="Add New Entry" class="add_empty_element add_empty_place pure-button pure-button-secondary" style="border:none;"/>
    </td>
  </tr>
  <tr class="multilvl">
  <td>
  <table class="new_eac_inner_2">
  <tr>
    <td>
      <label>Place</label>
      <input type="text" size="65" class="placeEntries"/>
      <label>Place role</label>
      <input type="text" size="65" class="placeRoles"/>
    </td>
  </tr>
  <tr>
    <td>
    <label>Associated dates</label>
      <label style="display:inline;">From</label>
      <input class="placeDatesFrom" type="text"/>
      <label style="display:inline;">To</label>
      <input class="placeDatesTo" type="text"/>
    </td>
  </tr>
  </table>
  </td>
  </tr>

  <tr class="insert_before" style="display:none;">
    <td></td>
  </tr>

  <script>
    $("input.add_empty_place").one('click', function () {
        var rm = "<input type=\"button\" name=\"rm\" value=\"Delete Entry\" class=\"rm_empty_element rm_empty_place pure-button pure-button-secondary\" style=\"border:none;\"/>";
        $(this).after(rm);
        $("input.rm_empty_place").on('click', function () {
        $(".new_element:last").remove();
      });
    });
    $("input.add_empty_place").on('click', function () {
      var tr = "<tr class=\"new_element multilvl\"><td><table><tr><td><label>Place</label><input type=\"text\" size=\"65\" class=\"placeEntries\"/><label>Place role</label><input type=\"text\" size=\"65\" class=\"placeRoles\"/></td></tr><tr class=\"new_element\"><td><label>Associated dates</label><label style=\"display:inline;\">From </label><input class=\"placeDatesFrom\" type=\"text\" /><label style=\"display:inline;\"> To </label><input class=\"placeDatesTo\" type=\"text\"/></table></td></tr>";
      $(this).closest("tr").siblings(".insert_before").before(tr);
    });
  </script>
  </table>
  </td>
  </tr>
  <tr>
    <td>
      <label class="multi">Biography or history <span style="font-style:italic;"></span></label>
    </td>
  </tr>
  <tr>
  <td>
  <table class="new_eac_inner">
  <tr>
    <td>
      <label class="multi">Abstract <span style="font-style:italic;"></span></label>
    </td>
  </tr>
  <tr>
    <td>
      <textarea cols="65" style="height:100px; margin-left:0; margin-bottom:1%; font-size:1em;" class="abstract"></textarea>
    </td>
  </tr>
  <tr>
    <td>
      <label class="multi">Bio/history <span style="font-style:italic;">(wrap new paragraphs in &lt;p&gt; tags)</span></label>
    </td>
  </tr>
  <tr>
    <td>
      <textarea cols="65" style="margin-left:0; margin-bottom:1%; font-size:1em;" class="bioghist"></textarea>
    </td>
  </tr>
  </table>
  </td>
  </tr>
  <tr>
    <td>
      <label class="multi">Citations <span style="font-style:italic;"></span></label>
    </td>
  </tr>
  <tr>
  <td>
  <table class="new_eac_inner">
  <tr>
    <td>
      <input type="button" name="addCite" value="Add New Entry" class="add_empty_element add_empty_cite pure-button pure-button-secondary" style="border:none;"/>
    </td>
  </tr>
  <tr>
    <td>
      <input type="text" size="65" class="citations"/>
    </td>
  </tr>

  <tr class="insert_before" style="display:none;">
    <td></td>
  </tr>

  <script>
    $("input.add_empty_cite").one('click', function () {
        var rm = "<input type=\"button\" name=\"rm\" value=\"Delete Entry\" class=\"rm_empty_element rm_empty_cite pure-button pure-button-secondary\" style=\"border:none;\"/>";
        $(this).after(rm);
        $("input.rm_empty_cite").on('click', function () {
        $(".new_element:last").remove();
      });
    });
    $("input.add_empty_cite").on('click', function () {
      var tr = "<tr class=\"new_element\"><td><input type=\"text\" size=\"65\" class=\"citations\"/></td></tr>";
      $(this).closest("tr").siblings(".insert_before").before(tr);
    });
  </script>
  </table>
  </td>
  </tr>
  <tr>
    <td>
      <label class="multi">Related entities <span style="font-style:italic;"></span></label>
    </td>
  </tr>
  <tr>
  <td>
  <table class="new_eac_inner">
  <tr>
    <td>
      <input type="button" name="addCpf" value="Add New Entry" class="add_empty_element add_empty_cpf pure-button pure-button-secondary" style="border:none;"/>
    </td>
  </tr>
  <tr>
    <td>
      <input type="text" size="65" class="cpfs"/>
      <label>Unique identifier <span style="font-style:italic;"></span></label>
      <input type="text" class="cpfIDs"/>
      <label>Note <span style="font-style:italic;"></span></label>
      <input type="text" class="cpfNotes" size="65"/>
    </td>
  </tr>

  <tr class="insert_before" style="display:none;">
    <td></td>
  </tr>

  <script>
    $("input.add_empty_cpf").one('click', function () {
        var rm = "<input type=\"button\" name=\"rm\" value=\"Delete Entry\" class=\"rm_empty_element rm_empty_cpf pure-button pure-button-secondary\" style=\"border:none;\"/>";
        $(this).after(rm);
        $("input.rm_empty_cpf").on('click', function () {
        $(".new_element:last").remove();
      });
    });
    $("input.add_empty_cpf").on('click', function () {
      var tr = "<tr class=\"new_element\"><td><input type=\"text\" size=\"65\" class=\"cpfs\"/><label>Unique identifier <span style=\"font-style:italic;\"></span></label><input type=\"text\" class=\"cpfIDs\"/><label>Note <span style=\"font-style:italic;\"></span></label><input type=\"text\" class=\"cpfNotes\" size=\"65\"/></td></tr>";
      $(this).closest("tr").siblings(".insert_before").before(tr);
    });
  </script>
  </table>
  </td>
  </tr>
  <tr>
    <td>
      <label class="multi">Related resources <span style="font-style:italic;"></span></label>
    </td>
  </tr>
  <tr>
  <td>
  <table class="new_eac_inner">
  <tr>
    <td>
      <input type="button" name="addRes" value="Add New Entry" class="add_empty_element add_empty_res pure-button pure-button-secondary" style="border:none;"/>
    </td>
  </tr>
  <tr>
    <td>
      <input type="text" size="65" class="resources"/>
      <label>Unique identifier <span style="font-style:italic;"></span></label>
      <input type="text" class="resourceIDs"/>
      <label>Note <span style="font-style:italic;"></span></label>
      <input type="text" class="resourceNotes" size="65"/>
    </td>
  </tr>

  <tr class="insert_before" style="display:none;">
    <td></td>
  </tr>

  <script>
    $("input.add_empty_res").one('click', function () {
        var rm = "<input type=\"button\" name=\"rm\" value=\"Delete Entry\" class=\"rm_empty_element rm_empty_res pure-button pure-button-secondary\" style=\"border:none;\"/>";
        $(this).after(rm);
        $("input.rm_empty_res").on('click', function () {
        $(".new_element:last").remove();
      });
    });
    $("input.add_empty_res").on('click', function () {
      var tr = "<tr class=\"new_element\"><td><input type=\"text\" size=\"65\" class=\"resources\" name=\"new_resource\" value=\"\"/><label>Unique identifier <span style=\"font-style:italic;\"></span></label><input type=\"text\" class=\"resourceIDs\"/><label>Note <span style=\"font-style:italic;\"></span></label><input type=\"text\" class=\"resourceNotes\" size=\"65\"/></td></tr>";
      $(this).closest("tr").siblings(".insert_before").before(tr);
    });
  </script>
  </table>
  </td>
  </tr>
  <tr>
    <td>
      <label class="multi">Sources <span style="font-style:italic;"></span></label>
    </td>
  </tr>
  <tr>
  <td>
  <table class="new_eac_inner">
  <tr>
    <td>
      <input type="button" name="addRes" value="Add New Entry" class="add_empty_element add_empty_sour pure-button pure-button-secondary" style="border:none;"/>
    </td>
  </tr>
  <tr>
    <td>
      <input type="text" size="65" class="sources"/>
    </td>
  </tr>

  <tr class="insert_before" style="display:none;">
    <td></td>
  </tr>

  <script>
    $("input.add_empty_sour").one('click', function () {
        var rm = "<input type=\"button\" name=\"rm\" value=\"Delete Entry\" class=\"rm_empty_element rm_empty_sour pure-button pure-button-secondary\" style=\"border:none;\"/>";
        $(this).after(rm);
        $("input.rm_empty_sour").on('click', function () {
        $(".new_element:last").remove();
      });
    });
    $("input.add_empty_sour").on('click', function () {
      var tr = "<tr class=\"new_element\"><td><input type=\"text\" size=\"65\" class=\"sources\"/></td></tr>";
      $(this).closest("tr").siblings(".insert_before").before(tr);
    });
  </script>
  </table>
  </td>
  </tr>
  </table>
  </form>
  </td>
  </tr>
  <tr>
    <td>
      <button id="submit_new" class="pure-button pure-button-primary">Create</button>
    </td>
  </tr>
  </table>



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

  var lobjFormElements = [];
  lobjFormElements['genders'] = [];
  lobjFormElements['genderDatesFrom'] = [];
  lobjFormElements['genderDatesTo'] = [];
  lobjFormElements['langNames'] = [];
  lobjFormElements['langCodes'] = [];
  lobjFormElements['subjects'] = [];
  lobjFormElements['genres'] = [];
  lobjFormElements['occupations'] = [];
  lobjFormElements['occuDatesFrom'] = [];
  lobjFormElements['occuDatesTo'] = [];
  lobjFormElements['placeEntries'] = [];
  lobjFormElements['placeRoles'] = [];
  lobjFormElements['placeDatesFrom'] = [];
  lobjFormElements['placeDatesTo'] = [];
  lobjFormElements['citations'] = [];
  lobjFormElements['cpfs'] = [];
  lobjFormElements['cpfIDs'] = [];
  lobjFormElements['cpfNotes'] = [];
  lobjFormElements['resources'] = [];
  lobjFormElements['resourceIDs'] = [];
  lobjFormElements['resourceNotes'] = [];
  lobjFormElements['sources'] = [];


  $('#submit_new').click(function() {
      $('#results').html('');

      $('.genders').each(function () {
          lobjFormElements['genders'].push($(this).val());
      });

      $('.genderDatesFrom').each(function () {
          lobjFormElements['genderDatesFrom'].push($(this).val());
      });

      $('.genderDatesTo').each(function () {
          lobjFormElements['genderDatesTo'].push($(this).val());
      });

      $('.langNames').each(function () {
          lobjFormElements['langNames'].push($(this).val());
      });

      $('.langCodes').each(function () {
          lobjFormElements['langCodes'].push($(this).val());
      });

      $('.subjects').each(function () {
          lobjFormElements['subjects'].push($(this).val());
      });

      $('.genres').each(function () {
          lobjFormElements['genres'].push($(this).val());
      });

      $('.occupations').each(function () {
          lobjFormElements['occupations'].push($(this).val());
      });

      $('.occuDatesFrom').each(function () {
          lobjFormElements['occuDatesFrom'].push($(this).val());
      });

      $('.occuDatesTo').each(function () {
          lobjFormElements['occuDatesTo'].push($(this).val());
      });

      $('.placeEntries').each(function () {
          lobjFormElements['placeEntries'].push($(this).val());
      });

      $('.placeRoles').each(function () {
          lobjFormElements['placeRoles'].push($(this).val());
      });

      $('.placeDatesFrom').each(function () {
          lobjFormElements['placeDatesFrom'].push($(this).val());
      });

      $('.placeDatesTo').each(function () {
          lobjFormElements['placeDatesTo'].push($(this).val());
      });

      $('.citations').each(function () {
          lobjFormElements['citations'].push($(this).val());
      });

      $('.cpfs').each(function () {
          lobjFormElements['cpfs'].push($(this).val());
      });

       $('.cpfIDs').each(function () {
          lobjFormElements['cpfIDs'].push($(this).val());
      });

      $('.cpfNotes').each(function () {
          lobjFormElements['cpfNotes'].push($(this).val());
      });

      $('.resources').each(function () {
          lobjFormElements['resources'].push($(this).val());
      });

      $('.resourceIDs').each(function () {
          lobjFormElements['resourceIDs'].push($(this).val());
      });

      $('.resourceNotes').each(function () {
          lobjFormElements['resourceNotes'].push($(this).val());
      });

      $('.sources').each(function () {
          lobjFormElements['sources'].push($(this).val());
      });

      $.post("save_new.php", {
        type: $('.entity_type').val(),
	    entity: $('.entity_type').val(),
	    name: $('.eac_name').val(),
	    from: $('.from').val(),
	    to: $('.to').val(),
	    genders: lobjFormElements['genders'],
	    genderDatesFrom: lobjFormElements['genderDatesFrom'],
	    genderDatesTo: lobjFormElements['genderDatesTo'],
	    langNames: lobjFormElements['langNames'],
	    langCodes: lobjFormElements['langCodes'],
	    subjects: lobjFormElements['subjects'],
	    genres: lobjFormElements['genres'],
	    occupations: lobjFormElements['occupations'],
	    occuDatesFrom: lobjFormElements['occuDatesFrom'],
	    occuDatesTo: lobjFormElements['occuDatesTo'],
	    placeEntries: lobjFormElements['placeEntries'],
	    placeRoles: lobjFormElements['placeRoles'],
	    placeDatesFrom: lobjFormElements['placeDatesFrom'],
	    placeDatesTo: lobjFormElements['placeDatesTo'],
	    abstract: $('.abstract').val(),
	    bioghist: $('.bioghist').val(),
	    citations: lobjFormElements['citations'],
	    cpfs: lobjFormElements['cpfs'],
	    cpfIDs: lobjFormElements['cpfIDs'],
	    cpfNotes: lobjFormElements['cpfNotes'],
	    resources: lobjFormElements['resources'],
	    resourceIDs: lobjFormElements['resourceIDs'],
	    resourceNotes: lobjFormElements['resourceNotes'],
	    sources: lobjFormElements['sources'],
      	dir : <?php echo  '"' . addslashes($ead_path) . '"'; ?>

	    }, function (data) {

	      $savedialog.html(data).dialog('open');

        if( data != 'A record with this name already exists.' )
        {
          function slowreload() {
            location.reload();
          }
          
          window.setTimeout(slowreload, 1000);
        }

      });

    });

</script>

<?php
include('footer.php');
?>