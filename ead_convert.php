<?php
include('header.php');
error_reporting(E_ALL);
ini_set('display_errors', '1');
?>
<link rel="stylesheet" href="style/jquery.phpdiffmerge.min.css"/>
<script src="script/jquery.phpdiffmerge.min.js"></script>

<script type="text/javascript">
jQuery(document).ready(function($)
{
	var lstrDir = $('input[name="dir"]').val();

	$('#convertEad2Eac').on('click', function()
	{
		var lboolContinue = true;
		var lobjUnprocessed = [];

		$('#convertEad2Eac').attr('disabled', 'disabled');
		$('#file_estimator').html('Processing...');
		$('#file_estimator').show("fast");
		$('#results').html( '' );

		convertEad( lstrDir, lobjUnprocessed, '' );
	});
});

function convertEad( lstrDir, lobjUnprocessed, lstrDiffs )
{
	$.ajax(
			{
				url: 'ajax/convert_ead_to_eac.php?dir=' + encodeURI(lstrDir),
				data: { 'files' : lobjUnprocessed },
				type: "POST",
				success: function(response)
				{
					try
					{
						var lobjData = JSON.parse(response);
					}
					catch(e) //response should be JSON so if not, throw error
					{
						alert(response);
						return;
					}

					lstrDiffs += lobjData.diffs;

					if( lobjData.status == "done" )
					{
						$('#file_estimator').html('Done');
						$('#results').html( lstrDiffs );
						$('#convertEad2Eac').removeAttr('disabled');
					}else
					{
						$('#file_estimator').html( lobjData.unprocessed.length + " files left.");
						lobjUnprocessed = lobjData.unprocessed;
						convertEad( lstrDir, lobjUnprocessed, lstrDiffs );
					}

					
				},
				async: true
			});
}
</script>

<form action="ead_convert_class.php">

  Path to EAD Files: <input name='dir' value="<?php echo $ead_path ?>"></input>
  <button type="button" id="convertEad2Eac" name="convertEad2Eac" class="pure-button pure-button-primary">Convert</button>
  <span id="file_estimator" style="display: none;"></span>
  <div id="results"></div>
  </form>

<?php include('footer.php');?>