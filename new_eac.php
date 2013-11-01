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
  $('.scriptNames').val('Latin');
  $('.scriptCodes').val('Latn');
    
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
    <tr class="labelHeader">
      <td>
        <label class="multi">Entity type <span style="font-style:italic;"></span></label>
      </td>
     </tr>
    <tr>
    <td>
    <table class="new_eac_inner">
      <tr>
      <td>
      <select class="entity_type" data-validate="required">
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
  <tr class="labelHeader">
    <td>
      <label class="multi">Name and dates <span style="font-style:italic;"></span></label>
    </td>
  </tr>
  <tr>
  <td>
  <table class="new_eac_inner">
  <tr>
    <td>    
    <script>
    $( ".entity_type" ).change(function() {
        var str = "";
        $(this).children( "option:selected" ).each(function() {
            str += $( this ).text();
        });
        // Add person specific fields (e.g., gender).
        if ( str == 'Person' ) 
        {        
            $( "#persName" ).text( "Name of person (Last Name, First Name)" );
            $( "#new_eac_inner_class").addClass("new_eac_inner");
            $( "#genderFields" ).addClass("new_eac_inner_2");
            $( "#genderLabel").addClass("labelHeader");
            $( "#genderFields" ).html("<tr><td style=\"width:100%;\"><select class=\"genders\"><option></option><option>female</option><option>male</option><option>other</option></select></td></tr><tr><td style=\"width:100%;\"><label>Associated dates (if applicable)</label><label style=\"display:inline;\"> From </label><input class=\"genderDatesFrom\" type=\"text\"/><label style=\"display:inline;\"> To </label><input class=\"genderDatesTo\" type=\"text\"/></td></tr>");            
            $( "#genderLabel").html("<td><label class=\"multi\">Gender <span style=\"font-style:italic;\"></span></label></td>");
            $( "#genderButton").html("<td><input type=\"button\" name=\"addGender\" value=\"Add New Entry\" class=\"add_empty_element add_empty_gender pure-button pure-button-secondary\" style=\"border:none;\"/></td>");                        
            $("input.add_empty_gender").one('click', function () {
              var rm = "<input type=\"button\" name=\"rm\" value=\"Delete Entry\" class=\"rm_empty_element rm_empty_gender pure-button pure-button-secondary\" style=\"border:none;\"/>";
              $(this).after(rm);
              $("input.rm_empty_gender").on('click', function () {
                $(".new_element:last").remove();
              });
            });
          $("input.add_empty_gender").on('click', function () {
            var tr = "<tr class=\"new_element multilvl\"><td><table style=\"width:100%;\"><tr><td style=\"width:100%;\"><select class=\"genders\"><option></option><option>female</option><option>male</option><option>other</option></select></td></tr><tr><td><label>Associated dates (if applicable)</label><label style=\"display:inline;\">From </label><input class=\"genderDatesFrom\" type=\"text\"/><label style=\"display:inline;\"> To </label><input class=\"genderDatesTo\" type=\"text\"/></td></tr></table></td></tr>";
            $(this).closest("tr").siblings(".insert_before").before(tr);
          });
        }
        else if ( str == 'Corporate Body' )
        {
            $( "#persName" ).text( "Name of corporate body" );            
        }        
        else
        {
            $( "#persName" ).text( "Name of family" );            
        }
        }).trigger( "change" );                       
    </script>
      <label id="persName">Name</label>
      <input class="eac_name" type="text" size="50" data-validate="required"/>
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
  <tr id="genderLabel">
    
  </tr>
  <tr>
  <td>
  <table id="new_eac_inner_class">
  <tr id="genderButton">
    
  </tr>
  <tr class="multilvl">
  <td>
  <table id="genderFields" style="width:100%;">
  
  </table>
  </td>
  </tr>

  <tr class="insert_before" style="display:none;">
    <td></td>
  </tr>

  <script>
   
  </script>
  </table>
  </td>
  </tr>
  <tr class="labelHeader">
    <td>
      <label class="multi">Languages associated with this entity <span style="font-style:italic;"></span></label>
    </td>
  </tr>
  <tr>
  <td>
  <table class="new_eac_inner"> 
  <tr>
    <td>
      <input type="button" name="addLang" value="Add New Entry" class="add_empty_element add_empty_lang pure-button pure-button-secondary" style="border:none;"/>
    </td>
  </tr>
  <tr>
    <td>
      <label style="display:inline;">Language name </label>
      <input type="text" class="lang langNames"/>
      <label style="display:inline;">Language code <span style="font-style:italic;">(abc) </span></label>
      <input type="text" class="lang langCodes" size="4" data-validate="regex(^[a-z]{3}$,Should be a three-letter ISO 639-2 code)"/>      
    </td>
  </tr>
  <tr>
    <td>
      <label style="display:inline;">Script name <span style="font-style:italic;"></span></label>
      <input type="text" value="Latin" class="script scriptNames">
      <label style="display:inline;">Script code <span style="font-style:italic;">(Abcd) </span></label>
      <input type="text" class="script scriptCodes" size="5" value="Latn" data-validate="regex(^[A-Z]{1}[a-z]{3}$,Should be a four-letter ISO 15924 code)"/>
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
      var tr = "<tr class=\"new_element multilvl\"><td><table style=\"width:100%;\"><tr><td style=\"width:100%;\"><label style=\"display:inline;\">Language name </label><input type=\"text\" class=\"langNames\" name=\"new_lang_name\" value=\"\"/><label style=\"display:inline;\"> Language code <span style=\"font-style:italic;\">(abc) </span></label><input type=\"text\" class=\"langCodes\" name=\"new_lang_code\" value=\"\" size=\"4\" data-validate=\"regex(^[a-z]{3}$,Should be a three-letter ISO 639-2 code)\"/></td></tr><tr><td><label style=\"display:inline;\">Script name <span style=\"font-style:italic;\"></span></label><input type=\"text\" class=\"script scriptNames\" value=\"Latin\"/><label style=\"display:inline;\"> Script code <span style=\"font-style:italic;\">(Abcd) </span></label><input type=\"text\" class=\"script scriptCodes\" size=\"5\" value=\"Latn\" data-validate=\"regex(^[A-Z]{1}[a-z]{3}$,Should be a four-letter ISO 15924 code)\"/></td></tr></table></tr></td>";
      $(this).closest("tr").siblings(".insert_before").before(tr);
    });
  </script>
  </table>
  </td>
  </tr>
  <tr class="labelHeader">
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
  <tr class="labelHeader">
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
  <tr class="labelHeader">
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
      var tr = "<tr class=\"new_element multilvl\"><td><table><tr><td><label>Occupation or activity</label><input type=\"text\" size=\"65\" class=\"occupations\"/></td></tr><tr><td><label>Associated dates</label><label style=\"display:inline;\">From </label><input class=\"occuDatesFrom\" type=\"text\"/><label style=\"display:inline;\"> To </label><input class=\"occuDatesTo\" type=\"text\"/></td></tr></table></td></tr>";
      $(this).closest("tr").siblings(".insert_before").before(tr);
    });
  </script>
  </table>
  </td>
  </tr>
  <tr class="labelHeader">
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
      var tr = "<tr class=\"new_element multilvl\"><td><table><tr><td><label>Place</label><input type=\"text\" size=\"65\" class=\"placeEntries\"/><label>Place role</label><input type=\"text\" size=\"65\" class=\"placeRoles\"/></td></tr><tr><td><label>Associated dates</label><label style=\"display:inline;\">From </label><input class=\"placeDatesFrom\" type=\"text\"/><label style=\"display:inline;\"> To </label><input class=\"placeDatesTo\" type=\"text\"/></td></tr></table></td></tr>";
      $(this).closest("tr").siblings(".insert_before").before(tr);
    });
  </script>
  </table>
  </td>
  </tr>
  <tr class="labelHeader">
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
  <tr class="labelHeader">
    <td>
      <label class="multi">Citations for biography/history<span style="font-style:italic;"></span></label>
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
  <tr class="labelHeader">
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
    <td style="width:100%;">
      <label style="display:inline;">CPF relation type</label>
      <select class="cpfTypes">
        <option>associative</option>
        <option>identity</option>
        <option>hierarchical</option>
        <option>hierarchical-parent</option>
        <option>hierarchical-child</option>
        <option>temporal</option>
        <option>temporal-earlier</option>
        <option>temporal-later</option>
        <option>family</option>               
      </select>
    </td>
  </tr>
  <tr>
    <td>
      <input type="text" size="65" class="cpfs"/>
      <label>Unique identifier <span style="font-style:italic;">(@xml:id)</span></label>
      <input type="text" size="65" class="cpfIDs"/>
      <label>URI <span style="font-style:italic;">(@xlink:href)</span></label>
      <input type="text" size="65" class="cpfURIs"/>
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
      var tr = "<tr class=\"new_element multilvl\"><td><table style=\"width:100%;\"><tr><td style=\"width:100%;\"><label style=\"display:inline;\">CPF relation type </label><select class=\"cpfTypes\"><option>associative</option><option>identity</option><option>hierarchical</option><option>hierarchical-parent</option><option>hierarchical-child</option><option>temporal</option><option>temporal-earlier</option><option>temporal-later</option><option>family</option></select></td></tr><tr><td><input type=\"text\" size=\"65\" class=\"cpfs\"/><label>Unique identifier <span style=\"font-style:italic;\">(@xml:id)</span></label><input type=\"text\" size=\"65\" class=\"cpfIDs\"/><label> URI <span style=\"font-style:italic;\">(@xlink:href)</span></label><input type=\"text\" size=\"65\" class=\"cpfURIs\"/><label> Note <span style=\"font-style:italic;\"></span></label><input type=\"text\" class=\"cpfNotes\" size=\"65\"/></td></tr></table></td></tr>";
      $(this).closest("tr").siblings(".insert_before").before(tr);
    });
  </script>
  </table>
  </td>
  </tr>
  <tr class="labelHeader">
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
    <td style="width:100%;">
      <label style="display:inline;">Resource relation type</label>
      <select class="resourceTypes">        
        <option>creatorOf</option>
        <option>subjectOf</option>
        <option>other</option>        
      </select>
    </td>
  </tr>
  <tr>
    <td>
      <input type="text" size="65" class="resources"/>
      <label>Unique identifier <span style="font-style:italic;">(@xml:id)</span></label>
      <input type="text" size="65" class="resourceIDs"/>
      <label>URI <span style="font-style:italic;">(@xlink:href)</span></label>
      <input type="text" size="65" class="resourceURIs"/>
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
      var tr = "<tr class=\"new_element multilvl\"><td><table style=\"width:100%;\"><tr><td style=\"width:100%;\"><label style=\"display:inline;\">Resource relation type </label><select class=\"resourceTypes\"><option>creatorOf</option><option>subjectOf</option><option>other</option></select></td></tr><tr><td><input type=\"text\" size=\"65\" class=\"resources\" name=\"new_resource\" value=\"\"/><label>Unique identifier <span style=\"font-style:italic;\">(@xml:id)</span></label><input type=\"text\" size=\"65\" class=\"resourceIDs\"/><label> URI <span style=\"font-style:italic;\">(@xlink:href)</span></label><input type=\"text\" size=\"65\" class=\"resourceURIs\"/><label> Note <span style=\"font-style:italic;\"></span></label><input type=\"text\" class=\"resourceNotes\" size=\"65\"/></td></tr></table></td></tr>";
      $(this).closest("tr").siblings(".insert_before").before(tr);
    });
  </script>
  </table>
  </td>
  </tr>
  <tr class="labelHeader">
    <td>
      <label class="multi">Sources for this record<span style="font-style:italic;"></span></label>
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
        <a href="#title" id="back">Back to top</a>
    
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
            jQuery('html,body').animate({scrollTop: 0},0);
          }
        }
    });

  var lobjFormElements = [];
  lobjFormElements['genders'] = [];
  lobjFormElements['genderDatesFrom'] = [];
  lobjFormElements['genderDatesTo'] = [];
  lobjFormElements['langNames'] = [];
  lobjFormElements['langCodes'] = [];
  lobjFormElements['scriptNames'] = [];
  lobjFormElements['scriptCodes'] = [];
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
  lobjFormElements['cpfTypes'] = [];
  lobjFormElements['cpfs'] = [];
  lobjFormElements['cpfIDs'] = [];
  lobjFormElements['cpfURIs'] = [];
  lobjFormElements['cpfNotes'] = [];
  lobjFormElements['resourceTypes'] = [];
  lobjFormElements['resources'] = [];
  lobjFormElements['resourceIDs'] = [];
  lobjFormElements['resourceURIs'] = [];
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
      
      $('.scriptNames').each(function () {
          lobjFormElements['scriptNames'].push($(this).val());
      });

      $('.scriptCodes').each(function () {
          lobjFormElements['scriptCodes'].push($(this).val());
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

      $('.cpfTypes').each(function () {
          lobjFormElements['cpfTypes'].push($(this).val());
      });

      $('.cpfs').each(function () {
          lobjFormElements['cpfs'].push($(this).val());
      });

      $('.cpfIDs').each(function () {
          lobjFormElements['cpfIDs'].push($(this).val());
      });
      
      $('.cpfURIs').each(function () {
          lobjFormElements['cpfURIs'].push($(this).val());
      });

      $('.cpfNotes').each(function () {
          lobjFormElements['cpfNotes'].push($(this).val());
      });
      
      $('.resourceTypes').each(function () {
          lobjFormElements['resourceTypes'].push($(this).val());
      });

      $('.resources').each(function () {
          lobjFormElements['resources'].push($(this).val());
      });

      $('.resourceIDs').each(function () {
          lobjFormElements['resourceIDs'].push($(this).val());
      });
      
      $('.resourceURIs').each(function () {
          lobjFormElements['resourceURIs'].push($(this).val());
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
	    scriptNames: lobjFormElements['scriptNames'],
	    scriptCodes: lobjFormElements['scriptCodes'],
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
	    cpfTypes: lobjFormElements['cpfTypes'],
	    cpfs: lobjFormElements['cpfs'],
	    cpfIDs: lobjFormElements['cpfIDs'],
	    cpfURIs: lobjFormElements['cpfURIs'],
	    cpfNotes: lobjFormElements['cpfNotes'],
	    resourceTypes: lobjFormElements['resourceTypes'],
	    resources: lobjFormElements['resources'],
	    resourceIDs: lobjFormElements['resourceIDs'],
	    resourceURIs: lobjFormElements['resourceURIs'],
	    resourceNotes: lobjFormElements['resourceNotes'],
	    sources: lobjFormElements['sources'],
      	dir : <?php echo  '"' . addslashes($ead_path) . '"'; ?>

	    }, function (data) {
          
	      $savedialog.html(data).dialog('open');	      

        if( data != 'A record with this name already exists.' && data != 'Record not saved. File name is empty.' && data != 'Record not saved. File name is empty. You must also choose an entity type.' && data != 'Record not saved. Must choose an entity type.' )
        {
        
          function slowreload() {
            location.reload();
            jQuery('html,body').animate({scrollTop: 0},0);
          }                    
          
          window.setTimeout(slowreload, 1000);
          
        }
          
      });
    
    });

</script>

<?php
include('footer.php');
?>