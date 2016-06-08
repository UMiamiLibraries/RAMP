<?php include('header.php');
      include('installer/db_text.php');
      include('installer/write_db_text.php');
      use RAMP\Util\Database;

try {
    $db = Database::getInstance();

     $flash_message = <<<EOT
            
            <div class="inner-area">
              <div id="flash_message">
                  <div class="success-message">
                   <p>Successfully connected to MySQL. <a href="index.php">Start using RAMP.</a></p>
                  </div>
              </div>
            </div>
EOT;

} catch (mysqli_sql_exception $e) {

    $flash_message = <<<EOT
            <div class="inner-area">
            <div id="flash_message">
                <div class="error-message">
                 <p>Couldn't connect to the MySQL server. Please <a href="install.php">configure your database settings.</a>
                </p>
                </div>
            </div>
            </div>
EOT;
}
?>

<?php
if (isset($_POST['db_user'])) {
    // Force refresh after post
    echo "<meta http-equiv='refresh' content='0'>";

    $writeDbText($dbText($_POST['db_host'],$_POST['db_user'],$_POST['db_pass'],$_POST['db_default'],$_POST['db_port']));
}
?>

<?php include('installer/form.php'); ?>

<?php if(isset($flash_message)) {
    echo $flash_message;
} ?>

<?php include('footer.php') ?>
