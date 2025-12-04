<?php
include 'db_connect.php';

$json = file_get_contents('php://input');
$data = json_decode($json, true);

if (
    isset($data['product_id']) && 
    isset($data['type']) && 
    isset($data['amount'])
) {
    $product_id = (int)$data['product_id'];
    $type       = $data['type'];
    $amount     = (int)$data['amount'];
    $notes      = isset($data['notes']) ? $data['notes'] : '';

    $connect->begin_transaction();

    try {
        $stmt1 = $connect->prepare("INSERT INTO transactions (product_id, type, amount, notes) VALUES (?, ?, ?, ?)");
        $stmt1->bind_param("isis", $product_id, $type, $amount, $notes);
        $stmt1->execute();

        if ($type == 'IN') {
            $stmt2 = $connect->prepare("UPDATE products SET stock = stock + ? WHERE id = ?");
        } else {
            $cek = $connect->query("SELECT stock FROM products WHERE id = $product_id");
            $row = $cek->fetch_assoc();
            if ($row['stock'] < $amount) {
                throw new Exception("Stok tidak cukup");
            }
            $stmt2 = $connect->prepare("UPDATE products SET stock = stock - ? WHERE id = ?");
        }
        
        $stmt2->bind_param("ii", $amount, $product_id);
        $stmt2->execute();

        $connect->commit();
        echo json_encode(['success' => true, 'message' => 'Transaksi berhasil']);

    } catch (Exception $e) {
        $connect->rollback();
        echo json_encode(['success' => false, 'message' => 'Gagal: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Data tidak lengkap']);
}
?>