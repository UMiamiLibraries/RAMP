<?php

//require inclusion of Ingestor class
require_once(dirname(__FILE__) . '/Ingestor.php');

/**
 * WorldCat_Ingestor - extends Ingestor and defines other methods and properties for
 * ingestion of WorldCat API
 *
 * @author dgonzalez
 * @copyright Copyright (c) 2013
 * @access public
 */
class WorldCat_Ingestor extends Ingestor
{
	//WorlcCat contains codes for roles and this is used to decode in order to display
	public static $objRolesDecoder = array( "com" => "compiler", "edt" => "editor", "hnr" => "honoree", "trl" => "translator", "aui" => "author_of_introduction",
										"cmp" => "composer", "aus" => "author_of_screenplay", "oth" => "other", "ant" => "bibliographic_antecedent",
										"sgn" => "signer", "dte" => "dedicatee", "cre" => "creator", "ins" => "inscriber", "aud" => "author_of_dialog",
										"adp" => "adapter", "nrt" => "narrator", "ann" => "annotator", "spk" => "speaker", "lbt" => "librettist",
										"sce" => "scenarist", "fmo" => "former_owner", "pht" => "photographer", "hst" => "host", "cmm" => "commentator",
										"ccp" => "conceptor", "prf" => "performer");

	public $strRawName = '';
	public $strViafId = '';	
	public $strPNKey = '';
	public $strWikiTitle = '';	
	public $objWorksBy = array();
	public $objWorksAbout = array();
	public $objRelatedIdentites = array();
	public $objUsefulLinks = array();
	public $objAssociatedSubjects = array();
	public $objElementList = array();

	public function __construct()
	{
		parent::__construct();
	}
   
