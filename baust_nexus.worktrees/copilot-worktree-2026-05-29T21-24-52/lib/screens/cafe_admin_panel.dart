import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/cafeteria_model.dart';
import '../../services/cafeteria_service.dart';
import '../../services/auth_service.dart';

class CafeAdminPanel extends StatelessWidget {
  const CafeAdminPanel({super.key});

  void _updateStatus(String orderId, String newStatus) {
    CafeteriaService.updateOrderStatus(orderId, newStatus);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser;
    if (user?.role != 'admin' || user?.department != 'Cafe') {
      return Scaffold(
        appBar: AppBar(title: const Text('Access Denied')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Only Cafe Admin can access this panel',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    const primaryColor = Color(0xFF1E3A8A);

    return StreamBuilder<List<CafeteriaOrder>>(
      stream: CafeteriaService.streamAllOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        final allOrders = snapshot.data ?? [];
        final todayRevenue = CafeteriaService.calculateTodayRevenue(allOrders);
        final totalRevenue = CafeteriaService.calculateTotalRevenue(allOrders);
        final salesMap = CafeteriaService.calculateItemSalesCount(allOrders);

        return Scaffold(
          backgroundColor: const Color(0xFFF3F4F6),
          appBar: AppBar(
            title: Text('Cafeteria Admin Panel',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            backgroundColor: primaryColor,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: _buildDashboardCard(
                            "Today's Net",
                            "৳${todayRevenue.toStringAsFixed(0)}",
                            Colors.green)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _buildDashboardCard(
                            "Total Earned",
                            "৳${totalRevenue.toStringAsFixed(0)}",
                            Colors.blue)),
                  ],
                ),
                const SizedBox(height: 20),
                Text('🔥 Top Food Sales Counting',
                    style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: salesMap.length > 5 ? 5 : salesMap.length,
                    itemBuilder: (context, index) {
                      final sortedKeys = salesMap.keys.toList()
                        ..sort((a, b) => salesMap[b]!.compareTo(salesMap[a]!));
                      if (sortedKeys.isEmpty) {
                        return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('No sales dispatched yet.'));
                      }
                      final item = sortedKeys[index];
                      return ListTile(
                        leading:
                            const Icon(Icons.fastfood, color: Colors.orange),
                        title: Text(item,
                            style: GoogleFonts.poppins(
                                fontSize: 13, fontWeight: FontWeight.w500)),
                        trailing: Text('${salesMap[item]} Portions',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: primaryColor)),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text('📋 Live Customer Active Queue',
                    style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                allOrders.where((o) => o.status != 'delivered').isEmpty
                    ? const Center(
                        child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text('No active kitchen orders running.')))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: allOrders.length,
                        itemBuilder: (context, index) {
                          final order = allOrders[index];
                          if (order.status == 'delivered') {
                            return const SizedBox.shrink();
                          }
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: ExpansionTile(
                              title: Text('Token: ${order.token}',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                              subtitle: Text(
                                  '${order.userName} • ${order.userDept}',
                                  style: const TextStyle(fontSize: 12)),
                              trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(order.status.toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    ElevatedButton(
                                      onPressed: order.status == 'delivered'
                                          ? null
                                          : () => _updateStatus(
                                              order.id, 'delivered'),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          minimumSize: const Size(90, 30)),
                                      child: const Text('Deliver',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12)),
                                    ),
                                  ]),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Phone: ${order.userPhone ?? 'Not provided'}',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text(
                                          'Amount: ৳${order.totalAmount.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text(
                                          'Method: ${order.paymentMethod.toUpperCase()}',
                                          style: const TextStyle(fontSize: 12)),
                                      if (order.bkashNumber != null)
                                        Text('bKash: ${order.bkashNumber}',
                                            style:
                                                const TextStyle(fontSize: 12)),
                                      if (order.nagadNumber != null)
                                        Text('Nagad: ${order.nagadNumber}',
                                            style:
                                                const TextStyle(fontSize: 12)),
                                      if (order.transactionId != null)
                                        Text('Trans ID: ${order.transactionId}',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey)),
                                      const Divider(),
                                      Text('Items',
                                          style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 6),
                                      ...order.items.map((item) => Text(
                                          '• ${item['name']} x ${item['quantity']}',
                                          style:
                                              const TextStyle(fontSize: 13))),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                const SizedBox(height: 20),
                Text('📦 Delivered Orders History',
                    style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                allOrders.where((o) => o.status == 'delivered').isEmpty
                    ? const Center(
                        child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text('No delivered orders yet.')))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: allOrders
                            .where((o) => o.status == 'delivered')
                            .length,
                        itemBuilder: (context, index) {
                          final deliveredOrders = allOrders
                              .where((o) => o.status == 'delivered')
                              .toList();
                          final order = deliveredOrders[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              title: Text('Token: ${order.token}',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  '${order.userName} • ${order.userPhone ?? 'No phone'}',
                                  style: const TextStyle(fontSize: 12)),
                              trailing: Text(
                                  '৳${order.totalAmount.toStringAsFixed(0)}',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green)),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDashboardCard(String title, String val, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(val,
            style: GoogleFonts.poppins(
                fontSize: 20, fontWeight: FontWeight.bold, color: color)),
      ]),
    );
  }
}
