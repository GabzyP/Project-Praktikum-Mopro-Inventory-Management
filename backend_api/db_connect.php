<?php

$host = "localhost";
$user = "root";
$pass = "";
$db   = "db_inventory";

$connect = new mysqli($host, $user, $pass, $db);

if ($connect->connect_error) {
    die("Koneksi Gagal: " . $connect->connect_error);
}

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}
?>