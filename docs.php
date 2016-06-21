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
  	<p>Users can click on <strong>preview</strong> to check for an appropriate match on the WorldCat Identities page. In most cases, a page with an "lccn" in its URL is the best match. Choose the appropriate match by clicking on the radio button for the entity. Click <strong>Next</strong> to proceed after making the selection. Click <strong>Cancel</strong> to leave this screen and go back to the Homepage.</p>


  	<a name="worldcat2" class="doc-anchor"></a>
  	<h3>WorldCat Identities (Step 2 of 3)</h3>
  	<p>The list of FAST (Faceted Application of Subject Terminology) headings presented was drawn from this entity’s WorldCat Identities page. Related subject headings can be added to the <a href="http://www2.archivists.org/groups/technical-subcommittee-on-eac-cpf/encoded-archival-context-corporate-bodies-persons-and-families-eac-cpf">EAC-CPF</a> (Encoded Archival Context-Corporate bodies, Persons, and Families) record using the checkboxes. These headings will be transformed by the RAMP editor into wiki markup categories, and should be replaced with appropriate Wikipedia categories once the record is in Wikipedia. Categories can be entered in Wikipedia by using the <a href="https://en.wikipedia.org/wiki/Wikipedia:HotCat">HotCat</a> tool. The <strong>Next</strong> button lets users move to the next step once a FAST heading is selected. Users can also <strong>Skip</strong> this step if adding related subjects is not desirable. Click <strong>Cancel</strong> to leave this screen and go back to the Homepage. </p>

  	<h3 class="doc-anchor">WorldCat Identities (Step 3 of 3)</h3>
  	<p>See <a href="#savexml"><em>Save XML</em></a>.</p>


  	<a name="viaf1" class="doc-anchor"></a>
  	<h3>VIAF (Step 1 of 4)</h3>
  	<p>The purpose of this step is to get a unique identifier from the Virtual International Authority File (<a href="http://viaf.org/" target="_blank")>VIAF</a>) for the entity being searched.</p>

    <p>Users can click on <strong>preview</strong> to check for an appropriate match on the VIAF page. Choose the appropriate match by clicking on the radio button. Click <strong>Next</strong> to continue after making the selection. Click <strong>Cancel</strong> to leave this screen and go back to the Homepage.</p>

  	
  	<a name="viaf2" class="doc-anchor"></a>
  	<h3>VIAF (Step 2 of 4)</h3>
  	<p>These strings have been extracted from the entity’s <a href="http://www2.archivists.org/groups/technical-subcommittee-on-eac-cpf/encoded-archival-context-corporate-bodies-persons-and-families-eac-cpf" target="_blank">EAC-CPF</a> (Encoded Archival Context-Corporate bodies, Persons, and Families) record or <a href="https://www.loc.gov/ead/" target="_blank">EAD</a> (Encoded Archival Description) finding aid in order to encode relationships to other entities.</p>
  	<p>Users can make the selection using the checkboxes. A new CPF relation can be added by clicking on <strong>Add New CPF Relation</strong> and entering the information.</p>
    <p>Click <strong>Next</strong> to continue after making the selection. If adding CPF relations is not desirable, users can click on <strong>Skip</strong>. Click <strong>Cancel</strong> to leave this screen and go back to the Homepage.</p>



  	<a name="viaf3" class="doc-anchor"></a>
  	<h3>VIAF (Step 3 of 4)</h3>
  	<p>For help choosing the best match, click on a link which will take you to the VIAF page for the entity. If no match is found in VIAF, users have the option of adding a custom CPF (Corporate bodies, Persons and Families) relation element using the original search string. The following message will display for the entity that was not found:</p>
    <p><strong><em>No appropriate matches from VIAF? Add a CPF Relation using the original search string</em></strong></p>
  	<p>Select the element and choose the Entity and Relation Type. Click <strong>Cancel</strong> to leave this screen and go back to the Homepage.</p>


  	<h3 class="doc-anchor">VIAF (Step 4 of 4)</h3>
  	<p>See <a href="#savexml"><em>Save XML</em></a>.</p>

  	
  	<a name="wiki1" class="doc-anchor"></a>
  	<h3>Wikipedia (Step 1 of 2)</h3>
  	<p>The purpose of this step is to search for an existing article for the entity in Wikipedia. New Wikipedia pages will take a day to show up in the index which gets updated once a day.</p>
  	<p>Users can click on a link for help choosing the best match in Wikipedia. Click <strong>Next</strong> after selecting the entity. If the search doesn’t retrieve any relevant matches, users can enter the name in the search box in direct order (First Name Last Name) to run the search again. After this step, if there is still no appropriate match found, click the <strong>No Match (Create New)</strong> button which would allow for the creation of a new Wikipedia page. Click <strong>Cancel</strong> to leave this screen and go back to the Homepage.</p>

  	
  	<a name="wiki2" class="doc-anchor"></a>
  	<h3>Wikipedia (Step 2 of 2)</h3>
  	<p>This screen presents the Wiki markup in the <strong>Local Article</strong> text area for the entity. If no entry is found in Wikipedia, move all the information from the <strong>Local Article</strong> box to the <strong>Wikipedia Article</strong> box using the commands Copy &amp; Paste. <strong>Submit to Wikipedia as Draft</strong> allows users to create a draft subpage under their Wikipedia User Account. It is recommended to submit new pages as drafts when further editing is needed.</p>
  	<p>If a Wikipedia entry is found, the record can be enhanced using information from the <strong>Local Article</strong>. Information can be integrated to the existing article using the commands Copy &amp; Paste. Click <strong>Submit to Wikipedia</strong> to publish the additions to the existing Wikipedia article.</p>



  	<a name="savexml" class="doc-anchor"></a>
  	<h3>Save XML</h3>
  	<p>On this step, the XML can be examined and further changes/additions can be made to the file using the <strong>Edit XML</strong> button. The <strong>Save XML</strong> function allows users to work on a record in more than one session without losing previously entered information. Click <strong>Cancel</strong> to leave this screen and go back to the Homepage.</p>
      
  </div>
</div>  


<?php
include('footer.php');  
?>
