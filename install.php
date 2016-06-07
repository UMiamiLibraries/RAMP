<?php include('header.php');
      include('installer/db_text.php');
      include('installer/write_db_text.php');
use RAMP\Util\Database;
$db = Database::getInstance();
?>

<?php


if (isset($_POST['db_user'])) {

    $writeDbText($dbText($_POST['db_host'],$_POST['db_user'],$_POST['db_pass'],$_POST['db_default'],$_POST['db_port']));

}

?>



<?php include('installer/form.php'); ?>
<?php include('footer.php') ?>
