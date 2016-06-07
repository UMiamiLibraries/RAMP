<?php 
include('header.php');
?>

<div class="recordtitle-bkg">    
   <div class="recordtitle">
        <div class="inner-area"><h2 class="page-top-heading">Documentation</h2></div>
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
  <div class="content_box" id="docs_box">

  	<a name="worldcat1"></a> 
  	<h3>WorldCat Identities (Step 1 of 3)</h3>
  	<p>The list presented was retrieved from <a href="http://www.oclc.org/research/themes/data-science/identities.html" target="_blank">WorldCat Identities</a>. Once the best match is chosen, new elements will be automatically added to the <a href="http://www2.archivists.org/groups/technical-subcommittee-on-eac-cpf/encoded-archival-context-corporate-bodies-persons-and-families-eac-cpf" target="_blank">EAC-CPF</a> (Encoded Archival Context-Corporate bodies, Persons, and Families) record for any available works by, works about, and any related entities present in the WorldCat Identities record.</p>
  	<p>The <strong>Modify search</strong> function allows users to make changes to the original search string by editing the information in the input field. Name(s) should be entered in inverted order (Last Name, First Name) to improve the search query. Once the name is modified, clicking on <strong>Update results</strong> runs the entity search again.</p>
  	<p>Users can click on <strong>preview</strong> to check for an appropriate match on the WorldCat Identities page. In most cases, a page with an "lccn" in its URL is the best match. Choose the appropriate match by clicking on the radio button for the entity. Click <strong>Next</strong> to proceed, even if no match is found. Click <strong>Cancel</strong> to leave this page and go back to the last saved process.</p>


  	<a name="worldcat2" class="doc-anchor"></a>
  	<h3>WorldCat Identities (Step 2 of 3)</h3>
  	<p>The list of FAST (Faceted Application of Subject Terminology) headings presented was drawn from this entity’s WorldCat Identities page. Related subject headings can be added to the EAC-CPF (Encoded Archival Context-Corporate bodies, Persons, and Families) record using the checkboxes. These headings will be later transformed by the RAMP editor into wiki markup categories, and should be replaced with appropriate Wikipedia categories once the record is in Wikipedia. Categories can be entered in Wikipedia by using the HotCat tool. The Next button lets users move to the next step once a FAST heading is selected. Users can also Skip this step if adding related subjects is not desirable. Click Cancel to leave this page and go back to the last saved process.</p>

  	<h3 class="doc-anchor">WorldCat Identities (Step 3 of 3)</h3>
  	<p>See <a href="#savexml"><em>Save XML</em></a>.</p>


  	<a name="viaf1" class="doc-anchor"></a>
  	<h3>VIAF (Step 1 of 4)</h3>
  	<p>The purpose of this step is to get a unique identifier from the Virtual International Authority File (<a href="http://viaf.org/" target="_blank")>VIAF</a>) for the entity being searched. The <strong>Modify search</strong> function allows users to make changes to the original search string by editing the information in the input field. Name(s) should be entered in inverted order (Last Name, First Name) to improve the search query. Once the name is modified, clicking on <strong>Update results</strong> runs the entity search again.</p>
  	<p>Users can click on <strong>preview</strong> to check for an appropriate match on the VIAF page. Choose the appropriate match by clicking on the radio button. Click <strong>Next</strong> to proceed, even if no match is found. Click <strong>Cancel</strong> to leave this page and go back to the last saved process.</p>

  	
  	<a name="viaf2" class="doc-anchor"></a>
  	<h3>VIAF (Step 2 of 4)</h3>
  	<p>These strings have been extracted from the entity’s <a href="http://www2.archivists.org/groups/technical-subcommittee-on-eac-cpf/encoded-archival-context-corporate-bodies-persons-and-families-eac-cpf" target="_blank">EAC-CPF</a> (Encoded Archival Context-Corporate bodies, Persons, and Families) record or <a href="https://www.loc.gov/ead/" target="_blank">EAD</a> (Encoded Archival Description) finding aid in order to encode relationships to other entities.</p>
  	<p>The Modify search function allows users to make changes to the CPF relation elements. Once an element is modified, clicking on Update results runs the entity search again. Results can be expanded by clicking on the + sign icon to reveal the content associated with these strings. Users can click on <strong>preview</strong> to check for appropriate matches on the VIAF page, and make the selection using the checkboxes.</p>  	
  	<p>A new CPF relation can be added by entering the information in the input field <strong>Add New CPF Relation</strong> and clicking on the <strong>Add New</strong> button. Click <strong>Next</strong> to proceed, even if no match is found. Users can <strong>Skip</strong> this step if adding CPF relations is not desirable. Click Cancel to leave this page and go back to the last saved process</p>



  	<a name="viaf3" class="doc-anchor"></a>
  	<h3>VIAF (Step 3 of 4)</h3>
  	<p>If there are no appropriate matches in VIAF, users have the option of adding a custom CPF (Corporate bodies, Persons and Families) relation element using the original search string. When clicking the + sign icon, the following message will display for those entities that were not found:</p>
  	<p>There are no appropriate matches from VIAF. Add a CPF relation based on the original search string by ticking the checkbox for the name and selecting the Entity and Relation Types from the drop-down menus.</p>


  	<h3 class="doc-anchor">VIAF (Step 4 of 4)</h3>
  	<p>See <a href="#savexml"><em>Save XML</em></a>.</p>

  	
  	<a name="wiki1" class="doc-anchor"></a>
  	<h3>Wikipedia (Step 1 of 2)</h3>
  	<p>The purpose of this step is to search for an existing article for the entity in Wikipedia. New Wikipedia pages will take a day to show up in the index which gets updated once a day. </p>
  	<p>The Modify search function allows users to make changes to the original search string by editing the information in the input field. Once the name is modified, clicking on Update results runs the entity search again.</p>
  	<p>Users can click on <strong>preview</strong> to check for an appropriate match in Wikipedia, and select it by clicking on the radio button for the entity.</p>
  	<p>If no match is found, click the entry for <strong>No Match</strong> followed by the Next button to proceed to creating a new Wikipedia page. Click <strong>Cancel</strong> to leave this page and go back to the last saved process.</p>

  	
  	<a name="wiki2" class="doc-anchor"></a>
  	<h3>Wikipedia (Step 2 of 2)</h3>
  	<p>This screen presents the Wiki markup in the <strong>Local Article</strong> text area for the entity. If no entry is found in Wikipedia, move all the information from the <strong>Local Article</strong> box to the <strong>Wikipedia Article</strong> box using the commands Copy &amp; Paste. Click <strong>Save</strong> to store the Wiki markup in the database. <strong>Submit to Wikipedia as Draft</strong> allows users to create a draft subpage under their Wikipedia User Account. It is recommended to submit new pages as drafts when further editing is needed.</p>
  	<p>If a Wikipedia entry is found, the record can be enhanced using information from the <strong>Local Article</strong>. Information can be moved over using the commands Copy &amp; Paste. Click <strong>Save</strong> to store the Wiki markup in the database. <strong>Submit to Wikipedia</strong> to publish the additions to the existing Wikipedia article.</p>



  	<a name="savexml" class="doc-anchor"></a>
  	<h3>Save XML</h3>
  	<p>On this step, the XML can be examined and further changes/additions can be made to the file using the <strong>Edit XML</strong> button. The <strong>Save XML</strong> function allows users to work on a record in more than one session without losing previously entered information. Click <strong>Cancel</strong> to leave this page and go back to the last saved process.</p>
      
  </div>
</div>  


<?php
include('footer.php');  
?>
