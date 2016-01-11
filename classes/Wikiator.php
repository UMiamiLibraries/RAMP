<?php
/**
 * Wikiator - defines methods and properties to search, get, and edit posts in
 * wikipedia
 *
 * @author dgonzalez
 * @copyright Copyright (c) 2013
 * @access public
 */
class Wikiator
{
	const SEARCHLIMIT = 10;
	const NORESULTS = 0;
	const PAGE = 1;
	const MULTIPLERESULTS = 2;
	const REDIRECTRESULT = 3;
	const FAILED_EDIT = 0;
	const SUCCESSFUL_EDIT = 1;
	const CAPTCHA = 3;

	private $strLoginToken = '';
	private $strSessionID = '';
	private $strEditToken = '';
	private $strStartTimeStamp = '';
	private $objCurl = null;
	private $strCookieFile = '';
	private $strUserAgent = '';
	private $strPageId = '';
	private $strPageTitle = '';

	public $strResponse = '';
	public $intStatus = null;

	public function __construct()
	{
		//make sure session id exists
		if( session_id() == "" )
			session_start();

		//cookie that saved user wiki session
		$this->strCookieFile = sys_get_temp_dir() . DIRECTORY_SEPARATOR . session_id() . "_wiki_cookie.tmp";

		$this->strUserAgent = "MyCoolTool/1.1 (http://example.com/MyCoolTool/; MyCoolTool@example.com) BasedOnSuperLib/1.4";

		//setup Curl
		$this->objCurl = curl_init();
		$this->setupCurl();
	}

	/**
	 * Wikiator::getPageId() - getter for page id
	 *
	 * @return
	 */
	public function getPageId()
	{
		return $this->strPageId;
	}

	/**
	 * Wikiator::getPageTitle() - getter for page title
	 *
	 * @return
	 */
	public function getPageTitle()
	{
		return $this->strPageTitle;
	}

	/**
	 * Wikiator::Login() - log into wikipedia and store cookie with session info
	 *
	 * @param string $lstrUserName
	 * @param string $lstrPassword
	 * @return boolean
	 */
	public function Login( $lstrUserName, $lstrPassword )
	{
		if( file_exists( $this->strCookieFile ) )
			unlink( $this->strCookieFile );

		$lobjPostData = array( 'lgname' => $lstrUserName, 'lgpassword' => $lstrPassword );

		//curl option setup for this request
		curl_setopt( $this->objCurl, CURLOPT_URL, 'https://en.wikipedia.org/w/api.php?action=login&format=xml' );
		curl_setopt( $this->objCurl, CURLOPT_POST, true );
		curl_setopt( $this->objCurl, CURLOPT_POSTFIELDS, $lobjPostData );

		$this->strResponse = curl_exec( $this->objCurl );

		$lobjMatch = array();
		preg_match('/token="([^"]*)"/', $this->strResponse, $lobjMatch);
		$lobjPostData['lgtoken'] = isset($lobjMatch[1]) ? $lobjMatch[1] : "";

		curl_setopt( $this->objCurl, CURLOPT_POSTFIELDS, $lobjPostData );
		$this->strResponse = curl_exec($this->objCurl );

		preg_match('/sessionid="([^"]*)"/', $this->strResponse, $lobjMatch);
		$this->strSessionID = isset($lobjMatch[1]) ? $lobjMatch[1] : "";

		preg_match('/lgtoken="([^"]*)"/', $this->strResponse, $lobjMatch);
		$this->strLoginToken = isset($lobjMatch[1]) ? $lobjMatch[1] : "";

		if( preg_match( '/result="success"/i' ,$this->strResponse ) )
			return TRUE;

		return FALSE;
	}

	/**
	 * Wikiator::Logout() - delete cookie file with user session stored, which causes
	 * user to login again in order to post
	 *
	 * @return void
	 */
	public function Logout()
	{
		if( file_exists( $this->strCookieFile ) )
			unlink( $this->strCookieFile );
	}

