<?php
/**
 * Database
 *
 *
 * A singleton class for dealing with the database
 *
 * @author little9 (Jamie Little)
 * @copyright Copyright (c) 2013
 *
 */

namespace RAMP\Util;


class Database {

    private $_connection;
    private static $_instance;
    private $_host = "";
    private $_username = "";
    private $_password = "";
    private $_database = "";
    private $_port = "";



    public static function getInstance() {
        if(!self::$_instance) {
            self::$_instance = new self();
        }
        return self::$_instance;
    }


    private function __construct() {
        require_once( dirname( dirname (dirname( dirname(__FILE__)))) . DIRECTORY_SEPARATOR . "conf" . DIRECTORY_SEPARATOR . "db.php" );

        $this->_host = $db_host;
        $this->_username = $db_user;
        $this->_password = $db_pass;
        $this->_database = $db_default;
        $this->_port = intval($db_port);

        $this->_connection = new \mysqli($this->_host, $this->_username,
            $this->_password, $this->_database, $this->_port);

        if(mysqli_connect_error()) {
            die("Failed to connect to MySQL: " . mysqli_connect_error());
        }
    }


    private function __clone() { }


    public function getConnection() {
        return $this->_connection;
    }
}
?>