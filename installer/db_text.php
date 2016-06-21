<?php
$dbText = function($db_host, $db_user, $db_pass, $db_default, $db_port) {
return  <<<EOT
<?php
\$db_host = '$db_host';
\$db_user = '$db_user';
\$db_pass = '$db_pass';
\$db_default = '$db_default';
\$db_port = '$db_port';
EOT;
};