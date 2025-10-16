import 'package:flutter/material.dart';
import '/models/user.dart';

class ProfileScreen extends StatelessWidget {
  // Tambahkan properti untuk menerima data user
  final User user;

  // Ubah constructor untuk menerima user
  const ProfileScreen({super.key, required this.user});

  // Fungsi pembantu untuk membuat baris detail
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90, // Lebar tetap untuk label
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Asumsi: Jika model User memiliki properti username, ganti placeholder ini.
    // Karena model User tidak terlihat, saya menggunakan placeholder atau bagian dari email
    // Jika Anda ingin mengimplementasikan properti ini, Anda harus menambahkannya di '/models/user.dart'
    final String dummyUsername = user.email.split('@').first;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
        backgroundColor: Colors.indigo,
        // Tombol kembali otomatis muncul jika di-push
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Ubah ke start untuk layout yang lebih rapi
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.indigo.shade100,
                child: Icon(
                  Icons.account_circle,
                  size: 80,
                  color: Colors.indigo.shade600,
                ),
              ),
              const SizedBox(height: 40),
              
              // Detail Pengguna dalam Card agar lebih terstruktur
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // 1. Nama Lengkap
                      _buildDetailRow('Name', user.fullName),
                      const Divider(),

                      // 2. Username (Menggunakan email prefix sebagai dummy)
                      _buildDetailRow('Username', dummyUsername),
                      const Divider(),

                      // 3. Email
                      _buildDetailRow('Email', user.email),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Tombol Logout
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/logout');
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    'Keluar (Logout)',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}