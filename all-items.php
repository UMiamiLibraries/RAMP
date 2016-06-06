<?php 
include('header.php');
?>
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
          echo "</tr>";
          foreach($allItems as $item):

            echo "<tr>";
            echo "<td>".$item['Name']."</td>";
            echo "<td>".$item['eac_id']."</td>";
            echo "<td>".$item['ingest_status']['statuses'][0]['status']."</td>";
            echo "<td>".$item['ingest_status']['statuses'][1]['status']."</td>";
            echo "<td>".$item['ingest_status']['statuses'][2]['status']."</td>";
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
