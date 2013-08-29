<?php
/**
 *   @file worldcat_ingest_api.php
 *   @brief controller for WorldCat Ingestor class
 *
 *   @author dgonzalez
 */

//require the inclusion of thejWorldCat Ingestor class
require('../classes/WorldCat_Ingestor.php');

if(isset($_POST['action']))
{
	//carry on excution based on posted actions
	switch($_POST['action'])
	{
		case 'search':
			if(!isset($_POST['name']))
			{
				echo "ERROR: No name provided";
				exit;
			}

			$lobjWorldCatIngestor = new WorldCat_Ingestor();

			$ljsonSearchResults = $lobjWorldCatIngestor->searchWorldCat( $_POST['name'] );

			if(!$ljsonSearchResults)
			{
				echo "No results found!";
			}else
			{
				echo $ljsonSearchResults;
			}
			break;
		case 'get_element_list':
			if(isset($_POST['uri']))
			{
				$lstrURI = $_POST['uri'];
				$lobjWorldCatIngestor = new WorldCat_Ingestor();

				if( !$lobjWorldCatIngestor->collectData($lstrURI) || !$lobjWorldCatIngestor->createElements() )
					echo "Error!";
				else
				{
					$lobjWorldCatIngestor->echoJsonElementsList();
				}
			}else
			{
				echo '';
			}
			break;
		default:
			echo 'ERROR: Action not implemented!';
	}
}else{
	echo '';
}

?>