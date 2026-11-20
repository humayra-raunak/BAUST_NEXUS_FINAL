import '../models/library_model.dart';

class LibraryService {
  static final List<LibraryBook> books = [
    LibraryBook(
        id: '1',
        title: 'Introduction to Algorithms',
        author: 'Thomas H. Cormen',
        department: 'CSE',
        year: '2022',
        totalCopies: 5,
        availableCopies: 3,
        isbn: '978-0-262-03384-8'),
    LibraryBook(
        id: '2',
        title: 'Digital Logic Design',
        author: 'M. Morris Mano',
        department: 'CSE',
        year: '2021',
        totalCopies: 4,
        availableCopies: 2,
        isbn: '978-0-13-335-633-0'),
    LibraryBook(
        id: '3',
        title: 'Circuit Analysis',
        author: 'William H. Hayt',
        department: 'EEE',
        year: '2020',
        totalCopies: 6,
        availableCopies: 4,
        isbn: '978-0-07-338057-9'),
    LibraryBook(
        id: '4',
        title: 'Engineering Mechanics',
        author: 'J. L. Meriam',
        department: 'ME',
        year: '2023',
        totalCopies: 5,
        availableCopies: 5,
        isbn: '978-0-470-61408-6'),
    LibraryBook(
        id: '5',
        title: 'Thermodynamics',
        author: 'Yunus A. Cengel',
        department: 'ME',
        year: '2022',
        totalCopies: 4,
        availableCopies: 1,
        isbn: '978-0-07-339817-4'),
    LibraryBook(
        id: '6',
        title: 'Structural Analysis',
        author: 'R. C. Hibbeler',
        department: 'CE',
        year: '2021',
        totalCopies: 3,
        availableCopies: 2,
        isbn: '978-0-13-605886-5'),
    LibraryBook(
        id: '7',
        title: 'Database Systems',
        author: 'Ramez Elmasri',
        department: 'CSE',
        year: '2023',
        totalCopies: 5,
        availableCopies: 3,
        isbn: '978-0-13-459411-4'),
    LibraryBook(
        id: '8',
        title: 'Power Electronics',
        author: 'Muhammad H. Rashid',
        department: 'EEE',
        year: '2020',
        totalCopies: 4,
        availableCopies: 2,
        isbn: '978-0-13-591174-6'),
    LibraryBook(
        id: '9',
        title: 'Data Structures',
        author: 'Mark Allen Weiss',
        department: 'CSE',
        year: '2023',
        totalCopies: 5,
        availableCopies: 4,
        isbn: '978-0-13-440829-3'),
    LibraryBook(
        id: '10',
        title: 'Computer Networks',
        author: 'Andrew S. Tanenbaum',
        department: 'CSE',
        year: '2022',
        totalCopies: 4,
        availableCopies: 2,
        isbn: '978-0-13-359535-4'),
    LibraryBook(
        id: '11',
        title: 'Operating Systems',
        author: 'Abraham Silberschatz',
        department: 'CSE',
        year: '2021',
        totalCopies: 5,
        availableCopies: 3,
        isbn: '978-0-470-12872-5'),
    LibraryBook(
        id: '12',
        title: 'Web Technologies',
        author: 'Noel Kalicharan',
        department: 'CSE',
        year: '2023',
        totalCopies: 4,
        availableCopies: 4,
        isbn: '978-0-13-312836-2'),
    LibraryBook(
        id: '13',
        title: 'Microprocessors',
        author: 'Barry Brey',
        department: 'EEE',
        year: '2022',
        totalCopies: 5,
        availableCopies: 3,
        isbn: '978-0-13-119649-0'),
    LibraryBook(
        id: '14',
        title: 'Signals and Systems',
        author: 'Alan V. Oppenheim',
        department: 'EEE',
        year: '2021',
        totalCopies: 4,
        availableCopies: 2,
        isbn: '978-0-13-814757-0'),
    LibraryBook(
        id: '15',
        title: 'Control Systems Engineering',
        author: 'Norman S. Nise',
        department: 'EEE',
        year: '2023',
        totalCopies: 4,
        availableCopies: 4,
        isbn: '978-1-118-17049-9'),
    LibraryBook(
        id: '16',
        title: 'Fluid Mechanics',
        author: 'Frank M. White',
        department: 'ME',
        year: '2022',
        totalCopies: 3,
        availableCopies: 1,
        isbn: '978-0-07-380516-8'),
    LibraryBook(
        id: '17',
        title: 'Machine Design',
        author: 'Robert L. Norton',
        department: 'ME',
        year: '2021',
        totalCopies: 4,
        availableCopies: 3,
        isbn: '978-0-07-297578-0'),
    LibraryBook(
        id: '18',
        title: 'Concrete Design',
        author: 'Arthur H. Nilson',
        department: 'CE',
        year: '2023',
        totalCopies: 3,
        availableCopies: 2,
        isbn: '978-0-13-294266-9'),
    LibraryBook(
        id: '19',
        title: 'Soil Mechanics',
        author: 'Donald P. Coduto',
        department: 'CE',
        year: '2022',
        totalCopies: 4,
        availableCopies: 2,
        isbn: '978-0-13-323331-1'),
    LibraryBook(
        id: '20',
        title: 'Surveying',
        author: 'Jack C. McCormac',
        department: 'CE',
        year: '2021',
        totalCopies: 3,
        availableCopies: 2,
        isbn: '978-0-470-46857-6'),
    LibraryBook(
        id: '21',
        title: 'Accounting Principles',
        author: 'Jerry J. Weygandt',
        department: 'BBA',
        year: '2023',
        totalCopies: 4,
        availableCopies: 3,
        isbn: '978-1-118-34599-9'),
    LibraryBook(
        id: '22',
        title: 'Business Management',
        author: 'Stephen P. Robbins',
        department: 'BBA',
        year: '2022',
        totalCopies: 5,
        availableCopies: 4,
        isbn: '978-0-13-610830-5'),
    LibraryBook(
        id: '23',
        title: 'Financial Analysis',
        author: 'Barbara Fridson',
        department: 'BBA',
        year: '2021',
        totalCopies: 4,
        availableCopies: 2,
        isbn: '978-0-13-367333-8'),
    LibraryBook(
        id: '24',
        title: 'English Literature',
        author: 'M.H. Abrams',
        department: 'ENG',
        year: '2023',
        totalCopies: 5,
        availableCopies: 3,
        isbn: '978-0-393-97286-2'),
    LibraryBook(
        id: '25',
        title: 'Physics Fundamentals',
        author: 'Halliday & Resnick',
        department: 'GEN',
        year: '2022',
        totalCopies: 5,
        availableCopies: 4,
        isbn: '978-1-118-05329-0'),
    LibraryBook(
        id: '26',
        title: 'Chemistry Essentials',
        author: 'Ralph H. Petrucci',
        department: 'GEN',
        year: '2021',
        totalCopies: 4,
        availableCopies: 2,
        isbn: '978-0-13-240765-4'),
    LibraryBook(
        id: '27',
        title: 'Mathematics Calculus',
        author: 'James Stewart',
        department: 'GEN',
        year: '2023',
        totalCopies: 5,
        availableCopies: 3,
        isbn: '978-1-285-74062-1'),
  ];

