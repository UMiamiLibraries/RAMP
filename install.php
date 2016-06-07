<?php include('header.php');
      include('installer/db_text.php');
      include('installer/write_db_text.php');
use RAMP\Util\Database;
try {
    $db = Database::getInstance();

     echo <<<EOT
            <div id="flash_message">
                <div class="success-message">
                 <p>Successfully connected to MySQL</p>
                </div>
            </div>
EOT;

} catch (mysqli_sql_exception $e) {

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
<?php include('footer.php') ?>
