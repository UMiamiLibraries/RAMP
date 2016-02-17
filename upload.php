<?php include('header.php') ?>

<form class="pure-form" enctype="multipart/form-data" action="ajax/uploader.php" method="POST">
    <input type="hidden" name="MAX_FILE_SIZE" value="30000000" />
    Upload an EAD: <input name="ead" type="file" />
    <input type="submit" value="Upload EAD" />
</form>


<?php include('footer.php'); ?>