	/**
	 * Wikiator::searchWiki() - search wikipedia with passed title and return
	 * json encoded search results list
	 *
	 * @param string $lstrSearch
	 * @param boolean $lboolEncoded
	 * @return string
	 */
	public function searchWiki( $lstrSearch, $lboolEncoded = FALSE )
	{
		if(!$lboolEncoded)
			$lstrEncodedSearch = self::encodeForUrl( $lstrSearch );
		else
			$lstrEncodedSearch = $lstrSearch;

		$lobjSearchList = array();

		//first search if exact match. Helps with pages that exist but are not indexed.
		$this->getWikiPage( $lstrEncodedSearch, TRUE );

		if( $this->intStatus == self::PAGE )
		{
			$lobjExactMatch = array();

			$lobjExactMatch['title'] = urldecode($lstrSearch);
			$lobjExactMatch['titlesnippet'] = urldecode($lstrSearch);
			$lobjExactMatch['snippet'] = "Page exists with exact match. <a target=\"_blank\" href=\"http://en.wikipedia.org/wiki/{$lstrEncodedSearch}\">View existing Wikipedia page</a>";
		}

		//curl options setup for this request
		curl_setopt( $this->objCurl, CURLOPT_URL, "http://en.wikipedia.org/w/api.php?action=query&list=search&format=xml&srsearch={$lstrEncodedSearch}&srprop=snippet|titlesnippet&srlimit=" . self::SEARCHLIMIT );
		curl_setopt ( $this->objCurl, CURLOPT_POST, false );

		$this->strResponse = curl_exec( $this->objCurl );

		$lobjMatch = array();
		preg_match_all( '/title="([^"]*)"/', $this->strResponse, $lobjMatch );

		for( $i = 0; $i < count($lobjMatch[1]); $i++ )
		{
			$lobjSearchList[$i]['title'] = $lobjMatch[1][$i];
		}

		$lobjMatch = array();
		preg_match_all( '/\ssnippet="([^"]*)"/', $this->strResponse, $lobjMatch );

		for( $i = 0; $i < count($lobjMatch[1]); $i++ )
		{
			$lstrEncodedTitle = self::encodeForUrl($lobjSearchList[$i]['title']);

			$lobjSearchList[$i]['snippet'] = $lobjMatch[1][$i] . "<br/><a target=\"_blank\" href=\"http://en.wikipedia.org/wiki/{$lstrEncodedTitle}\">View existing Wikipedia page</a>";
		}

		$lobjMatch = array();
		preg_match_all( '/titlesnippet="([^"]*)"/', $this->strResponse, $lobjMatch );

		for( $i = 0; $i < count($lobjMatch[1]); $i++ )
		{
			$lobjSearchList[$i]['titlesnippet'] = $lobjMatch[1][$i];
		}

		//add exact match to search results
		if(isset($lobjExactMatch))
			array_unshift( $lobjSearchList, $lobjExactMatch );

		return json_encode( $lobjSearchList );
	}

	/**
	 * Wikiator::getWikiPage() - returns wikimarkup for passed wikipedia page title.
	 * Will indicate if no results and follow any wiki redirects. If multiple results,
	 * will return list.
	 *
	 * @param string $lstrTitle
	 * @param boolean $lboolEncoded
	 * @return string
	 */
	public function getWikiPage( $lstrTitle, $lboolEncoded = FALSE )
	{
		if(!$lboolEncoded)
			$lstrEncodedTitle = self::encodeForUrl( $lstrTitle );
		else
			$lstrEncodedTitle = $lstrTitle;

		curl_setopt( $this->objCurl, CURLOPT_URL, "http://en.wikipedia.org/w/api.php?format=xml&action=query&titles=$lstrEncodedTitle&prop=revisions&rvprop=content" );
		curl_setopt ( $this->objCurl, CURLOPT_POST, false );

		$this->strResponse = curl_exec( $this->objCurl );

		if(!preg_match( '/<revisions>/', $this->strResponse ))
		{
			$this->intStatus = self::NORESULTS;

			return 'Title does not exist.';

		}elseif( preg_match( "/<rev.*>.*'''$lstrTitle''' may refer to:/s", $this->strResponse ) )
		{
			$this->intStatus = self::MULTIPLERESULTS;

			$lobjMatch = array();
			preg_match_all( '/\[\[(.*)\]\]/', $this->strResponse, $lobjMatch );

			unset($lobjMatch[0]);

			return json_encode( $lobjMatch[1] );

		}elseif( preg_match( "/<rev.*>#REDIRECT \[\[/", $this->strResponse ) )
		{
			$this->intStatus = self::REDIRECTRESULT;

			$lobjMatch = array();
			preg_match( "/<rev.*>#REDIRECT \[\[(.*)\]\]/", $this->strResponse, $lobjMatch );

			return $this->getWikiPage($lobjMatch[1]);

		}else
		{
			$this->intStatus = self::PAGE;

			preg_match('/pageid="([^"]*)"/', $this->strResponse, $lobjMatch);
			$this->strPageId = isset($lobjMatch[1]) ? $lobjMatch[1] : "";

			preg_match('/title="([^"]*)"/', $this->strResponse, $lobjMatch);
			$this->strPageTitle = isset($lobjMatch[1]) ? $lobjMatch[1] : "";

			$lobjMatch = array();
			preg_match( "/<rev[^i].*>(.*)<\/rev>/s", $this->strResponse, $lobjMatch );

			return $lobjMatch[1];
		}
	}

