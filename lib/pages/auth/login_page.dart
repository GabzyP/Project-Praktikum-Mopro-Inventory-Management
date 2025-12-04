import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'register_page.dart';
import '../../utils/user_session.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final ApiService apiService = ApiService();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.inventory_2_rounded,
                    size: 50,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  "Selamat Datang",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                Text(
                  "Masuk untuk mengelola inventori",
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),

                TextField(
                  controller: emailC,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "gabrielstudyacc@gmail.com",
                    hintStyle: TextStyle(
                      color: isDark ? Colors.grey[600] : Colors.grey[400],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: theme.cardColor,
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: passC,
                  obscureText: true,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.lock_outline),
                    filled: true,
                    fillColor: theme.cardColor,
                  ),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "MASUK",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Belum punya akun?",
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text("Daftar Sekarang"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    String email = emailC.text.trim();
    String password = passC.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError("Email dan Password harus diisi");
      return;
    }
    if (!email.contains("@") || !email.contains(".")) {
      _showError("Format email tidak valid");
      return;
    }
    if (password.length < 6) {
      _showError("Password minimal 6 karakter");
      return;
    }

    setState(() => isLoading = true);

    final result = await apiService.login(email, password);

    setState(() => isLoading = false);

    if (result['success'] == true) {
      var userData = result['user'];

      int userId = int.tryParse(userData['id'].toString()) ?? 0;
      String userName = userData['name'] ?? "User";
      String userEmail = userData['email'] ?? "";

      UserSession.saveSession(userId, userName, userEmail);
      // -----------------------------

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Selamat datang, $userName!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        _showError(result['message'] ?? "Login gagal");
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
