import 'package:flutter/material.dart';
import '../models/user.dart'; // pastikan model user diimport
import 'expense_screen.dart'; // Asumsi Anda punya file ini
import 'advanced_expense_list_screen.dart'; // Asumsi Anda punya file ini
import 'cart_screen.dart'; // PASTIKAN Anda membuat dan mengimpor file ini

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> products = [
    {"title": "Handphone Baru", "icon": Icons.phone_android, "color": Colors.blue},
    {"title": "Headset Gaming", "icon": Icons.headphones, "color": Colors.redAccent},
    {"title": "Kamera DSLR", "icon": Icons.camera_alt, "color": Colors.teal},
    {"title": "Tas Belanja", "icon": Icons.shopping_bag, "color": Colors.purple},
  ];

  // List of Widgets untuk Body
  final List<Widget> _widgetOptions = <Widget>[
    // Index 0: Home/Dashboard
    const ProductDashboard(),
    // Index 1: Cart
    const CartScreen(), 
    // Index 2: Profile (Akan dialihkan ke Index 0 karena Profile menggunakan pushNamed)
    const ProductDashboard(), 
  ];

  // Fungsi _onItemTapped dimodifikasi untuk navigasi Profile
  void _onItemTapped(int index) {
    if (index == 2) { // Index 2 adalah "Profil"
      // Navigasi ke ProfileScreen menggunakan rute bernama
      Navigator.pushNamed(
        context,
        '/profile',
        arguments: widget.user,
      ).then((_) {
        // Setelah kembali dari ProfileScreen, set index kembali ke Home (0)
        setState(() {
          _selectedIndex = 0;
        });
      });
    } else {
      // Untuk Home (0) dan Cart (1), cukup ganti selectedIndex
      setState(() {
        _selectedIndex = index;
      });
    }
  }
  
  // Widget _buildDashboardCard ditingkatkan (tetap di State class untuk akses products)
  Widget _buildDashboardCard(String title, IconData icon, Color color) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Kamu klik $title")),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
             gradient: LinearGradient(
              colors: [color.withOpacity(0.1), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan judul AppBar secara dinamis
    String appBarTitle;
    if (_selectedIndex == 0) {
      appBarTitle = 'Halo, ${widget.user.username}!';
    } else if (_selectedIndex == 1) {
      appBarTitle = 'Keranjang Belanja';
    } else {
      appBarTitle = 'Home';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/logout');
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      
      // Menggunakan body berdasarkan _selectedIndex
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
          
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                widget.user.fullName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(widget.user.email),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.indigo),
              ),
              decoration: const BoxDecoration(color: Colors.indigo),
            ),
            
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Keranjang'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer
                _onItemTapped(2); // Panggil fungsi navigasi Profile
              },
            ),
            ListTile(
              leading: const Icon(Icons.money),
              title: const Text('Expenses (Basic)'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExpenseScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Expenses (Advanced)'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdvancedExpenseListScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/logout');
              },
            ),
          ],
        ),
      ),
      
      // BottomNavigationBar yang diperbarui
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey.shade600,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Keranjang"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
      
      // FloatingActionButton hanya tampil di Home Screen
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: Colors.indigoAccent,
              foregroundColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Tambahkan produk baru!")),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

// Widget untuk body utama HomeScreen (Dashboard Produk)
class ProductDashboard extends StatelessWidget {
  const ProductDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Akses state products dan _buildDashboardCard dari parent widget
    final _HomeScreenState state = context.findAncestorStateOfType<_HomeScreenState>()!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Produk Terbaru',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: state.products
                  .map((product) => state._buildDashboardCard(
                        product['title'],
                        product['icon'],
                        product['color'],
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}