	/**
	 * Wikiator::editWikiPage() - edit desired wikipedia page title with passed
	 * wikimarkup. Also, if indicated, sets edit comments and captcha if necessary.
	 *
	 * @param mixed $lstrPageTitle
	 * @param mixed $lstrWikiText
	 * @param string $lstrEncodedTitle
	 * @param string $lstrComments
	 * @param string $lstrCaptchaID
	 * @param string $lstrCaptchaWord
	 * @return
	 */
	public function editWikiPage( $lstrPageTitle, $lstrWikiText, $lstrEncodedTitle = '', $lstrComments = "", $lstrCaptchaID = '', $lstrCaptchaWord = '' )
	{
		$this->strPageTitle = $lstrPageTitle;
		$this->setWikiEditInfo($lstrEncodedTitle);

		if( $this->strPageId === 0 )
			$lobjPostData = array( 'title' => $this->strPageTitle, 'text' => $lstrWikiText,
				'token' => $this->strEditToken, 'starttimestamp' => $this->strStartTimeStamp,
				'summary' => $lstrComments,'captchaid' => $lstrCaptchaID, 'captchaword' => $lstrCaptchaWord );
		else
			$lobjPostData = array( 'pageid' => $this->strPageId, 'text' => $lstrWikiText,
				'token' => $this->strEditToken, 'starttimestamp' => $this->strStartTimeStamp,
				'summary' => $lstrComments, 'captchaid' => $lstrCaptchaID, 'captchaword' => $lstrCaptchaWord );

		//curl options setup for this request
		curl_setopt( $this->objCurl, CURLOPT_URL, 'http://en.wikipedia.org/w/api.php?action=edit&format=xml' );
		curl_setopt ( $this->objCurl, CURLOPT_POSTFIELDS, $lobjPostData );

		$this->strResponse = curl_exec( $this->objCurl );

		if(preg_match( '/<captcha/', $this->strResponse ))
		{
			$this->intStatus = self::CAPTCHA;

			$lobjCaptchaData = array();

			$lobjMatch = array();
			preg_match( '/id="([^"]*)"/', $this->strResponse, $lobjMatch );
			$lobjCaptchaData['id'] = isset($lobjMatch[1]) ? $lobjMatch[1] : "";

			$lobjMatch = array();
			preg_match( '/url="([^"]*)"/', $this->strResponse, $lobjMatch );
			$lobjCaptchaData['url'] = html_entity_decode( isset($lobjMatch[1]) ? $lobjMatch[1] : "" );

			//return captcha id and url in order for user to resolve
			return json_encode( $lobjCaptchaData );

		}elseif( preg_match( '/result="Success"/', $this->strResponse ) )
		{
			$this->intStatus = self::SUCCESSFUL_EDIT;

			return "Edit successful! Page id -> {$this->strPageId}<br/><br/><a id=\"wiki_page_link\" target=\"_blank\" href=\"http://en.wikipedia.org/wiki/{$this->strPageTitle}\">View the page you just edited!</a>";
		}else
		{
			$this->intStatus = self::FAILED_EDIT;

			$lobjMatch = array();
			preg_match( '/pageid="([^"]*)"/', $this->strResponse, $lobjMatch );
			$this->strPageId = isset($lobjMatch[1]) ? $lobjMatch[1] : "";

			$lstrErrorResponse = "";

			preg_match_all( '/\s([^>=\s]+)="([^"]*)"/', $this->strResponse, $lobjMatch );

			//show all attributes and values to user when edit fails (gives error information)
			foreach( $lobjMatch[1] as $lstrKey => $lstrValue )
			{
				$lstrErrorResponse .= "<strong>$lstrValue</strong>:{$lobjMatch[2][$lstrKey]}<br />";
			}

			return "Something went wrong. Could not edit. Response -> <br />{$lstrErrorResponse}";
		}
	}

