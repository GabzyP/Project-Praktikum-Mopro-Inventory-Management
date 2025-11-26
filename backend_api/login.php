<?php
include 'db_connect.php';

$json = file_get_contents('php://input');
$data = json_decode($json, true);

if (isset($data['email']) && isset($data['password'])) {
    $email = $data['email'];
    $password = $data['password'];

    $stmt = $connect->prepare("SELECT id, name, password FROM users WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();
        if (password_verify($password, $user['password'])) {
            echo json_encode([
                'success' => true, 
                'message' => 'Login berhasil',
                'user' => [
                    'id' => $user['id'],
                    'name' => $user['name']
                ]
            ]);
        } else {
            echo json_encode(['success' => false, 'message' => 'Password salah']);
        }
    } else {
        echo json_encode(['success' => false, 'message' => 'Email tidak ditemukan']);
    }
}
?>