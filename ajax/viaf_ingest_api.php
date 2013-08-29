<?php
/**
 *   @file viaf_ingest_api.php
 *   @brief controller for Viaf Ingestor class
 *
 *   @author dgonzalez
 */

//require inclusion of Viaf Ingestor class
require('../classes/Viaf_Ingestor.php');

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
			$lstrName = Ingestor::encodeForUrl($_POST['name']);

			$lobjViafIngestor = new Viaf_Ingestor();

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

				$lobjViafIngestor = new Viaf_Ingestor();

				if( !$lobjViafIngestor->createSource($lstrViafID) )
					echo "No results found!";
				else
				{
					$lobjViafIngestor->createNameEnrtyList();
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

				$lobjViafIngestor = new Viaf_Ingestor();
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