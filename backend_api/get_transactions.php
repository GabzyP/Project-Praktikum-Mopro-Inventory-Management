<?php
include 'db_connect.php';

$sql = "SELECT t.*, p.name as product_name 
        FROM transactions t 
        JOIN products p ON t.product_id = p.id 
        ORDER BY t.created_at DESC";

$result = $connect->query($sql);
$transactions = array();

while ($row = $result->fetch_assoc()) {
    $transactions[] = $row;
}

echo json_encode(['success' => true, 'data' => $transactions]);
?>