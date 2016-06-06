<?php include('includes/scripts.php'); ?>

</div>
</div>
<footer>
	<div class="inner-area">
		<div class="pure-g">
			<div class="pure-u-2-3">
				
			</div>
			<div class="pure-u-1-3">
				<p class="ramp-link"><a href="https://github.com/UMiamiLibraries/RAMP" target="_blank">RAMP GitHub Project</a> <i class="fa fa-github"></i></p>
			</div>
		</div>
	</div>
</footer>
<script>
	var eacId = <?php if (isset($_GET['eac_id'])) {
		echo (int) $_GET['eac_id'];
	} ?>;

	$(document).ready(function() {
		build_editor(eacId);
	});
</script>
</body>
</html>
