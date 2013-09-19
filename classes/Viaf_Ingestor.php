<?php

//require inclusion of Ingestor class
require_once(dirname(__FILE__) . '/Ingestor.php');

/**
 * Viaf_Ingestor - extends Ingestor and defines other methods and properties for
 * ingestion of Viaf API
 *
 * @author dgonzalez
 * @copyright Copyright (c) 2013
 * @access public
 */
class Viaf_Ingestor extends Ingestor
{
	public $strViafID;
	public $objNameEntryNodeList;
	public $objSourceNode;
	public $objRelationsList;

	public function __construct()
	{
		parent::__construct();

		$this->strViafID = '';
		$this->objNameEntryNodeList = array();
		$this->objSourceNode = null;
		$this->objRelationsList = array();
	}

	/**
	 * Viaf_Ingestor::searchViaf() - search viaf and return json encoded search
	 * results list
	 *
	 * @param string $lstrName
	 * @return string/boolean
	 */
	public function searchViaf( $lstrName )
	{
		$lobjSearchResults = array();

		$this->strUrl = "http://viaf.org/viaf/search?query=local.names+all+\"$lstrName\"&httpAccept=text/xml&sortKeys=holdingscount";

		//curl option setup for this request
		curl_setopt($this->rscCurl, CURLOPT_URL, $this->strUrl );
		curl_setopt($this->rscCurl, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($this->rscCurl, CURLOPT_FOLLOWLOCATION, true);
		curl_setopt($this->rscCurl, CURLOPT_HEADER, false);

		$this->getResults();
		$this->createDom();

		$lobjResults = $this->xpath('//*[local-name()=\'record\']//*[local-name()=\'viafID\']');
		$lobjResults2 = $this->xpath('//*[local-name()=\'record\']//*[local-name()=\'mainHeadings\']//*[local-name()=\'data\'][1]//*[local-name()=\'text\']');

		if($lobjResults === FALSE || $lobjResults->length == 0)
			return FALSE;

		for($i = 0; $i < $lobjResults->length; $i++)
		{
			$lobjSearchResults[] = array( 'viaf_id' => $lobjResults->item($i)->nodeValue, 'name' =>  $lobjResults2->item($i)->nodeValue);
		}

		return json_encode($lobjSearchResults);
	}

	/**
	 * Viaf_Ingestor::createSource() - create source node
	 *
	 * @param string $lintViafId
	 * @return boolean
	 */
	public function createSource( $lintViafId )
	{
		$this->strViafID = $lintViafId;

		$this->objSourceNode = array(
							"attributes" => array( "xlink:href" => "VIAF-$this->strViafID",
												   "xlink:type" => "simple" )
							);
		return true;
	}

	/**
	 * Viaf_Ingestor::createNameEntryList() - collect data and create name entry
	 * objects and save them in appopriate property list
	 *
	 * @return boolean
	 */
	public function createNameEnrtyList()
	{
		$lobjNameEntryList = array();

		$this->strUrl = "http://viaf.org/viaf/$this->strViafID/rdf.xml";

		//curl option setup for this request
		curl_setopt($this->rscCurl, CURLOPT_URL, $this->strUrl );
		curl_setopt($this->rscCurl, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($this->rscCurl, CURLOPT_FOLLOWLOCATION, true);
		curl_setopt($this->rscCurl, CURLOPT_HEADER, false);

		$this->getResults();
		$this->createDom();

		$lobjConceptList = $this->xpath('//*[local-name()=\'Concept\']');

		//collect and save name entry lists
		foreach( $lobjConceptList as $lobjConcept )
		{
			$lobjInSchemeList = $this->xpath('.//*[local-name()=\'inScheme\']', $lobjConcept);

			$lobjInScheme = $lobjInSchemeList->item(0);
			$lobjSplit = explode( '/', $lobjInScheme->getAttribute('rdf:resource') );
			$lstrResource =  end( $lobjSplit );

			$lobjPrefList = $this->xpath('.//*[local-name()=\'prefLabel\']', $lobjConcept);

			//use name entry as key so same name entries group together and
			//resources are listed by name entry and authorized or alternative
			foreach($lobjPrefList as $lobjPref)
			{
				$lobjNameEntryList[$lobjPref->nodeValue]['authorizedForm'][] = $lstrResource;
			}

			$lobjAltList = $this->xpath('.//*[local-name()=\'altLabel\']', $lobjConcept);

			foreach($lobjAltList as $lobjAlt)
			{
				$lobjNameEntryList[$lobjAlt->nodeValue]['alternativeForm'][] = $lstrResource;
			}

		}

		//now go through name entry list and create NameEntry nodes and save them
		//to appropriate property list
		foreach($lobjNameEntryList as $lstrName => $lobjResources)
		{
			$lobjNameEntryNode = array();

			$lobjNameEntryNode['elements']['part'] = $lstrName;

			if(isset($lobjResources['authorizedForm']))
			{
				foreach($lobjResources['authorizedForm'] as $lstrResource)
				{
					$lobjNameEntryNode['elements']['authorizedForm'][] = array('elements' => $lstrResource);
				}
			}

			if(isset($lobjResources['alternativeForm']))
			{
				foreach($lobjResources['alternativeForm'] as $lstrResource)
				{
					$lobjNameEntryNode['elements']['alternativeForm'][] = array('elements' => $lstrResource);
				}
			}

			$this->objNameEntryNodeList[] = $lobjNameEntryNode;
		}

		return true;
	}

	/**
	 * Viaf_Ingestor::echoNameEntryAndSourceJsonData() - echo json encoded element
	 * name entry and source list
	 *
	 * @return void
	 */
	public function echoNameEntryAndSourceJsonData()
	{
		$lobjData = array();
		$lobjData['name_entry_list'] = $this->objNameEntryNodeList;
		$lobjData['source'] = $this->objSourceNode;

		echo json_encode($lobjData);
	}

	/**
	 * Viaf_Ingestor::createRelationsList() - collect and create relation objects,
	 * element lists, and save them into appropriate property list.
	 *
	 * @param array $lobjNames
	 * @return void
	 */
	public function createRelationsList($lobjNames)
	{
		foreach($lobjNames as $lstrName)
		{
		    $lstrOrigName = utf8_decode($lstrName);
			$lstrName = Ingestor::encodeForUrl($lstrName);
                
			$this->strUrl = "http://viaf.org/viaf/search?query=local.names+all+\"$lstrName\"&httpAccept=text/xml&sortKeys=holdingscount";

			//curl options setup for this request
			curl_setopt($this->rscCurl, CURLOPT_URL, $this->strUrl );
			curl_setopt($this->rscCurl, CURLOPT_RETURNTRANSFER, 1);
			curl_setopt($this->rscCurl, CURLOPT_FOLLOWLOCATION, true);
			curl_setopt($this->rscCurl, CURLOPT_HEADER, false);

			$this->getResults();

			//added because some xml entity is not being converted and causing weird characters
			$this->strResponse = str_replace( "&#x200D;", "", $this->strResponse);

			//there are some XML reference entities that exist in the Viaf search reponse XML which do not get
			//converted with the html_entity_decode function and therefore, we must decode them manually
			//commented out by dgonzalez. No longer issue because not using md5
			/*$this->strResponse = preg_replace_callback('/([a-zA-z])&#x301;/', array( $this, 'convertBadXMLEntities'), $this->strResponse );
			$this->strResponse = preg_replace_callback('/([a-zA-z])&#x300;/', array( $this, 'convertBadXMLEntities'), $this->strResponse );
			$this->strResponse = preg_replace_callback('/([a-zA-z])&#x303;/', array( $this, 'convertBadXMLEntities'), $this->strResponse );
			$this->strResponse = preg_replace_callback('/([a-zA-z])&#x308;/', array( $this, 'convertBadXMLEntities'), $this->strResponse );*/

			$this->createDom();

            // "[1]" XPath selector after "record" removed by timathom to allow for iterating over results.
			$lobjResult = $this->xpath('//*[local-name()=\'record\']//*[local-name()=\'viafID\']');
			$lobjResult2 = $this->xpath('//*[local-name()=\'record\']//*[local-name()=\'nameType\']');
			$lobjResult3 = $this->xpath('//*[local-name()=\'record\']//*[local-name()=\'mainHeadings\']/*[local-name()=\'data\']/*[local-name()=\'text\']');						

			if($lobjResult === FALSE || $lobjResult->length == 0)
			{
			    $lobjcpfRelation = array(
					   			"attributes" => array( "xmlns:xlink" => "http://www.w3.org/1999/xlink",
													   "xlink:arcrole" => "associatedWith",																   										  
													   "xlink:type" => "simple" ),
								"elements" => array( "relationEntry" => array (																																										
																		"elements" => $lstrOrigName
																		)
													)

								);
								$lstrKey = urldecode($lstrOrigName);
								$this->objRelationsList[$lstrKey] = $lobjcpfRelation;
			}
			
			
			
			
				//continue;
			else
			{					    
			    // Loop added by timathom to get full set of Named Entity Recognition results from VIAF.	   
			    for($i = 0; $i < $lobjResult->length; $i++)
		        {			    	   		            
				    $this->strViafID = $lobjResult->item($i)->nodeValue;
				    $lstrType = $lobjResult2->item($i)->nodeValue == 'Personal' ? 'Person' : 'CorporateBody';
				    $lstrResultName = $lobjResult3->item($i)->nodeValue;

				    $lobjcpfRelation = array(
					   			"attributes" => array( "xmlns:xlink" => "http://www.w3.org/1999/xlink",
													   "xlink:arcrole" => "associatedWith",
													   "xlink:role" => "http://RDVocab.info/uri/schema/FRBRentitiesRDA/" . $lstrType,
													   "xlink:type" => "simple" ),
								"elements" => array( "relationEntry" => array (
																		"attributes" => array( "xml:id" => "VIAF-$this->strViafID" ),
																		"elements" => $lstrResultName
																		)
													)

								);

				    //use this as key so that in the front end the user can choose
				    //which results they want and then the js can easily find
				    //chosen results based on key.
				    
				    $lstrKey = urldecode($lstrName) . ': ';
				    $lstrKey .= "<a target=\"_blank\" href =\"http://www.viaf.org/{$this->strViafID}/\">{$lstrResultName}</a>";
				    //$lstrKey .= ' (' . urldecode($lstrName) . ')';

				    $this->objRelationsList[$lstrKey] = $lobjcpfRelation;
		         }
			}    
		}
	}

	/**
	 * Viaf_Ingestor::echoRelationsJsonData() - echo json encode relation elements list
	 *
	 * @return void
	 */
	public function echoRelationsJsonData()
	{	    
		echo json_encode($this->objRelationsList);
	}
}

?>