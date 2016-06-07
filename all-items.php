<?php 
include('header.php');
include('export/export_zip.php');


?>

<?php
function statusIcon($status) {
  if ($status == "true") {
    return "<i class=\"fa fa-check\" aria-hidden=\"true\"></i>";

  }
  if ($status == "false") {
    return "<i class=\"fa fa-times\" aria-hidden=\"true\"></i>";
  }
}
?>

<script src="script/deleteRecord.js"></script>

<div class="recordtitle-bkg">    
   <div class="recordtitle">
        <div class="inner-area"><h2 class="page-top-heading">All Items</h2></div>
   </div>
</div>

<div class="decoration-bar">
    <div class="pure-g">
        <div class="pure-u-1-4 decor1"></div>
        <div class="pure-u-1-4 decor2"></div>
        <div class="pure-u-1-4 decor3"></div>
        <div class="pure-u-1-4 decor4"></div>
    </div>
</div>


<div class="inner-area">

  <div class="pure-g">
    <div class="pure-u-1">

        <div class="content_box">
          <?php
          use RAMP\Util\RecordList;
          use RAMP\Util\Database;
          $db = Database::getInstance();
          $rl = new RecordList($db);
          $allItems = $rl->getList();

          echo "<table class='pure-table all-items-table'>";
          echo "<tr>";
          echo "<td>Name</td>";
          echo "<td>EAC ID</td>";
          echo "<td>VIAF Ingest Status</td>";
          echo "<td>WorldCat Ingest Status</td>";
          echo "<td>Wiki Ingest Status</td>";
          echo "<td>Delete Record</td>";
          echo "<td>Download Record</td>";

          echo "</tr>";
          foreach($allItems as $item):

            echo "<tr id='{$item['eac_id']}'>";
            echo "<td><a href='index.php?eac_id={$item['eac_id']}'>".$item['Name']."</a></td>";
            echo "<td>".$item['eac_id']."</td>";
            echo "<td>".statusIcon($item['ingest_status']['statuses'][0]['status'])."</td>";
            echo "<td>".statusIcon($item['ingest_status']['statuses'][1]['status'])."</td>";
            echo "<td>".statusIcon($item['ingest_status']['statuses'][2]['status'])."</td>";
            echo "<td><a href='#' onclick='deleteRecord({$item['eac_id']})'><i class=\"fa fa-trash\" aria-hidden=\"true\"></i></a></td>";
            echo "<td><a href='ajax/download_eac.php?eac_id={$item['eac_id']}'><i class=\"fa fa-download\" aria-hidden=\"true\"></i></a></td>";

            echo "</tr>";
          endforeach;
          echo "</table>";

          ?>
          <div class="pure-button ramp-button action-button">
              <?php
              // Run function to create the export zip file
              exportZip();
              ?>
            <a href="export/ramp-export.zip">Download All Records <i class="fa fa-download" aria-hidden="true"></i></a>
          </div>

        </div>

     
    </div>
  </div>

</div>



<?php
include('footer.php');  
?>
