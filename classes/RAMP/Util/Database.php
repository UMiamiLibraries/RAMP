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

require_once( dirname(dirname(dirname( dirname(__FILE__)))) . DIRECTORY_SEPARATOR . "conf" . DIRECTORY_SEPARATOR . "db.php" );

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
   	global $db_host, $db_user, $db_pass, $db_default, $db_port;

   	$this->_host = "127.0.0.1";
   	$this->_username = "root";
   	$this->_password = "root";
   	$this->_database = "ead_eac";
   	$this->_port = "8889";

   	$this->_connection = new \mysqli($this->_host, $this->_username, $this->_password, $this->_database, $this->_port);

     if(mysqli_connect_error()) {

       die("Failed to conencto to MySQL: " . mysqli_connect_error());
     }
   }


   private function __clone() { }


   public function getConnection() {
     return $this->_connection;
   }
 }
