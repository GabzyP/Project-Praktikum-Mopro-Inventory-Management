<?php

$host = "localhost";
$user = "root";
$pass = "";
$db   = "db_inventory";

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

$connect = new mysqli($host, $user, $pass, $db);

if ($connect->connect_error) {
    die("Koneksi Gagal: " . $connect->connect_error);
}
?>