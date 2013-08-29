	<link rel="stylesheet" href="styles.css" type="text/css" charset="utf-8"/>

<?php

include ('../../header.php');

$db_host = 'localhost';
$db_user = 'root';
$db_pass = 'root';
$db_default = 'ead_eac';
$db_port = '8889';

 $mysqli = new mysqli($db_host, $db_user, $db_pass, $db_default, $db_port);
  if ($mysqli->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
  }

	$ead_xml_from_db = $mysqli->query("SELECT ead_xml FROM ead_eac.ead WHERE ead_file ='/Applications/MAMP/htdocs/eac/ead/acosta_magali_o_collection_19561960.xml'");

 // WHERE ead_file ="  . "'" . $ead_path . "') ");
	        $ead_row = mysqli_fetch_row($ead_xml_from_db);
	

//     print_r($mysqli);

//     print_r($ead_row);


		// Include the diff class
		require_once dirname(__FILE__).'/../lib/Diff.php';

	 
		// Include two sample files for comparison
					      $a = explode("  ", $ead_row[0]);
		$b = explode("\n", file_get_contents('/Users/jlittle/htdocs/eac/ead/acosta_magali_o_collection_19561960.xml'));

		// Options for generating the diff
		$options = array(
			'ignoreWhitespace' => true,
			'ignoreCase' => true,
		);

		// Initialize the diff class
		$diff = new Diff($a, $b, $options);

		?>
		<h2>Side by Side Diff</h2>
		<?php

		// Generate a side by side diff
		require_once dirname(__FILE__).'/../lib/Diff/Renderer/Html/SideBySide.php';
		$renderer = new Diff_Renderer_Html_SideBySide;
		echo $diff->Render($renderer);

		?>
		<h2>Inline Diff</h2>
		<?php

		// Generate an inline diff
		require_once dirname(__FILE__).'/../lib/Diff/Renderer/Html/Inline.php';
		$renderer = new Diff_Renderer_Html_Inline;
		echo $diff->render($renderer);

		?>
		<h2>Unified Diff</h2>
		<pre><?php

		// Generate a unified diff
		require_once dirname(__FILE__).'/../lib/Diff/Renderer/Text/Unified.php';
		$renderer = new Diff_Renderer_Text_Unified;
		echo htmlspecialchars($diff->render($renderer));

		?>
		</pre>
		<h2>Context Diff</h2>
		<pre><?php

		// Generate a context diff
		require_once dirname(__FILE__).'/../lib/Diff/Renderer/Text/Context.php';
		$renderer = new Diff_Renderer_Text_Context;
		echo htmlspecialchars($diff->render($renderer));
		?>
		</pre>
	</body>
</html>
