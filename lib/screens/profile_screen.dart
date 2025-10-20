import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/user.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _usernameController;

  bool _isEditing = false;
  late String _dummyUsername;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullName);
    _emailController = TextEditingController(text: widget.user.email);
    _dummyUsername = widget.user.email.split('@').first;
    _usernameController = TextEditingController(text: _dummyUsername);

    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('user_full_name') ?? widget.user.fullName;
      _emailController.text = prefs.getString('user_email') ?? widget.user.email;
      _usernameController.text = prefs.getString('user_username') ?? _dummyUsername;
    });
  }

  void _toggleEditSave() {
    if (_isEditing) {
      _saveProfile();
    }
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_full_name', _nameController.text);
    await prefs.setString('user_email', _emailController.text);
    await prefs.setString('user_username', _usernameController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil disimpan!')),
    );
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/logout');
  }

  Widget _buildDetailField(String label, TextEditingController controller, bool canEdit) {
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
                    keyboardType: label == 'Email'
                        ? TextInputType.emailAddress
                        : TextInputType.name,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  )
                : Text(
                    controller.text,
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
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            tooltip: _isEditing ? 'Simpan Perubahan' : 'Ubah Profil',
            onPressed: _toggleEditSave,
          ),
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
            children: [
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
                      _buildDetailField('Name', _nameController, _isEditing),
                      const Divider(),
                      _buildDetailField('Username', _usernameController, false),
                      const Divider(),
                      _buildDetailField('Email', _emailController, _isEditing),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
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
