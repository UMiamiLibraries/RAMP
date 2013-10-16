<?php
/**
 *   @file wiki_api.php
 *   @brief controller for Wikiator class
 *
 *   @author dgonzalez
 */

//require inclusion of Wikiator class
require('../classes/Wikiator.php');

if(isset($_POST['action']))
{
	switch($_POST['action'])
	{
		case 'search':
			if(!isset($_POST['title']))
			{
				echo "ERROR: No title provided";
				exit;
			}

			//encoding necessary for Wiki API
			$lstrTitle = Wikiator::encodeForUrl( $_POST['title'] );

			$lobjWiki = new Wikiator();

			echo $lobjWiki->searchWiki( $lstrTitle, TRUE );
			break;
		case 'get':
			if(!isset($_POST['title']))
			{
				echo "ERROR: No title provided";
				exit;
			}

			//encoding necessary for Wiki API
			$lstrTitle = Wikiator::encodeForUrl( $_POST['title'] );

			$lobjWiki = new Wikiator();

			echo $lobjWiki->getWikiPage( $lstrTitle, TRUE );
			break;
		case 'post':
			if(!isset($_POST['title']))
			{
				echo "ERROR: No title provided";
				exit;
			}

			if(!isset($_POST['wiki']))
			{
				echo "ERROR: No wiki markup provided";
				exit;
			}

			$lobjWiki = new Wikiator();

			//make sure cookie file exists before posting to Wiki API
			$lobjWiki->checkCookie();

			$lstrComments = isset($_POST['comments']) ? $_POST['comments'] : "";

			//if draft change page title
			if( $_POST['isDraft'] == "true" && isset( $_COOKIE['ramp_wiki_un'] ) && stripos( $_POST['title'], 'user:' ) !== 0 )
			{
				$_POST['title'] = 'User:' . $_COOKIE['ramp_wiki_un'] . '/' . $_POST['title'];
			}

			//encoding necessary for Wiki API
			$lstrEncodedTitle = Wikiator::encodeForUrl( $_POST['title'] );

			if(isset($_POST['captcha_id']) && isset($_POST['captcha_ans']))
			{
				echo $lobjWiki->editWikiPage( $_POST['title'], $_POST['wiki'], $lstrEncodedTitle, $lstrComments, $_POST['captcha_id'], $_POST['captcha_ans'] );
			}else
			{
				echo $lobjWiki->editWikiPage( $_POST['title'], $_POST['wiki'], $lstrEncodedTitle, $lstrComments );
			}
			break;
		case 'login':
			if(!isset($_POST['username']))
			{
				echo "ERROR: No username provided";
				exit;
			}

			if(!isset($_POST['password']))
			{
				echo "ERROR: No password provided";
				exit;
			}

			$lobjWiki = new Wikiator();
			if($lobjWiki->Login( $_POST['username'], $_POST['password'] ))
			{
				//set cookie so that user only has to login in once per session
				setcookie( 'ramp_wiki_li', '1', 0, Wikiator::getEacBase() );
				setcookie( 'ramp_wiki_un', $_POST['username'], 0, Wikiator::getEacBase() );

				echo "Login successful!";
			}else
			{
				echo "Login failed!";
			}
			break;
		case 'logout':
			$lobjWiki = new Wikiator();
			$lobjWiki->Logout();

			//delete logged in cookie
			setcookie( 'ramp_wiki_li', '1', time() - 3600, Wikiator::getEacBase() );

			echo "Logged out!";

			break;
		default:
			echo 'ERROR: Action not implemented!';
	}

}else{
	echo '';
}

?>