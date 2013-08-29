<?php
class XsltTransform {



  public static function transform($ead_dom, $ead_id,$parameters) {
    /*
      This function is used to perform the EAC to EAD XSLT transformation.

      -- Jamie
    */
    date_default_timezone_set('America/New_York');
    // PHP needs the default timezone to be set.


    $xslt = new XSLTProcessor();
    // Create a new XSLT processor

    $xslt->registerPHPFunctions();

      $xslt->setParameter('','pAgencyCode',$parameters['agencyCode']);
      $xslt->setParameter('','pAgencyName',$parameters['agencyName']);
      $xslt->setParameter('','pOtherAgencyCode',$parameters['otherAgencyCode']);
      $xslt->setParameter('','pDate',$parameters['standardDateTime']);
      $xslt->setParameter('','pRecordId', $ead_id);
      $xslt->setParameter('','pLocalURL',$parameters['localURL']);
      $xslt->setParameter('','pServerName',$parameters['serverName']);
      $xslt->setParameter('','pRepositoryOne',$parameters['repositoryOne']);
 	  $xslt->setParameter('','pRepositoryTwo',$parameters['repositoryTwo']);
	  $xslt->setParameter('','pEventDescDerive',$parameters['eventDescDerive']);
	  $xslt->setParameter('','pEventDescCreate',$parameters['eventDescCreate']);
	  $xslt->setParameter('','pEventDescRevise',$parameters['eventDescRevise']);
	  $xslt->setParameter('','pEventDescExport',$parameters['eventDescExport']);
	  $xslt->setParameter('','pEventDescRAMP',$parameters['eventDescRAMP']);

    // These are all XSLT parameters that allow us to push values to the transformation. These
    // should be changed to match your own instituions values.

    $xsl = new DomDocument();
    // Create a new XSLT DomDocument


    //$xsl_string-load('./xsl/ead2eac.xsl');
    // Load the XSLT as a string


    $xsl->load( dirname(dirname(__FILE__)) . '/xsl/ead2eac.xsl');
    // Load the string into the DOM


    $xslt->importStylesheet($xsl);
    // Send the stylesheet to the processor.


    // Get the result

    $xslt_result = $xslt->transformToXML( $ead_dom );
    // Perform the actual transformation.

    $clean_xslt = addslashes($xslt_result);
    // Make sure that an weird chars are taken care of.

    return $clean_xslt;

  }


}
?>