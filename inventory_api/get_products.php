<?php
include 'db_connect.php';

$response = array();

$sql = "SELECT * FROM products ORDER BY id DESC";
$result = $connect->query($sql);

if ($result->num_rows > 0) {
    $products = array();
    while ($row = $result->fetch_assoc()) {
        $row['id'] = (int)$row['id'];
        $row['stock'] = (int)$row['stock'];
        $row['price'] = (double)$row['price'];
        
        $products[] = $row;
    }

    echo json_encode([
        'success' => true,
        'message' => 'Data berhasil diambil',
        'data'    => $products
    ]);
} else {
    echo json_encode([
        'success' => true,
        'message' => 'Tidak ada data produk',
        'data'    => []
    ]);
}

$connect->close();
?>