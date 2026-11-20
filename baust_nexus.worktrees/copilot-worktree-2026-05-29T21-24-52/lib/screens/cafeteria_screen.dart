import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../services/auth_service.dart';
import '../services/cafeteria_service.dart';
import '../models/cafeteria_model.dart';

class CafeteriaScreen extends StatefulWidget {
  const CafeteriaScreen({super.key});

  @override
  State<CafeteriaScreen> createState() => _CafeteriaScreenState();
}

class _CafeteriaScreenState extends State<CafeteriaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isOrdering = false;

  final List<CafeteriaItem> _menuItems = [
    CafeteriaItem(
        id: '1',
        name: 'Milk Tea',
        category: 'Beverages',
        price: 10,
        image: '🫖',
        available: true),
    CafeteriaItem(
        id: '2',
        name: 'Coffee',
        category: 'Beverages',
        price: 20,
        image: '☕',
        available: true),
    CafeteriaItem(
        id: '3',
        name: 'Cake Slice',
        category: 'Desserts',
        price: 30,
        image: '🍰',
        available: true),
    CafeteriaItem(
        id: '4',
        name: 'Biscuits',
        category: 'Snacks',
        price: 10,
        image: '🍪',
        available: true),
    CafeteriaItem(
        id: '5',
        name: 'Samosa',
        category: 'Snacks',
        price: 10,
        image: '🥟',
        available: true),
    CafeteriaItem(
        id: '6',
        name: 'Puri',
        category: 'Breakfast',
        price: 15,
        image: '🥟',
        available: true),
    CafeteriaItem(
        id: '7',
        name: 'Vegetable Roll',
        category: 'Snacks',
        price: 20,
        image: '🥖',
        available: true),
    CafeteriaItem(
        id: '8',
        name: 'Burger',
        category: 'Fast Food',
        price: 55,
        image: '🍔',
        available: true),
    CafeteriaItem(
        id: '9',
        name: 'Pizza Slice',
        category: 'Fast Food',
        price: 60,
        image: '🍕',
        available: true),
    CafeteriaItem(
        id: '10',
        name: 'Cold Drink',
        category: 'Beverages',
        price: 25,
        image: '🥤',
        available: true),
    CafeteriaItem(
        id: '11',
        name: 'Juice',
        category: 'Beverages',
        price: 30,
        image: '🧃',
        available: true),
    CafeteriaItem(
        id: '12',
        name: 'Bread Toast',
        category: 'Breakfast',
        price: 20,
        image: '🍞',
        available: true),
    CafeteriaItem(
        id: '13',
        name: 'Boiled Egg',
        category: 'Breakfast',
        price: 15,
        image: '🥚',
        available: true),
    CafeteriaItem(
        id: '14',
        name: 'Omelette',
        category: 'Breakfast',
        price: 20,
        image: '🍳',
        available: true),
    CafeteriaItem(
        id: '15',
        name: 'Special Biryani',
        category: 'Special',
        price: 120,
        image: '🍛',
        available: true),
    CafeteriaItem(
        id: '16',
        name: 'Chicken Kabab',
        category: 'Special',
        price: 90,
        image: '🍗',
        available: true),
    CafeteriaItem(
        id: '17',
        name: 'Mutton Rezala',
        category: 'Special',
        price: 150,
        image: '🍲',
        available: true),
    CafeteriaItem(
        id: '18',
        name: 'Fish Fry Platter',
        category: 'Special',
        price: 100,
        image: '🐟',
        available: true),
    CafeteriaItem(
        id: '19',
        name: 'Chowmein Combo',
        category: 'Special',
        price: 80,
        image: '🍜',
        available: true),
    CafeteriaItem(
        id: '20',
        name: 'BBQ Chicken',
        category: 'Special',
        price: 130,
        image: '🍗',
        available: true),
    CafeteriaItem(
        id: '21',
        name: 'Special Weekend Breakfast',
        category: 'Special',
        price: 65,
        image: '🥣',
        available: true),
    CafeteriaItem(
        id: '22',
        name: 'Special Snacks Combo',
        category: 'Special',
        price: 75,
        image: '🍱',
        available: true),
    CafeteriaItem(
        id: '23',
        name: 'Weekend Special Thali',
        category: 'Special',
        price: 200,
        image: '🍛',
        available: true),
    CafeteriaItem(
        id: '24',
        name: 'Chicken Roll',
        category: 'Snacks',
        price: 50,
        image: '🌯',
        available: true),
    CafeteriaItem(
        id: '25',
        name: 'French Fries',
        category: 'Snacks',
        price: 40,
        image: '🍟',
        available: true),
    CafeteriaItem(
        id: '26',
        name: 'Shawarma',
        category: 'Fast Food',
        price: 70,
        image: '🥙',
        available: true),
    CafeteriaItem(
        id: '27',
        name: 'Momos',
        category: 'Snacks',
        price: 60,
        image: '🥟',
        available: true),
    CafeteriaItem(
        id: '28',
        name: 'Cold Coffee',
        category: 'Beverages',
        price: 35,
        image: '🥤',
        available: true),
    CafeteriaItem(
        id: '29',
        name: 'Chicken Sandwich',
        category: 'Fast Food',
        price: 65,
        image: '🥪',
        available: true),
    CafeteriaItem(
        id: '30',
        name: 'Vegetable Salad',
        category: 'Healthy',
        price: 45,
        image: '🥗',
        available: true),
  ];

  final Map<String, List<Map<String, String>>> _weeklyMenu = {
    'Saturday': [
      {
        'meal': 'Breakfast',
        'description': 'Porota, Dal, Sobji, Egg, Tea',
        'price': '45 Tk'
      },
      {
        'meal': 'Lunch',
        'description': 'Rice, Fish Curry, Dal, Mixed Vegetable, Salad',
        'price': '65 Tk'
      },
      {
        'meal': 'Snacks',
        'description': 'Samosa, Singara, Tea/Coffee',
        'price': '25 Tk'
      },
      {
        'meal': 'Special Offer',
        'description': 'Special Biryani',
        'price': '120 Tk'
      },
    ],
    'Sunday': [
      {
        'meal': 'Breakfast',
        'description': 'Ruti, Sobji, Egg, Tea',
        'price': '40 Tk'
      },
      {
        'meal': 'Lunch',
        'description': 'Rice, Beef Curry, Dal, Bharta, Salad',
        'price': '80 Tk'
      },
      {'meal': 'Snacks', 'description': 'Pizza Slice, Juice', 'price': '60 Tk'},
      {
        'meal': 'Special Offer',
        'description': 'Chicken Kebab',
        'price': '90 Tk'
      },
    ],
    'Monday': [
      {
        'meal': 'Breakfast',
        'description': 'Chapati, Dal, Egg, Tea',
        'price': '35 Tk'
      },
      {
        'meal': 'Lunch',
        'description': 'Chicken Biryani, Borhani, Salad',
        'price': '85 Tk'
      },
      {'meal': 'Snacks', 'description': 'Burger, Cold Drink', 'price': '55 Tk'},
      {
        'meal': 'Special Offer',
        'description': 'Mutton Rezala',
        'price': '150 Tk'
      },
    ],
    'Tuesday': [
      {
        'meal': 'Breakfast',
        'description': 'Puri, Chana, Sweet, Tea',
        'price': '45 Tk'
      },
      {
        'meal': 'Lunch',
        'description': 'Rice, Mutton Curry, Dal, Salad, Firni',
        'price': '95 Tk'
      },
      {'meal': 'Snacks', 'description': 'Cake, Coffee', 'price': '40 Tk'},
      {
        'meal': 'Special Offer',
        'description': 'Fish Fry Platter',
        'price': '100 Tk'
      },
    ],
    'Wednesday': [
      {
        'meal': 'Breakfast',
        'description': 'Sandwich, Juice, Fruit',
        'price': '55 Tk'
      },
      {
        'meal': 'Lunch',
        'description': 'Rice, Fish Fry, Dal, Mixed Vegetable, Salad',
        'price': '70 Tk'
      },
      {'meal': 'Snacks', 'description': 'Chicken Roll, Tea', 'price': '45 Tk'},
      {
        'meal': 'Special Offer',
        'description': 'Chowmein Combo',
        'price': '80 Tk'
      },
    ],
    'Thursday': [
      {
        'meal': 'Breakfast',
        'description': 'Noodles, Egg, Tea/Coffee',
        'price': '45 Tk'
      },
      {
        'meal': 'Lunch',
        'description': 'Khichuri, Beef Bhuna, Egg, Pickle',
        'price': '75 Tk'
      },
      {
        'meal': 'Snacks',
        'description': 'French Fries, Burger, Cold Drink',
        'price': '65 Tk'
      },
      {
        'meal': 'Special Offer',
        'description': 'BBQ Chicken',
        'price': '130 Tk'
      },
    ],
    'Friday': [
      {
        'meal': 'Breakfast',
        'description': 'Special Weekend Breakfast',
        'price': '65 Tk'
      },
      {
        'meal': 'Lunch',
        'description': 'Special Biryani, Kebab, Salad, Dessert',
        'price': '110 Tk'
      },
      {
        'meal': 'Snacks',
        'description': 'Special Snacks Combo',
        'price': '75 Tk'
      },
      {
        'meal': 'Special Offer',
        'description': 'Weekend Special Thali',
        'price': '200 Tk'
      },
    ],
  };

  final Map<String, int> _cart = {};
  String _selectedCategory = 'All';
  String _selectedPaymentMethod = 'cash';
  final TextEditingController _bkashNumberCtrl = TextEditingController();
  final TextEditingController _bkashPinCtrl = TextEditingController();
  final TextEditingController _nagadNumberCtrl = TextEditingController();
  final TextEditingController _nagadPinCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bkashNumberCtrl.dispose();
    _bkashPinCtrl.dispose();
    _nagadNumberCtrl.dispose();
    _nagadPinCtrl.dispose();
    super.dispose();
  }

  List<CafeteriaItem> get _filteredItems {
    if (_selectedCategory == 'All') return _menuItems;
    return _menuItems
        .where((item) => item.category == _selectedCategory)
        .toList();
  }

  double get _cartTotal {
    double total = 0;
    _cart.forEach((itemId, quantity) {
      final item = _menuItems.firstWhere((i) => i.id == itemId);
      total += item.price * quantity;
    });
    return total;
  }

  int get _cartItemCount => _cart.values.fold(0, (sum, qty) => sum + qty);

  String _generateToken() =>
      'CAF${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
  String _generateTransactionId() =>
      'TXN${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

  void _addToCart(String itemId) =>
      setState(() => _cart[itemId] = (_cart[itemId] ?? 0) + 1);
  void _removeFromCart(String itemId) {
    setState(() {
      if (_cart[itemId] != null && _cart[itemId]! > 0) {
        _cart[itemId] = _cart[itemId]! - 1;
        if (_cart[itemId] == 0) _cart.remove(itemId);
      }
    });
  }

  void _clearCart() => setState(() => _cart.clear());

  String? _validatePayment() {
    if (_selectedPaymentMethod == 'bkash') {
      final number = _bkashNumberCtrl.text.trim();
      if (number.isEmpty) {
        return 'Please provide bKash number';
      }
      if (!RegExp(r'^01[0-9]{9}$').hasMatch(number)) {
        return 'Enter valid 11-digit bKash number';
      }
    }
    if (_selectedPaymentMethod == 'nagad') {
      final number = _nagadNumberCtrl.text.trim();
      if (number.isEmpty) {
        return 'Please provide Nagad number';
      }
      if (!RegExp(r'^01[0-9]{9}$').hasMatch(number)) {
        return 'Enter valid 11-digit Nagad number';
      }
    }
    return null;
  }

  void _showQRDialog(String type) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('📱 Pay with $type',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(type == 'bKash' ? Icons.qr_code : Icons.qr_code_2,
                        size: 90,
                        color: type == 'bKash' ? Colors.pink : Colors.red),
                    const SizedBox(height: 8),
                    Text('Scan QR to Pay',
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    Text('Merchant: 017XXXXXXXX',
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: Colors.grey)),
                  ]),
            ),
          ),
          const SizedBox(height: 16),
          Text('Amount: ৳${_cartTotal.toStringAsFixed(0)}',
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E3A8A))),
        ]),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A)),
              child: const Text('Done', style: TextStyle(color: Colors.white)))
        ],
      ),
    );
  }

  void _placeOrder() async {
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('❌ Cart is empty'), backgroundColor: AppColors.error));
      return;
    }
    final validationError = _validatePayment();
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(validationError), backgroundColor: AppColors.error));
      return;
    }

    final user = context.read<AuthService>().currentUser;
    if (user == null) return;

    setState(() => _isOrdering = true);

    try {
      final items = _cart.entries.map((entry) {
        final item = _menuItems.firstWhere((i) => i.id == entry.key);
        return {
          'id': item.id,
          'name': item.name,
          'price': item.price,
          'quantity': entry.value,
          'subtotal': item.price * entry.value
        };
      }).toList();

      final token = _generateToken();
      final transactionId = (_selectedPaymentMethod == 'bkash' ||
              _selectedPaymentMethod == 'nagad')
          ? _generateTransactionId()
          : null;

      final order = CafeteriaOrder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.id,
        userName: user.name,
        userDept: user.department ?? 'Unknown',
        userPhone: user.phoneNumber,
        items: items,
        totalAmount: _cartTotal,
        paymentMethod: _selectedPaymentMethod,
        status: 'pending',
        orderTime: DateTime.now(),
        token: token,
        bkashNumber: _selectedPaymentMethod == 'bkash'
            ? _bkashNumberCtrl.text.trim()
            : null,
        nagadNumber: _selectedPaymentMethod == 'nagad'
            ? _nagadNumberCtrl.text.trim()
            : null,
        transactionId: transactionId,
      );

      await CafeteriaService.addOrder(order);
      _clearCart();
      _bkashNumberCtrl.clear();
      _bkashPinCtrl.clear();
      _nagadNumberCtrl.clear();
      _nagadPinCtrl.clear();

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 30),
            SizedBox(width: 10),
            Text('✅ Order Placed')
          ]),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(children: [
                Text('Your Token', style: GoogleFonts.poppins(fontSize: 12)),
                const SizedBox(height: 4),
                Text('TOKEN #$token',
                    style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success)),
                const SizedBox(height: 8),
                Text('💰 Token diye khabar nin!',
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w500)),
              ]),
            ),
          ]),
          actions: [
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success),
                    child: const Text('OK',
                        style: TextStyle(color: Colors.white))))
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'), backgroundColor: AppColors.error));
    } finally {
      setState(() => _isOrdering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser;
    final cartItemCount = _cartItemCount;
    const primaryColor = Color(0xFF1E3A8A); // ডার্ক নেভি ব্লু কালার থিম

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text('Miritika Cafeteria',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: const [
            Tab(icon: Icon(Icons.restaurant_menu, size: 20), text: 'Menu'),
            Tab(
                icon: Icon(Icons.shopping_cart_outlined, size: 20),
                text: 'Cart'),
            Tab(
                icon: Icon(Icons.assignment_outlined, size: 20),
                text: 'Orders'),
          ],
        ),
        actions: [
          if (cartItemCount > 0)
            Container(
              margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                  child: Text('$cartItemCount',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12))),
            ),
        ],
      ),
      body: _isOrdering
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildMenuTab(primaryColor),
                _buildCartTab(primaryColor),
                _buildOrdersTab(user?.id ?? ''),
              ],
            ),
    );
  }

  // ============ MENU TAB ============
  Widget _buildMenuTab(Color primaryColor) {
    final categories = [
      'All',
      ..._menuItems.map((item) => item.category).toSet()
    ];
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 900
        ? 4
        : screenWidth > 640
            ? 3
            : 2;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 8))
              ],
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.restaurant_menu, color: Colors.white),
                const SizedBox(width: 8),
                Text('Miritika Cafeteria',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))
              ]),
              const SizedBox(height: 10),
              Text('Payment kore token nin! Token diye khabar nin!',
                  style:
                      GoogleFonts.poppins(fontSize: 13, color: Colors.white70)),
              const SizedBox(height: 8),
              Row(children: [
                const Icon(Icons.schedule, color: Colors.white70, size: 16),
                const SizedBox(width: 6),
                Text('8:00 AM - 8:00 PM',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.white70)),
                const SizedBox(width: 14),
                const Icon(Icons.location_on, color: Colors.white70, size: 16),
                const SizedBox(width: 6),
                Text('Ground Floor',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.white70))
              ]),
            ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/cafeteria.jpeg',
              width: double.infinity,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
          child: Text('Fast Menu & Categories',
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800)),
        ),
        SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (ctx, i) {
              final cat = categories[i];
              final selected = _selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: selected,
                  selectedColor: primaryColor,
                  backgroundColor: Colors.white,
                  labelStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      color: selected ? Colors.white : primaryColor,
                      fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: primaryColor, width: 1)),
                  onSelected: (_) => setState(() => _selectedCategory = cat),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.78,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14),
            itemCount: _filteredItems.length,
            itemBuilder: (ctx, i) =>
                _buildMenuItem(_filteredItems[i], primaryColor),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(children: [
            const Icon(Icons.calendar_month, color: Colors.redAccent, size: 22),
            const SizedBox(width: 8),
            Text('Weekly Menu',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
          ]),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: _weeklyMenu.entries
                .map((entry) =>
                    _buildWeeklyMenuCard(entry.key, entry.value, primaryColor))
                .toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildMenuItem(CafeteriaItem item, Color primaryColor) {
    final qty = _cart[item.id] ?? 0;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 6,
                offset: const Offset(0, 3))
          ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: const Color(0xFFEEF2F6),
                borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withValues(alpha: 0.14),
                      Colors.white
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(_categoryIcon(item.category),
                      size: 36, color: _categoryColor(item.category)),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(item.name,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center),
        ),
        const SizedBox(height: 2),
        Text('৳${item.price.toStringAsFixed(0)}',
            style: GoogleFonts.poppins(
                fontSize: 14,
                color: primaryColor,
                fontWeight: FontWeight.bold)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: qty == 0
              ? SizedBox(
                  width: double.infinity,
                  height: 34,
                  child: ElevatedButton(
                    onPressed: () => _addToCart(item.id),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: const Text('Add to Cart',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ),
                )
              : Container(
                  height: 34,
                  decoration: BoxDecoration(
                      color: const Color(0xFFEEF2F6),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () => _removeFromCart(item.id),
                            icon: const Icon(Icons.remove, size: 16),
                            color: primaryColor,
                            padding: EdgeInsets.zero),
                        Text('$qty',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black87)),
                        IconButton(
                            onPressed: () => _addToCart(item.id),
                            icon: const Icon(Icons.add, size: 16),
                            color: primaryColor,
                            padding: EdgeInsets.zero),
                      ]),
                ),
        ),
      ]),
    );
  }

  // ============ CART TAB ============
  Widget _buildCartTab(Color primaryColor) {
    if (_cart.isEmpty) {
      return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.shopping_cart_outlined, size: 70, color: Colors.grey),
        const SizedBox(height: 12),
        Text('Cart is empty',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey))
      ]));
    }
    return Column(children: [
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('🛒 Your Selected Cart',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ..._cart.entries.map((e) {
              final item = _menuItems.firstWhere((i) => i.id == e.key);
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200)),
                child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(children: [
                      Text(item.image, style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(item.name,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold, fontSize: 13)),
                            Text(
                                '৳${item.price} × ${e.value} = ৳${item.price * e.value}',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey, fontSize: 12))
                          ])),
                      IconButton(
                          onPressed: () => _removeFromCart(item.id),
                          icon: const Icon(Icons.remove_circle_outline,
                              color: AppColors.error)),
                      Text('${e.value}',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                      IconButton(
                          onPressed: () => _addToCart(item.id),
                          icon: const Icon(Icons.add_circle_outline,
                              color: AppColors.success)),
                    ])),
              );
            }),
            const Divider(height: 24),
            Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Payable:',
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      Text('৳${_cartTotal.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryColor))
                    ])),
            const SizedBox(height: 16),
            Text('💳 Select Payment Method',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _paymentChip('💵 Cash', 'cash', Colors.green)),
              const SizedBox(width: 6),
              Expanded(child: _paymentChip('📱 bKash', 'bkash', Colors.pink)),
              const SizedBox(width: 6),
              Expanded(child: _paymentChip('📱 Nagad', 'nagad', Colors.red)),
            ]),
            const SizedBox(height: 12),
            if (_selectedPaymentMethod == 'bkash') ...[
              _buildQRButton('bKash'),
              const SizedBox(height: 10),
              TextField(
                  controller: _bkashNumberCtrl,
                  decoration: const InputDecoration(
                      labelText: 'bKash Wallet Number',
                      hintText: '017XXXXXXXX',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone_android)),
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 8),
              TextField(
                  controller: _bkashPinCtrl,
                  decoration: const InputDecoration(
                      labelText: 'bKash Interal PIN',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                  keyboardType: TextInputType.number),
            ],
            if (_selectedPaymentMethod == 'nagad') ...[
              _buildQRButton('Nagad'),
              const SizedBox(height: 10),
              TextField(
                  controller: _nagadNumberCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Nagad Wallet Number',
                      hintText: '01XXXXXXXXX',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone_android)),
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 8),
              TextField(
                  controller: _nagadPinCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Nagad PIN',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                  keyboardType: TextInputType.number),
            ],
          ]),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              spreadRadius: 1)
        ]),
        child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
                onPressed: _placeOrder,
                icon:
                    const Icon(Icons.check_circle_outline, color: Colors.white),
                label: Text('PLACE ORDER (৳${_cartTotal.toStringAsFixed(0)})',
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))))),
      )
    ]);
  }

  Widget _paymentChip(String label, String value, Color color) {
    final selected = _selectedPaymentMethod == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _selectedPaymentMethod = value),
      backgroundColor: Colors.white,
      selectedColor: color.withValues(alpha: 0.2),
      labelStyle: GoogleFonts.poppins(
          fontSize: 12,
          color: selected ? color : Colors.black87,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: selected ? color : Colors.grey.shade300)),
    );
  }

  Widget _buildQRButton(String type) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showQRDialog(type),
        icon: const Icon(Icons.qr_code_scanner),
        label: Text('Open QR Code Interface ($type)',
            style: GoogleFonts.poppins(fontSize: 12)),
        style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF1E3A8A),
            side: const BorderSide(color: Color(0xFF1E3A8A)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(vertical: 12)),
      ),
    );
  }

  Widget _buildWeeklyMenuCard(
      String day, List<Map<String, String>> items, Color primaryColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 2,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        collapsedBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        title: Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, primaryColor.withValues(alpha: 0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
                child: Icon(_weekdayIcon(day), color: Colors.white, size: 22)),
          ),
          const SizedBox(width: 12),
          Text(day,
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.bold)),
        ]),
        children: items.map((item) {
          final meal = item['meal'] ?? '';
          final description = item['description'] ?? '';
          final price = item['price'] ?? '';
          final mealColor = _mealColor(meal);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [mealColor, mealColor.withValues(alpha: 0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                ),
                child: Center(
                  child: Icon(_mealIcon(meal), color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(meal,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(description,
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey.shade700)),
                  ])),
              Column(children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                      color: mealColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(price,
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: mealColor)),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Order from the cafeteria menu below or ask admin to enable quick order for $meal.')),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: mealColor,
                      minimumSize: const Size(80, 34),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text('Order',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ]),
            ]),
          );
        }).toList(),
      ),
    );
  }

  Color _mealColor(String meal) {
    switch (meal.toLowerCase()) {
      case 'breakfast':
        return const Color(0xFFF59E0B);
      case 'lunch':
        return const Color(0xFF2563EB);
      case 'snacks':
        return const Color(0xFFEF4444);
      case 'special offer':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData _mealIcon(String meal) {
    switch (meal.toLowerCase()) {
      case 'breakfast':
        return Icons.free_breakfast;
      case 'lunch':
        return Icons.lunch_dining;
      case 'snacks':
        return Icons.fastfood;
      case 'special offer':
        return Icons.local_offer;
      default:
        return Icons.restaurant;
    }
  }

  IconData _weekdayIcon(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return Icons.work;
      case 'tuesday':
        return Icons.local_fire_department;
      case 'wednesday':
        return Icons.wb_sunny;
      case 'thursday':
        return Icons.nightlife;
      case 'friday':
        return Icons.weekend;
      case 'saturday':
        return Icons.sports_tennis;
      case 'sunday':
        return Icons.sunny;
      default:
        return Icons.calendar_today;
    }
  }

  Color _categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'beverages':
        return const Color(0xFF6B7280);
      case 'desserts':
        return const Color(0xFFD97706);
      case 'snacks':
        return const Color(0xFFEF4444);
      case 'breakfast':
        return const Color(0xFFF59E0B);
      case 'fast food':
        return const Color(0xFFEF4444);
      case 'special':
        return const Color(0xFF10B981);
      case 'healthy':
        return const Color(0xFF16A34A);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'beverages':
        return Icons.local_cafe;
      case 'desserts':
        return Icons.icecream;
      case 'snacks':
        return Icons.fastfood;
      case 'breakfast':
        return Icons.free_breakfast;
      case 'fast food':
        return Icons.local_pizza;
      case 'special':
        return Icons.star;
      case 'healthy':
        return Icons.spa;
      default:
        return Icons.restaurant;
    }
  }

  // ============ ORDERS TAB ============
  Widget _buildOrdersTab(String userId) {
    return StreamBuilder<List<CafeteriaOrder>>(
      stream: CafeteriaService.streamOrdersByUser(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF1E3A8A)));
        }
        final orders = snapshot.data ?? [];
        if (orders.isEmpty) {
          return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                const Icon(Icons.receipt_long_outlined,
                    size: 70, color: Colors.grey),
                const SizedBox(height: 12),
                Text('No order history found',
                    style:
                        GoogleFonts.poppins(fontSize: 16, color: Colors.grey))
              ]));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (ctx, i) {
            final order = orders[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: Colors.grey.shade200)),
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('🧾 Token: ${order.token}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: _getStatusColor(order.status)
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(order.status.toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              _getStatusColor(order.status)))),
                            ]),
                        const SizedBox(height: 8),
                        Text(
                            'Total Paid: ৳${order.totalAmount.toStringAsFixed(0)} • Method: ${order.paymentMethod.toUpperCase()}',
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.grey.shade800)),
                        const SizedBox(height: 6),
                        ...order.items.map((item) => Text(
                            '• ${item['name']} × ${item['quantity']}',
                            style: GoogleFonts.poppins(
                                fontSize: 11, color: Colors.grey.shade600))),
                        const Divider(),
                        Text(
                            'Ordered on: ${order.orderTime.toString().substring(0, 16)}',
                            style: GoogleFonts.poppins(
                                fontSize: 10, color: Colors.grey)),
                      ])),
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.warning;
      case 'confirmed':
        return AppColors.primary;
      case 'preparing':
        return Colors.orange;
      case 'ready':
        return AppColors.success;
      case 'delivered':
        return Colors.green.shade700;
      default:
        return Colors.grey;
    }
  }
}