	/**
	 * Wikiator::checkCookie() - checks whether cookie that contains user wiki session
	 * exists amd contains necessary token. This prevents non-logged in users to edit wiki
	 *
	 * @return void
	 */
	public function checkCookie()
	{
		if( !file_exists( $this->strCookieFile ) )
			die( "ERROR: User not logged in!" );

		$lstrCookie = file_get_contents( $this->strCookieFile );

		if( strpos( $lstrCookie, "centralauth_Token" ) == FALSE )
			die( "ERROR: User not logged in!" );
	}

	/**
	 * Wikiator::setWikiEditInfo() - setups all necessary properties in order to
	 * successfully edit wiki post. E.g. Edit token for certain page
	 *
	 * @param string $lstrEncodedTitle
	 * @return void
	 */
	private function setWikiEditInfo( $lstrEncodedTitle )
	{
		if($lstrEncodedTitle == '')
			$lstrEncodedTitle = self::encodeForUrl( $this->strPageTitle );

		//curl options setup for this request
		curl_setopt( $this->objCurl, CURLOPT_URL, "http://en.wikipedia.org/w/api.php?action=query&prop=info&intoken=edit&titles={$lstrEncodedTitle}&format=xml" );
		curl_setopt ( $this->objCurl, CURLOPT_POST, FALSE );

		$this->strResponse = curl_exec( $this->objCurl );

		$lobjMatch = array();
		preg_match('/edittoken="([^"]*)"/', $this->strResponse, $lobjMatch);
		$this->strEditToken = isset($lobjMatch[1]) ? $lobjMatch[1] : "";

		$lobjMatch = array();
		preg_match('/pageid="([^"]*)"/', $this->strResponse, $lobjMatch);
		$this->strPageId = isset($lobjMatch[1]) ? $lobjMatch[1] : 0;

		$lobjMatch = array();
		preg_match('/starttimestamp="([^"]*)"/', $this->strResponse, $lobjMatch);
		$this->strStartTimeStamp = isset($lobjMatch[1]) ? $lobjMatch[1] : "";
	}

	/**
	 * Wikiator::setupCurl() - initial setup for curl object
	 *
	 * @return void
	 */
	private function setupCurl()
	{
		curl_setopt( $this->objCurl, CURLOPT_HTTPHEADER, array( 'Expect:' ) );
		curl_setopt( $this->objCurl, CURLOPT_COOKIEJAR, $this->strCookieFile );
		curl_setopt( $this->objCurl, CURLOPT_COOKIEFILE, $this->strCookieFile );
		curl_setopt( $this->objCurl, CURLOPT_RETURNTRANSFER, true );
		curl_setopt( $this->objCurl, CURLOPT_FOLLOWLOCATION, true );
		curl_setopt( $this->objCurl, CURLOPT_USERAGENT, $this->strUserAgent );
	}

	/**
	 * Wikiator::encodeForUrl() - encode string for use with wiki api
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

	/**
	 * Wikiator::getEacBase() - gets the url base of the eac installation using the
	 * passed variable as a placeholder.
	 * Ex: getEacBase('http://example.com/eac/classes/') -> 'http://example.com/eac/'
	 *
	 * @param string $lstrDirectoryBased
	 * @return string
	 */
	static function getEacBase( $lstrDirectoryBased = "ajax" )
	{
		$lstrURI = $_SERVER[ 'REQUEST_URI' ];

		$lobjSplit = explode( '/', $lstrURI );

		for( $i=(count($lobjSplit) - 1); $i >=0; $i-- )
		{
			if($lobjSplit[$i] == $lstrDirectoryBased)
			{
				unset($lobjSplit[$i]);
				$lstrEacBase = implode( '/' , $lobjSplit );
				$lstrEacBase = $lstrEacBase . '/';
				break;
			}else
			{
				unset($lobjSplit[$i]);
			}
		}

		return $lstrEacBase;
	}
}

?>
