import 'package:flutter/material.dart';
// Asumsikan file user.dart memiliki model User dengan fullName dan email
import '/models/user.dart';

// 1. Ubah menjadi StatefulWidget
class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 2. Tambahkan Controller untuk mengelola input
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  // State untuk mengontrol mode edit
  bool _isEditing = false;
  
  // Asumsi: Jika model User memiliki properti username, ganti placeholder ini.
  late String _dummyUsername;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data user yang diterima
    _nameController = TextEditingController(text: widget.user.fullName);
    _emailController = TextEditingController(text: widget.user.email);
    
    // Username dummy dari prefix email
    _dummyUsername = widget.user.email.split('@').first;
  }

  @override
  void dispose() {
    // Bersihkan controller saat widget dihapus
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // 3. Fungsi untuk mengganti mode Edit/View dan menyimpan data
  void _toggleEditSave() {
    if (_isEditing) {
      // Jika mode edit, lakukan proses simpan
      _saveProfile();
    }
    // Ganti state untuk berpindah mode
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() {
    // ⚠️ Implementasi ini HANYA menyimpan ke state lokal (controller).
    // Untuk penyimpanan PERMANEN, Anda perlu:
    // 1. Memperbarui objek User di luar widget ini (misalnya, di parent widget/Provider/Bloc).
    // 2. Mengirim data ke database/API.

    final newFullName = _nameController.text;
    final newEmail = _emailController.text;

    // TODO: Validasi input (misalnya, format email)

    // Jika Anda ingin memperbarui objek User lokal:
    // widget.user.fullName = newFullName; // HANYA jika properti mutable (tidak disarankan)
    // Sebaiknya panggil fungsi callback ke parent untuk update global.

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil disimpan!')),
    );
  }

  void _logout() {
    // Navigasi ke rute logout
    Navigator.pushReplacementNamed(context, '/logout');
  }

  // Fungsi pembantu untuk membuat baris detail atau input field
  Widget _buildDetailField(String label, TextEditingController controller, bool isEditable) {
    // Untuk Username dan Email, kita pastikan hanya Username yang TIDAK bisa diedit
    final bool canEdit = isEditable && label != 'Username';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 90,
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
            child: canEdit
                ? TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: label == 'Email' ? TextInputType.emailAddress : TextInputType.name,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  )
                : Text(
                    // Jika tidak diedit, tampilkan teks biasa
                    label == 'Username' ? _dummyUsername : controller.text,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontStyle: label == 'Username' ? FontStyle.italic : FontStyle.normal,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Profil' : 'Profil Pengguna'),
        backgroundColor: Colors.indigo,
        actions: [
          // 4. Tombol Edit/Save
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            tooltip: _isEditing ? 'Simpan Perubahan' : 'Ubah Profil',
            onPressed: _toggleEditSave,
          ),
          // Tambahkan tombol Logout di AppBar saat tidak dalam mode edit
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Keluar (Logout)',
              onPressed: _logout,
            ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
              
              // Detail Pengguna dalam Card
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
                      _buildDetailField('Name', _nameController, _isEditing),
                      const Divider(),

                      // 2. Username (Tidak pernah bisa diedit, hanya ditampilkan)
                      // Menggunakan controller email untuk menampilkan dummy username
                      _buildDetailField('Username', _emailController, false), 
                      const Divider(),

                      // 3. Email
                      _buildDetailField('Email', _emailController, _isEditing),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Tombol Logout di body (hanya tampil saat mode view)
              if (!_isEditing)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _logout,
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