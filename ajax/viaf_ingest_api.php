<?php
/**
 *   @file viaf_ingest_api.php
 *   @brief controller for Viaf Ingestor class
 *
 *   @author dgonzalez
 */

use RAMP\Ingest\Ingestor;
use RAMP\Ingest\ViafIngestor;

require_once('../autoloader.php');


if(isset($_POST['action']))
{
	//carry on execution based on posted action
	switch($_POST['action'])
	{
		case 'search':
			if(!isset($_POST['name']))
			{
				echo "ERROR: No name provided";
				exit;
			}

			//need to encode posted name in order to send to API
			$lstrName = trim(urlencode($_POST['name']));

			$lobjViafIngestor = new ViafIngestor();

			$ljsonSearchResults = $lobjViafIngestor->searchViaf( $lstrName );

			if(!$ljsonSearchResults)
			{
				echo "No results found!";
			}else
			{
				echo $ljsonSearchResults;
			}
			break;
		case 'source_and_name_entry':
			if(isset($_POST['viaf_id']))
			{
				//intval in order to scrub posted viaf_id
				$lstrViafID = intval($_POST['viaf_id']);

				$lobjViafIngestor = new ViafIngestor();

				if( !$lobjViafIngestor->createSource($lstrViafID) )
					echo "No results found!";
				else
				{
					$lobjViafIngestor->createNameEntryList();
					$lobjViafIngestor->echoNameEntryAndSourceJsonData();
				}
			}else
			{
				echo '';
			}
			break;
		case 'relations':
			if( isset($_POST['chosen_names']) )
			{
				//json decoded js object to get list of names to search in viaf
				$lobjNames = json_decode($_POST['chosen_names']);

				$lobjViafIngestor = new ViafIngestor();
				$lobjViafIngestor->createRelationsList($lobjNames);
				$lobjViafIngestor->echoRelationsJsonData();
			}else
			{
				echo '{}';
			}
			break;
		default:
			echo 'ERROR: Action not implemented!';
	}
}else{
	echo '';
}

?>