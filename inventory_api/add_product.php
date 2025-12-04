<?php
include 'db_connect.php';

$json = file_get_contents('php://input');
$data = json_decode($json, true);

if (isset($data['name']) && isset($data['sku']) && isset($data['stock'])) {
    
    $name     = $data['name'];
    $sku      = $data['sku'];
    $category = isset($data['category']) ? $data['category'] : 'Uncategorized';
    $stock    = (int)$data['stock'];
    $price    = isset($data['price']) ? (double)$data['price'] : 0.0;

    $stmt = $connect->prepare("INSERT INTO products (name, sku, category, stock, price) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param("sssid", $name, $sku, $category, $stock, $price);

    if ($stmt->execute()) {
        echo json_encode([
            'success' => true,
            'message' => 'Produk berhasil ditambahkan'
        ]);
    } else {
        echo json_encode([
            'success' => false,
            'message' => 'Gagal menambah produk: ' . $stmt->error
        ]);
    }
    
    $stmt->close();

} else {
    echo json_encode([
        'success' => false,
        'message' => 'Data tidak lengkap! Nama, SKU, dan Stok wajib diisi.'
    ]);
}

$connect->close();
?>