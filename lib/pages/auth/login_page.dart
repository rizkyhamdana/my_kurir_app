import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_kurir_app/main.dart';
import 'package:my_kurir_app/models/user_model.dart';
import 'package:my_kurir_app/pages/auth/cubit/auth_cubit.dart';
import 'package:my_kurir_app/util/session_manager.dart';
import 'package:my_kurir_app/util/utility.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserRole _role = UserRole.customer; // Default ke Pelanggan
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      final phone = _phoneController.text.trim();
      final password = _passwordController.text.trim();
      final email = Utility.phoneToEmail(phone);

      // Panggil cubit login
      context.read<AuthCubit>().loginWithEmail(
        email: email,
        password: password,
        expectedRole: _role.name, // 'kurir' atau 'pelanggan'
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is AuthLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
        }
        if (state is AuthSuccess) {
          // Ambil role user dari Firestore jika perlu
          final userId = state.user?.uid;
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();
          final role = userDoc['role'] ?? 'customer';

          final userName = userDoc['name'] ?? '';
          final userPhone = userDoc['phone'] ?? '';
          await SessionManager.saveUserName(userName);
          await SessionManager.saveUserPhone(userPhone);

          await SessionManager.saveLoginSession(userId ?? '', role);

          if (role == UserRole.courier.name) {
            if (!context.mounted) return;
            context.go('/kurir-home');
          } else {
            if (!context.mounted) return;
            context.go('/home');
          }
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDarkMode
                  ? [
                      const Color(0xFF0A0E21),
                      const Color(0xFF1D1E33),
                      const Color(0xFF0A0E21),
                    ]
                  : [
                      const Color(0xFFE8F0FE),
                      const Color(0xFFF8F9FB),
                      const Color(0xFFE8F0FE),
                    ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImageIcon(
                      const AssetImage('assets/ic_transparent_bg.png'),
                      size: 70,
                      color: isDarkMode
                          ? const Color(0xFF43e97b)
                          : const Color(0xFF667eea),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Login Kurir Atapange',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Pilih Role
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildRoleButton(
                          context,
                          UserRole.customer,
                          'Pelanggan',
                          Icons.person_rounded,
                        ),
                        const SizedBox(width: 16),
                        _buildRoleButton(
                          context,
                          UserRole.courier,
                          'Kurir',
                          Icons.delivery_dining_rounded,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Form Login
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'No. WhatsApp',
                              prefixIcon: const Icon(Icons.phone_rounded),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (v) => v == null || v.isEmpty
                                ? 'Nomor wajib diisi'
                                : null,
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_rounded),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (v) => v == null || v.isEmpty
                                ? 'Password wajib diisi'
                                : null,
                          ),
                          const SizedBox(height: 28),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDarkMode
                                    ? const Color(0xFF43e97b)
                                    : const Color(0xFF667eea),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: _isLoading ? null : _handleLogin,
                              // : () {
                              // if (_formKey.currentState?.validate() ??
                              //     false) {
                              //   setState(() => _isLoading = true);
                              //   // Simulasi login
                              //   Future.delayed(
                              //     const Duration(seconds: 1),
                              //     () {
                              //       setState(() => _isLoading = false);
                              //       // TODO: Ganti dengan navigasi sesuai role
                              //       ScaffoldMessenger.of(
                              //         context,
                              //       ).showSnackBar(
                              //         SnackBar(
                              //           content: Text(
                              //             _role == LoginRole.kurir
                              //                 ? 'Login sebagai Kurir'
                              //                 : 'Login sebagai Pelanggan',
                              //           ),
                              //         ),
                              //       );
                              //     },
                              //   );
                              // }
                              //   _role == LoginRole.kurir
                              //       ? context.go('/kurir-home')
                              //       : context.go('/home');
                              // },
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      _role == UserRole.courier
                                          ? 'Login sebagai Kurir'
                                          : 'Login sebagai Pelanggan',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        context.push('/register');
                      },
                      child: Text(
                        'Belum punya akun? Daftar',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    IconButton(
                      icon: Icon(
                        isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                      tooltip: 'Ganti Tema',
                      onPressed: () {
                        themeNotifier.value = isDarkMode
                            ? ThemeMode.light
                            : ThemeMode.dark;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton(
    BuildContext context,
    UserRole role,
    String label,
    IconData icon,
  ) {
    final isSelected = _role == role;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _role = role),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: role == UserRole.courier
                        ? [const Color(0xFF43e97b), const Color(0xFF38f9d7)]
                        : [const Color(0xFF667eea), const Color(0xFF764ba2)],
                  )
                : null,
            color: isSelected
                ? null
                : (isDarkMode
                      ? Colors.white.withAlpha(13)
                      : Colors.black.withAlpha(10)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : (isDarkMode ? Colors.white24 : Colors.black12),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : (isDarkMode ? Colors.white : Colors.black87),
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isDarkMode ? Colors.white : Colors.black87),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