  static final List<BorrowRecord> borrowHistory = [];

  static List<LibraryBook> getAvailableBooks() => books;

  static List<BorrowRecord> getBorrowHistory() => borrowHistory;

  static int getBorrowedCount(String userId) {
    return borrowHistory
        .where(
            (record) => record.userId == userId && record.status == 'borrowed')
        .length;
  }

  static List<BorrowRecord> getActiveBooks() {
    return borrowHistory
        .where((record) => record.status == 'borrowed')
        .toList();
  }

  static List<BorrowRecord> getOverdueBooks() {
    final now = DateTime.now();
    return borrowHistory
        .where((record) =>
            record.status == 'borrowed' &&
            record.dueDate.isBefore(now) &&
            now.difference(record.dueDate).inDays >= 30)
        .toList();
  }

  static List<BorrowRecord> getReturnedBooks() {
    return borrowHistory
        .where((record) => record.status == 'returned')
        .toList();
  }

  static void addBook(LibraryBook book) {
    books.add(book);
  }

  static void borrowBook(BorrowRecord record) {
    borrowHistory.add(record);
    final book = books.firstWhere((b) => b.id == record.bookId,
        orElse: () => throw Exception('Book not found'));
    if (book.availableCopies > 0) {
      book.availableCopies--;
    }
  }

  static void returnBook(BorrowRecord record) {
    final index = borrowHistory.indexWhere((b) => b.id == record.id);
    if (index == -1) return;
    final updatedRecord = BorrowRecord(
      id: record.id,
      bookId: record.bookId,
      bookTitle: record.bookTitle,
      userId: record.userId,
      userName: record.userName,
      userDept: record.userDept,
      userRole: record.userRole,
      borrowDate: record.borrowDate,
      dueDate: record.dueDate,
      returnDate: DateTime.now(),
      token: record.token,
      status: 'returned',
      fine: record.calculatedFine,
    );
    borrowHistory[index] = updatedRecord;
    final book = books.firstWhere((b) => b.id == record.bookId,
        orElse: () => throw Exception('Book not found'));
    book.availableCopies++;
  }
}
