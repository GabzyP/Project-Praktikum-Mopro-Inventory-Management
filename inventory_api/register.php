<?php
include 'db_connect.php';

$json = file_get_contents('php://input');
$data = json_decode($json, true);

if (isset($data['name']) && isset($data['email']) && isset($data['password'])) {
    $name = $data['name'];
    $email = $data['email'];
    $password = password_hash($data['password'], PASSWORD_DEFAULT);

    $check = $connect->query("SELECT id FROM users WHERE email = '$email'");
    if ($check->num_rows > 0) {
        echo json_encode(['success' => false, 'message' => 'Email sudah terdaftar']);
        exit();
    }

    $stmt = $connect->prepare("INSERT INTO users (name, email, password) VALUES (?, ?, ?)");
    $stmt->bind_param("sss", $name, $email, $password);

    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => 'Registrasi berhasil']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Gagal registrasi']);
    }
}
?>