	/**
	 * WorldCat_Ingestor::searchWorldCat() - search WorldCat API for passed parameter and
	 * return results list (json encoded)
	 *
	 * @param string $lstrName
	 * @return string
	 */
	public function searchWorldCat( $lstrName )
	{
		$lobjSearchResults = array();

		$this->strUrl = "http://worldcat.org/identities/find?fullName=" . Ingestor::encodeForUrl($lstrName);

		//set curl options for this request
		curl_setopt($this->rscCurl, CURLOPT_URL, $this->strUrl );
		curl_setopt($this->rscCurl, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($this->rscCurl, CURLOPT_FOLLOWLOCATION, true);
		curl_setopt($this->rscCurl, CURLOPT_HEADER, false);

		$this->getResults();
		$this->createDom();

		//first get results with high scores and usage
		$lobjResults = $this->xpath('//*[local-name()=\'match\'][@score>=\'2000\']');

		//if no results have high scores and usage, do not apply filters
		if($lobjResults === FALSE || $lobjResults->length == 0)
		{
			$lobjResults = $this->xpath('//*[local-name()=\'match\']');

			if($lobjResults === FALSE || $lobjResults->length == 0)
				return FALSE;
		}

		//go through results and build search results list
		for($i = 0; $i < $lobjResults->length; $i++)
		{
			$lobjResults2 = $this->xpath('.//*[local-name()=\'establishedForm\']', $lobjResults->item($i));
			$lstrTitle = ($lobjResults2 === FALSE || $lobjResults2->length == 0) ? "" : $lobjResults2->item(0)->nodeValue;

			$lobjResults2 = $this->xpath('.//*[local-name()=\'uri\']', $lobjResults->item($i));
			$lstrUri = ($lobjResults2 === FALSE || $lobjResults2->length == 0) ? "" : $lobjResults2->item(0)->nodeValue;

			$lobjResults2 = $this->xpath('.//*[local-name()=\'key\']', $lobjResults->item($i));
			$lstrKey = ($lobjResults2 === FALSE || $lobjResults2->length == 0) ? "" : $lobjResults2->item(0)->nodeValue;

			$lobjResults2 = $this->xpath('.//*[local-name()=\'nameType\']', $lobjResults->item($i));
			$lstrType = ($lobjResults2 === FALSE || $lobjResults2->length == 0) ? "" : $lobjResults2->item(0)->nodeValue;

			$lobjSearchResults[] = array( 'title' => $lstrTitle, 'uri' =>  "http://worldcat.org$lstrUri",
											'key' => $lstrKey, 'type' => $lstrType );
		}

		return json_encode($lobjSearchResults) ;
	}

	/**
	 * WorldCat_Ingestor::collectData() - given the uri of the WorldCat identity, collect all desired data
	 *
	 * @param string $lstrUri
	 * @return boolean
	 */
	public function collectData( $lstrUri )
	{
		//replace spaces
		$lstrUri = preg_replace( '/\s/', '%20', $lstrUri );

		$this->strUrl = $lstrUri . "/identity.xml";

		//setup curl options for this request
		curl_setopt($this->rscCurl, CURLOPT_URL, $this->strUrl );
		curl_setopt($this->rscCurl, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($this->rscCurl, CURLOPT_FOLLOWLOCATION, true);
		curl_setopt($this->rscCurl, CURLOPT_HEADER, false);

		$this->getResults();

		//added because some xml entity is not being converted and causing weird characters
		$this->strResponse = str_replace( "&#x200D;", "", $this->strResponse);

		//there are some XML reference entities that exist in the WorldCat reponse XML which do not get
		//converted with the html_entity_decode function and therefore, we must decode them manually
		//commented out by dgonzalez. No longer issue because not using md5
		/*$this->strResponse = preg_replace_callback('/([a-zA-z])&#x301;/', array( $this, 'convertBadXMLEntities'), $this->strResponse );
		$this->strResponse = preg_replace_callback('/([a-zA-z])&#x300;/', array( $this, 'convertBadXMLEntities'), $this->strResponse );
		$this->strResponse = preg_replace_callback('/([a-zA-z])&#x303;/', array( $this, 'convertBadXMLEntities'), $this->strResponse );
		$this->strResponse = preg_replace_callback('/([a-zA-z])&#x308;/', array( $this, 'convertBadXMLEntities'), $this->strResponse );*/

		$this->createDom();

		//collect all desired data
		$this->collectSubjects();
		$this->collectAssociatedNames();
		$this->collectUsefulLinks();
		$this->collectWorks("by");
		$this->collectWorks("about");

		return TRUE;
	}

	/**
	 * WorldCat_Ingestor::createElements() - create element list for XML ingestion
	 *
	 * @return boolean
	 */
	public function createElements()
	{
	    $this->createLinkElements();
		$this->createSubjectElements();
		$this->createCPFRelationsElements();
		$this->createResourceRelationsElements();

		return TRUE;
	}

	/**
	 * WorldCat_Ingestor::echoJsonElementsList() - echo about json decoded element list
	 *
	 * @return void
	 */
	public function echoJsonElementsList()
	{
		echo json_encode( $this->objElementList );
	}

	/**
	 * WorldCat_Ingestor::collectSubjects() - collect and build associated subject
	 * objects from WorldCat API and save it to appropriate property list
	 *
	 * @return boolean/void
	 */
	private function collectSubjects()
	{
		$lobjResults = $this->xpath('//*[local-name()=\'fast\']');

		if($lobjResults === FALSE || $lobjResults->length == 0)
			return FALSE;

		for($i = 0; $i < $lobjResults->length; $i++)
		{
			$lobjSubject = array();
			$lobjSubject['name'] = $lobjResults->item($i)->nodeValue;
			$lobjSubject['id'] = $lobjResults->item($i)->getAttribute('norm');
			$lobjSubject['type'] = $lobjResults->item($i)->getAttribute('tag');

			$this->objAssociatedSubjects[] = $lobjSubject;
		}
	}

	/**
	 * WorldCat_Ingestor::collectAssociatedNames() - collect and build associated names
	 * objects from WorldCat API and save it to appropriate property list
	 *
	 * @return boolean/void
	 */
	private function collectAssociatedNames()
	{
		$lobjResults = $this->xpath('//*[local-name()=\'associatedNames\']//*[local-name()=\'name\']');

		if($lobjResults === FALSE || $lobjResults->length == 0)
			return FALSE;

		for($i = 0; $i < $lobjResults->length; $i++)
		{
			$lobjAssociatedIdentity = array();
			$lobjAssociatedIdentity['name'] = '';
			$lobjAssociatedIdentity['id'] = '';
			$lobjAssociatedIdentity['type'] = '';

			$lobjResults2 = $this->xpath('./*[local-name()=\'normName\']', $lobjResults->item($i));
			if($lobjResults2->item(0) != null)
				$lobjAssociatedIdentity['id'] = $lobjResults2->item(0)->nodeValue;

			$lobjResults2 = $this->xpath('./*[local-name()=\'relator\']', $lobjResults->item($i));

			//if role has been decoded in class property, save has decoded. If not, save encoded.
			if($lobjResults2->item(0) != null)
				$lobjAssociatedIdentity['type'] = isset(self::$objRolesDecoder[$lobjResults2->item(0)->nodeValue]) ?
				self::$objRolesDecoder[$lobjResults2->item(0)->nodeValue] : $lobjResults2->item(0)->nodeValue;

			$lobjResults2 = $this->xpath('./*[local-name()=\'rawName\']/*[local-name()=\'suba\']', $lobjResults->item($i));
			if($lobjResults2->item(0) != null)
				$lobjAssociatedIdentity['name'] = $lobjResults2->item(0)->nodeValue;

			$lobjResults2 = $this->xpath('./*[local-name()=\'rawName\']/*[local-name()=\'subc\']', $lobjResults->item($i));
			if($lobjResults2->item(0) != null)
				$lobjAssociatedIdentity['name'] .= is_null($lobjResults2->item(0)->nodeValue) ? "" : " " . $lobjResults2->item(0)->nodeValue;

			$lobjResults2 = $this->xpath('./*[local-name()=\'rawName\']/*[local-name()=\'subd\']', $lobjResults->item($i));
			if($lobjResults2->item(0) != null)
				$lobjAssociatedIdentity['name'] .= is_null($lobjResults2->item(0)->nodeValue) ? "" : " " . $lobjResults2->item(0)->nodeValue;

			$this->objRelatedIdentites[] = $lobjAssociatedIdentity;
		}
	}

	/**
	 * WorldCat_Ingestor::collectUsefulLinks() - collect and save useful links to
	 * appropriate property list
	 *
	 * @return boolean/void
	 */
	private function collectUsefulLinks()
	{
		$lobjResults = $this->xpath('//*[local-name()=\'authorityInfo\']/*[local-name()=\'viafid\']');

		if($lobjResults !== FALSE && $lobjResults->length > 0)
			$this->strViafId = $lobjResults->item(0)->nodeValue;

		$lobjResults = $this->xpath('//*[local-name()=\'pnkey\']');
		if($lobjResults !== FALSE && $lobjResults->length > 0)
			$this->strPNKey = $lobjResults->item(0)->nodeValue;

		$lobjResults = $this->xpath('//*[local-name()=\'wikiLink\']');

		if($lobjResults !== FALSE && $lobjResults->length > 0)
			$this->strWikiTitle = $lobjResults->item(0)->nodeValue;

        // Commented out because not currently needed for link collection. --timathom
		//$this->objUsefulLinks[] = "http://viaf.org/viaf/" . $this->strViafId;
		//$this->objUsefulLinks[] = "http://en.wikipedia.org/wiki/Special:Search?search=" . $this->strWikiTitle;

        /*
		if (strpos($this->strPNKey,'lccn-') !== false)
		{
			$this->objUsefulLinks[] = "http://errol.oclc.org/laf/" . str_replace( 'lccn-', '', $this->strPNKey ) . ".html";
		}				
        */
        		
        $lobjLink = array();
        $lobjLink['viaf'] = $this->strViafId;
		$lobjLink['lccn'] = $this->strPNKey;
		$lobjLink['wiki'] = $this->strWikiTitle;			

		$this->objUsefulLinks[] = $lobjLink;
					
	}

	/**
	 * WorldCat_Ingestor::collectWorks() - collect and build work objects from WorldCat API and save
	 * it to appropriate property list
	 *
	 * @param string $type
	 * @return boolean/void
	 */
	private function collectWorks( $type )
	{
		if( $this->strRawName == '' )
		{
			$lobjResults = $this->xpath('//*[local-name()=\'nameInfo\']//*[local-name()=\'suba\']');

			if($lobjResults !== FALSE && $lobjResults->length > 0)
			{
				$this->strRawName = $lobjResults->item(0)->nodeValue;
			}
		}

		//if type is not by or about, return because work type is not implemented
		if( !in_array( strtolower( $type ), array( "by", "about" ) ) )
			return;

		//xpath query built based on type parameter
		$lobjResults = $this->xpath('//*[local-name()=\'' . strtolower( $type ) . '\']/*[local-name()=\'citation\']');

		if($lobjResults !== FALSE && $lobjResults->length > 0)
		{
			for($i = 0; $i < $lobjResults->length; $i++)
			{
				$lobjWork = array();
				$lobjWork['creator_viaf'] = '';
				$lobjWork['creator'] = '';
				$lobjWork['title'] = '';
				$lobjWork['record_type'] = '';
				$lobjWork['isbn'] = '';
				$lobjWork['oclcnum'] = '';

				$lobjResults2 = $this->xpath('./*[local-name()=\'creator\']', $lobjResults->item($i));
				if($lobjResults2->item(0) != null)
					$lobjWork['creator'] = $lobjResults2->item(0)->nodeValue;

				$lobjResults2 = $this->xpath('./*[local-name()=\'title\']', $lobjResults->item($i));
				if($lobjResults2->item(0) != null)
					$lobjWork['title'] = $lobjResults2->item(0)->nodeValue;

				$lobjResults2 = $this->xpath('./*[local-name()=\'recordType\']', $lobjResults->item($i));
				if($lobjResults2->item(0) != null)
					$lobjWork['record_type'] = $lobjResults2->item(0)->nodeValue;

				$lobjResults2 = $this->xpath('./*[local-name()=\'oclcnum\']', $lobjResults->item($i));
				if($lobjResults2->item(0) != null)
					$lobjWork['oclcnum'] = $lobjResults2->item(0)->nodeValue;

				$lobjResults2 = $this->xpath('./*[local-name()=\'cover\']', $lobjResults->item($i));
				if($lobjResults2->item(0) != null)
					$lobjWork['isbn'] = $lobjResults2->item(0) !== null ? $lobjResults2->item(0)->getAttribute('isbn') : "";

				if( $lobjWork['creator'] == $this->strRawName )
					$lobjWork['creator_viaf'] = $this->strViafId;

				//based on type, store work object in appropriate property list
				if( $type == "about" )
					$this->objWorksAbout[] = $lobjWork;

				if( $type == "by" )
					$this->objWorksBy[] = $lobjWork;
			}
		}
	}

	/**
	 * WorldCat_Ingestor::createSubjectElements() - build subject nodes based on collected
	 * associated subjects list and save in element list property
	 *
	 * @return void
	 */
	private function createSubjectElements()
	{
		$lobjSubjectNode = array();

		foreach( $this->objAssociatedSubjects as $lobjSubject )
		{
			if( $lobjSubject['type'] != "")
				$lobjSubjectNode['attributes']['localType'] = $lobjSubject['type'];

			if( $lobjSubject['id'] != "" )
				$lobjSubjectNode['elements']['term']['attributes']['xml:id'] = $lobjSubject['id'];

			if( $lobjSubject['name'] != "" )
				$lobjSubjectNode['elements']['term']['elements'] = $lobjSubject['name'];

			$this->objElementList['subject'][] = $lobjSubjectNode;
		}
	}
	
	/**
	 * WorldCat_Ingestor::createLinkElements() - build link nodes based on collected
	 * useful links list and save in element list property
	 *
	 * @return void
	 */
	private function createLinkElements()
	{
		$lobjLinkNodeWiki = array();
		$lobjLinkNodeSource = array();
		$lobjLinkNodeLccn = array();
		$lobjLinkNodeViaf = array();

		foreach( $this->objUsefulLinks as $lobjLink )
		{											
		    if( $lobjLink['wiki'] != "" || $lobjLink['wiki']->length != 0) {		    
				$lobjLinkNodeWiki['attributes']['localType'] = "dbpedia"; 												
				$lobjLinkNodeWiki['elements'] = "WCI:" . "dbpedia:http://dbpedia.org/resource/" . $lobjLink['wiki']; 	
				$this->objElementList['otherRecordId'][] = $lobjLinkNodeWiki;						
			}
			
			if( $lobjLink['lccn'] != "" || $lobjLink['lccn']->length != 0) {		    
				$lobjLinkNodeSource['attributes']['xlink:href'] = "http://worldcat.org/identities/" . $lobjLink['lccn'] . "/identity.xml";		
				$lobjLinkNodeSource['attributes']['xlink:type'] = "simple";
				$this->objElementList['source'][] = $lobjLinkNodeSource;
				
				if (strpos($lobjLink['lccn'],'lccn-') === false) {
				    $lobjLinkNodeLccn['attributes']['localType'] = "WCI";
				} else {
				    $lobjLinkNodeLccn['attributes']['localType'] = "lccn";
				}								
				
				$lobjLinkNodeLccn['elements'] = "WCI:" . $lobjLink['lccn'];
				$this->objElementList['otherRecordId'][] = $lobjLinkNodeLccn;				
			}
				
			if( $lobjLink['viaf'] != "" || $lobjLink['viaf']->length != 0) {
			    $lobjLinkNodeViaf['attributes']['localType'] = "VIAFId";
				$lobjLinkNodeViaf['elements'] = "VIAFId:" . $lobjLink['viaf'];
				$this->objElementList['otherRecordId'][] = $lobjLinkNodeViaf;
			}				
		}
	}			

	/**
	 * WorldCat_Ingestor::createCPFRelationsElements() - build cpfRelation nodes
	 * based on collected associated names list and save in element list property
	 *
	 * @return void
	 */
	private function createCPFRelationsElements()
	{
		foreach( $this->objRelatedIdentites as $lobjIdentity )
		{
			$lobjCPFRelationNode = array();

			//if the id does not start with 'nc-'. it is not a cpfRealtion
			if(preg_match( "/^nc-/", $lobjIdentity['id'] ) > 0)
				continue;

			$lobjCPFRelationNode['attributes']['xlink:arcrole'] = "associatedWith";
			
			if( strpos( $lobjIdentity['id'], 'lccn') === false )
			{
				$lobjCPFRelationNode['attributes']['xlink:href'] = "http://www.worldcat.org/identities/" . $lobjIdentity['id'];
			}
			else
			{
			    $lobjCPFRelationNode['attributes']['xlink:href'] = "http://id.loc.gov/authorities/names/" . substr(preg_replace('/-/','0',$lobjIdentity['id']),5);
			}
			
			$lobjCPFRelationNode['attributes']['xlink:role'] = "http://RDVocab.info/uri/schema/FRBRentitiesRDA/Person";
			$lobjCPFRelationNode['attributes']['xlink:type'] = "simple";

            /*
			if( strpos( $lobjIdentity['id'], 'lccn') !== false )
			{
				$lobjCPFRelationNode['elements']['relationEntry']['attributes']['xml:id'] = $lobjIdentity['id'];
			}else
			{
				if($lobjIdentity['id'] != '')
				{
					$lobjIdentity['id'] = preg_replace('/[^A-Za-z0-9]/', '_', $lobjIdentity['id'] );
					$lobjCPFRelationNode['elements']['relationEntry']['attributes']['xml:id'] = $lobjIdentity['id'];
				}
			}
			*/

			if( $lobjIdentity['type'] != '' )
				$lobjCPFRelationNode['elements']['relationEntry']['attributes']['localType'] = $lobjIdentity['type'];

			if( $lobjIdentity['name'] != '' )
				$lobjCPFRelationNode['elements']['relationEntry']['elements'] = $lobjIdentity['name'];

			$this->objElementList['cpfRelation'][] = $lobjCPFRelationNode;
		}
	}

	/**
	 * WorldCat_Ingestor::createResourceRelationsElements() - build resourceRelation nodes
	 * based on collected associated names list and works by and about list and save in
	 * element list property
	 *
	 * @return void
	 */
	private function createResourceRelationsElements()
	{
		$lobjResourceRelationNode = array();

		foreach( $this->objRelatedIdentites as $lobjIdentity )
		{
			//if the id does start with 'nc-'. it is not a resourceRealtion
			if(preg_match( "/^nc-/", $lobjIdentity['id'] ) < 1)
				continue;

			$lobjResourceRelationNode['attributes']['resourceRelationType'] = "subjectOf";
			$lobjResourceRelationNode['attributes']['xlink:href'] = "http://www.worldcat.org/identities/" . $lobjIdentity['id'];
			$lobjResourceRelationNode['attributes']['xlink:role'] = "archivalRecords";
			$lobjResourceRelationNode['attributes']['xlink:type'] = "simple";

			if( $lobjIdentity['name'] != '' )
				$lobjResourceRelationNode['elements']['relationEntry'] = array( "elements" => $lobjIdentity['name'] );

			$this->objElementList['resourceRelation'][] = $lobjResourceRelationNode;
		}

		//rest of the relationresources must be ordered by type and creator, but
		//they come from WorldCat API unordered so we will store them separately as we go
		$lobjArchivalBy = array();
		$lobjResourceBy = array();
		$lobjArchivalAbout = array();
		$lobjResourceAbout = array();

		foreach( $this->objWorksBy as $lobjCitation )
		{
			$lobjResourceRelationNode = array();

			/*remvoed because xml was not valid xml
			if($lobjCitation['isbn'] != '')
				$lobjResourceRelationNode['attributes']['localType'] = "isbn";*/

			$lobjResourceRelationNode['attributes']['resourceRelationType'] = "creatorOf";
			$lobjResourceRelationNode['attributes']['xlink:href'] = "http://worldcat.org/oclc/" . preg_replace( "[^0-9]", "", $lobjCitation['oclcnum'] );
			$lobjResourceRelationNode['attributes']['xlink:role'] = $lobjCitation['record_type'] == "mixd" ? "archivalRecords" : "resource";
			$lobjResourceRelationNode['attributes']['xlink:type'] = "simple";

			$lobjRelationEntry = array();

			if( $lobjCitation['record_type'] != '' )
				$lobjRelationEntry['attributes']['localType'] = $lobjCitation["record_type"];

			if( $lobjCitation['title'] != '' )
				$lobjRelationEntry['elements'] = $lobjCitation["title"];

			if( !empty( $lobjRelationEntry ) )
				$lobjResourceRelationNode['elements']['relationEntry'][] = $lobjRelationEntry;

			if( $lobjCitation['isbn'] != '' )
			    $lobjResourceRelationNode['elements']['relationEntry'][] = array( "attributes" => array( "localType" => "isbn" ),
  		                                                                          "elements" => $lobjCitation['isbn'] );

			if( $lobjCitation['creator'] != '' )
				$lobjResourceRelationNode['elements']['relationEntry'][] = array( "attributes" => array( "localType" => "creator" ),
																 			  		"elements" => $lobjCitation['creator'] );

		    if( $lobjCitation['creator_viaf'] != '')
			   $lobjResourceRelationNode['elements']['relationEntry'][] = array( "attributes" => array( "localType" => "VIAF" ),
			   "elements" => $lobjCitation['creator_viaf'] );



			//if mixd, it is an archival resource relation.
			if( $lobjCitation['record_type'] == 'mixd' )
				$lobjArchivalBy[] = $lobjResourceRelationNode;
			else
				$lobjResourceBy[] = $lobjResourceRelationNode;
		}

		foreach( $this->objWorksAbout as $lobjCitation )
		{
			$lobjResourceRelationNode = array();

			$lobjResourceRelationNode['attributes']['resourceRelationType'] = "subjectOf";
			$lobjResourceRelationNode['attributes']['xlink:href'] = "http://worldcat.org/oclc/" . preg_replace( "[^0-9]", "", $lobjCitation['oclcnum'] );
			$lobjResourceRelationNode['attributes']['xlink:role'] = $lobjCitation['record_type'] == "mixd" ? "archivalRecords" : "resource";
			$lobjResourceRelationNode['attributes']['xlink:type'] = "simple";

			$lobjRelationEntry = array();

			if( $lobjCitation['record_type'] != '' )
				$lobjRelationEntry['attributes']['localType'] = $lobjCitation["record_type"];

			if( $lobjCitation['title'] != '' )
				$lobjRelationEntry['elements'] = $lobjCitation["title"];

			if( !empty( $lobjRelationEntry ) )
				$lobjResourceRelationNode['elements']['relationEntry'][] = $lobjRelationEntry;

			if( $lobjCitation['isbn'] != '' )
			    $lobjResourceRelationNode['elements']['relationEntry'][] = array( "attributes" => array( "localType" => "isbn" ),
			                                                                        "elements" => $lobjCitation['isbn'] );

			if( $lobjCitation['creator'] != '' )
				$lobjResourceRelationNode['elements']['relationEntry'][] = array( "attributes" => array( "localType" => "creator" ),
																 			  		"elements" => $lobjCitation['creator'] );

            /*removed because xml was not valid xml */
			if( $lobjCitation['creator_viaf'] != '')
			   $lobjResourceRelationNode['elements']['relationEntry'][] = array( "attributes" => array( "localType" => "VIAF" ),
			   "elements" => $lobjCitation['creator_viaf'] );

			//sometimes WorldCat API lists works by under works about, tested here and handled
			if( $lobjCitation['creator'] != '' && $this->strRawName == $lobjCitation['creator'] )
			{
				$lobjResourceRelationNode['attributes']['resourceRelationType'] = "creatorOf";

				//if mixd, it is an archival resource relation.
				if( $lobjCitation['record_type'] == 'mixd' )
					$lobjArchivalBy[] = $lobjResourceRelationNode;
				else
					$lobjResourceBy[] = $lobjResourceRelationNode;
			}else
			{
				$lobjResourceRelationNode['attributes']['resourceRelationType'] = "subjectOf";

				//if mixd, it is an archival resource relation.
				if( $lobjCitation['record_type'] == "mixd" )
					$lobjArchivalAbout[] = $lobjResourceRelationNode;
				else
					$lobjResourceAbout[] = $lobjResourceRelationNode;
			}
		}

		//makes sure property's index 'resourceRelation' is initialized to array before merging
		if( !isset($this->objElementList['resourceRelation']) )
			$this->objElementList['resourceRelation'] = array();

		//merge all arrays (in correct order) to generate master resource relation list
		$this->objElementList['resourceRelation'] = array_merge( $this->objElementList['resourceRelation'], $lobjArchivalBy, $lobjArchivalAbout, $lobjResourceBy, $lobjResourceAbout );
	}
}

?>
