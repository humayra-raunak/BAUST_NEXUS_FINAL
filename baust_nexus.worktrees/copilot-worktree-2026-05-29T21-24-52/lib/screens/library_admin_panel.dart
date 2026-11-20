import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/library_service.dart';

class LibraryAdminPanel extends StatefulWidget {
  const LibraryAdminPanel({super.key});

  @override
  State<LibraryAdminPanel> createState() => _LibraryAdminPanelState();
}

class _LibraryAdminPanelState extends State<LibraryAdminPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser;
    if (user?.role != 'admin' || user?.department != 'Library') {
      return Scaffold(
        appBar: AppBar(title: const Text('Access Denied')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Only Library Admin can access this panel',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    final activeBooks = LibraryService.getActiveBooks();
    final overdueBooks = LibraryService.getOverdueBooks();
    final returnedBooks = LibraryService.getReturnedBooks();

    const primaryColor = Color(0xFF0B3D91);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text('Library Admin Panel',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: primaryColor,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Active Books', icon: Icon(Icons.book, size: 18)),
            Tab(
                text: 'Overdue (30+ days)',
                icon: Icon(Icons.warning, size: 18)),
            Tab(text: 'Return History', icon: Icon(Icons.history, size: 18)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveBooksList(activeBooks),
          _buildOverdueBooksList(overdueBooks),
          _buildReturnHistoryList(returnedBooks),
        ],
      ),
    );
  }

  Widget _buildActiveBooksList(List activeBooks) {
    if (activeBooks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle,
                size: 80, color: Colors.green.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text('No active borrowed books',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activeBooks.length,
      itemBuilder: (context, i) {
        final record = activeBooks[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.blue.withValues(alpha: 0.1),
                child: const Icon(Icons.book, color: Colors.blue)),
            title: Text(record.bookTitle,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: 13)),
            subtitle: Text(
                '${record.userName} • ${record.userDept}\nBorrowed: ${record.borrowDate.toString().substring(0, 10)} | Due: ${record.dueDate.toString().substring(0, 10)}',
                style: GoogleFonts.poppins(fontSize: 11)),
            trailing: Chip(
                label: Text('Token: ${record.token}',
                    style: GoogleFonts.poppins(fontSize: 10)),
                backgroundColor: Colors.blue.withValues(alpha: 0.1)),
          ),
        );
      },
    );
  }

  Widget _buildOverdueBooksList(List overdueBooks) {
    if (overdueBooks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle,
                size: 80, color: Colors.green.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text('No overdue books (30+ days)',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: overdueBooks.length,
      itemBuilder: (context, i) {
        final record = overdueBooks[i];
        final overdueDays = DateTime.now().difference(record.dueDate).inDays;
        final fine = overdueDays * 5;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.red.withValues(alpha: 0.1),
                child: const Icon(Icons.warning, color: Colors.red)),
            title: Text(record.bookTitle,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: 13)),
            subtitle: Text(
                '${record.userName}\nOverdue: $overdueDays days | Fine: ৳$fine',
                style: GoogleFonts.poppins(fontSize: 11, color: Colors.red)),
            trailing: Chip(
                label: Text('Fine: ৳$fine',
                    style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
                backgroundColor: Colors.red.withValues(alpha: 0.1)),
          ),
        );
      },
    );
  }

  Widget _buildReturnHistoryList(List returnedBooks) {
    if (returnedBooks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history,
                size: 80, color: Colors.grey.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text('No returned books yet',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: returnedBooks.length,
      itemBuilder: (context, i) {
        final record = returnedBooks[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.green.withValues(alpha: 0.1),
                child: const Icon(Icons.check_circle, color: Colors.green)),
            title: Text(record.bookTitle,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: 13)),
            subtitle: Text(
                '${record.userName} • ${record.userDept}\nReturned: ${record.returnDate?.toString().substring(0, 10) ?? 'N/A'}',
                style: GoogleFonts.poppins(fontSize: 11)),
            trailing: Chip(
                label: Text('Fine: ৳${record.fine ?? 0}',
                    style: GoogleFonts.poppins(fontSize: 10)),
                backgroundColor: record.fine == null || record.fine == 0
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.orange.withValues(alpha: 0.1)),
          ),
        );
      },
    );
  }
}
