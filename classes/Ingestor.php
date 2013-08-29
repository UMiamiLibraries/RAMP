<?php

/**
 * Ingestor - define all high level methods and properties for all api ingestors
 *
 *
 * @author dgonzalez
 * @copyright Copyright (c) 2013
 * @access public
 */
class Ingestor
{
	public $strUrl;
	public $rscCurl;
	public $strResponse;
	public $objDom;
	protected $objXPath;

	public function __construct()
	{
		$this->strUrl = '';
		$this->strResponse = '';
		$this->rscCurl = curl_init();;
		$this->objDom = new DOMDocument();
		$this->objXPath = null;
	}

	/**
	 * Ingestor::getResults() - executes curl session and saves results in property
	 *
	 * @return void
	 */
	public function getResults()
	{
		$this->strResponse = curl_exec($this->rscCurl);
	}

	/**
	 * Ingestor::createDom() - load xml from response property and create
	 * DOMXPath instance and dave to property
	 *
	 * @return  void
	 */
	public function createDom()
	{
		$this->objDom->loadXML($this->strResponse);
		$this->objXPath = new DOMXPath($this->objDom);
	}

	/**
	 * Ingestor::xpath() - execute xpath query
	 *
	 * @param string $lstrQuery
	 * @param DOMElement $lobjReferenceNode
	 * @return DOMNodeList
	 */
	public function xpath($lstrQuery = '\*', $lobjReferenceNode = NULL)
	{
		if($lobjReferenceNode != NULL)
			return $this->objXPath->query($lstrQuery, $lobjReferenceNode);
		else
			return $this->objXPath->query($lstrQuery);
	}

	public function convertBadXMLEntities( $lobjMatch )
	{
		if( strpos( $lobjMatch[0], 'x301' ) !== FALSE )
			return html_entity_decode( '&' . $lobjMatch[1] . 'acute;', ENT_COMPAT , 'UTF-8' );
		elseif( strpos( $lobjMatch[0], 'x300' ) !== FALSE )
			return html_entity_decode( '&' . $lobjMatch[1] . 'grave;', ENT_COMPAT , 'UTF-8' );
		elseif( strpos( $lobjMatch[0], 'x303' ) !== FALSE )
			return html_entity_decode( '&' . $lobjMatch[1] . 'tilde;', ENT_COMPAT , 'UTF-8' );
		elseif( strpos( $lobjMatch[0], 'x308' ) !== FALSE )
			return html_entity_decode( '&' . $lobjMatch[1] . 'uml;', ENT_COMPAT , 'UTF-8' );
		else
			return '';
	}

	/**
	 * Ingestor::encodeForUrl() - function to encode passed string for ingestion
	 *
	 * @param string $lstrString
	 * @return string
	 */
	static function encodeForUrl($lstrString)
	{
		$lstrString = preg_replace('/\s\s+/', " ", $lstrString );
		$lstrString = rawurlencode(utf8_decode($lstrString));

		return $lstrString;
	}
}

?>