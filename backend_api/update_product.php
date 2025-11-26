<?php
include 'db_connect.php';
$json = file_get_contents('php://input');
$data = json_decode($json, true);

if (isset($data['id'])) {
    $id       = (int)$data['id'];
    $name     = $data['name'];
    $sku      = $data['sku'];
    $category = $data['category'];
    $stock    = (int)$data['stock'];
    $price    = (double)$data['price'];

    $stmt = $connect->prepare("UPDATE products SET name=?, sku=?, category=?, stock=?, price=? WHERE id=?");
    $stmt->bind_param("sssidi", $name, $sku, $category, $stock, $price, $id);

    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => 'Produk berhasil diupdate']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Gagal update']);
    }
}
?>