<?php
include 'db_connect.php';
$json = file_get_contents('php://input');
$data = json_decode($json, true);

if (isset($data['id'])) {
    $id = (int)$data['id'];
    $stmt = $connect->prepare("DELETE FROM products WHERE id = ?");
    $stmt->bind_param("i", $id);

    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => 'Produk dihapus']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Gagal menghapus']);
    }
}
?>