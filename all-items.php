<?php 
include('header.php');
?>
<script src="script/deleteRecord.js"></script>
<div class="inner-area">

  <div class="pure-g">
    <div class="pure-u-1">
      <div class="content_box">
        <h1>All Items</h1>

        <div class="content_box">
          <?php
          use RAMP\Util\RecordList;
          use RAMP\Util\Database;
          $db = Database::getInstance();
          $rl = new RecordList($db);
          $allItems = $rl->getList();

          echo "<table class='pure-table'>";
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

            echo "<tr>";
            echo "<td>".$item['Name']."</td>";
            echo "<td>".$item['eac_id']."</td>";
            echo "<td>".$item['ingest_status']['statuses'][0]['status']."</td>";
            echo "<td>".$item['ingest_status']['statuses'][1]['status']."</td>";
            echo "<td>".$item['ingest_status']['statuses'][2]['status']."</td>";
            echo "<td><a href='#' onclick='deleteRecord({$item['eac_id']})'><i class=\"fa fa-trash\" aria-hidden=\"true\"></i></a></td>";
            echo "<td><a href='ajax/download_eac.php?eac_id={$item['eac_id']}'><i class=\"fa fa-download\" aria-hidden=\"true\"></i></a></td>";

            echo "</tr>";
          endforeach;
          echo "</table>";

          ?>
        </div>

      </div>
    </div>
  </div>

</div>



<?php
include('footer.php');  
?>
