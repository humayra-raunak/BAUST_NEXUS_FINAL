class LibraryBook {
  final String id;
  final String title;
  final String author;
  final String department;
  final String year;
  final int totalCopies;
  int availableCopies; // Made non-final to allow modification
  final String isbn;

  LibraryBook({
    required this.id,
    required this.title,
    required this.author,
    required this.department,
    required this.year,
    required this.totalCopies,
    required this.availableCopies,
    required this.isbn,
  });
}

class BorrowRecord {
  final String id;
  final String bookId;
  final String bookTitle;
  final String userId;
  final String userName;
  final String userDept;
  final String userRole;
  final DateTime borrowDate;
  final DateTime dueDate;
  final DateTime? returnDate;
  final String token;
  final String status; // 'borrowed', 'returned', 'overdue'
  final double? fine;

  BorrowRecord({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.userId,
    required this.userName,
    required this.userDept,
    required this.userRole,
    required this.borrowDate,
    required this.dueDate,
    this.returnDate,
    required this.token,
    required this.status,
    this.fine,
  });

  int get daysOverdue {
    if (status == 'returned') return 0;
    final now = DateTime.now();
    if (now.isBefore(dueDate)) return 0;
    return now.difference(dueDate).inDays;
  }

  double get calculatedFine {
    return (daysOverdue * 5.0); // 5 Tk per day
  }

  bool get isOverdue => daysOverdue > 0;

  Duration get remainingDays {
    final now = DateTime.now();
    if (now.isAfter(dueDate)) {
      return Duration.zero;
    }
    return dueDate.difference(now);
  }
}
