# Masroufi - Personal Expense Tracker

Masroufi (Arabic for "my allowance") is a simple mobile app for tracking everyday expenses in Egyptian pounds, built with **Flutter** and **SQLite**. Add an expense, see your running total at the top of the screen, scroll through your history, and swipe an entry away to delete it. Everything is stored on the device.

## Screenshots

<p align="center">
  <img src="docs/expense-list.jpg" alt="Expense list with total" width="260">
  &nbsp;&nbsp;&nbsp;
  <img src="docs/add-expense.jpg" alt="Add expense form" width="260">
</p>

<p align="center"><em>Expense list with the running total (left) and the add-expense form (right). Sample data shown.</em></p>

## Features

- **Add expenses** in EGP through a bottom-sheet form with validation: the title is required and the amount must be a valid number
- **Running total** of all loaded expenses, always visible in the app bar
- **Infinite scroll**: expenses load 10 at a time as you scroll down
- **Swipe to delete**: swipe an expense to the left to remove it, with an **Undo** button to bring it back in the same place
- **Persistent storage** with SQLite, so your expenses are still there after you close the app
- **Empty state** with a hint to add your first expense
- Material 3 design with a letter avatar for each expense and snack bar feedback

## Tech Stack

- **Framework:** Flutter (Dart SDK 3.11 or newer)
- **Local database:** [`sqflite`](https://pub.dev/packages/sqflite)
- **Utilities:** `path`
- **Design:** Material 3, `ListView.builder` with a scroll controller, `Dismissible`, `Form` and `TextFormField` validation

## Project Structure

```
lib/
├── main.dart              # app entry point, home screen, add form, list and pagination
├── database_helper.dart   # singleton DatabaseHelper: create, insert, query, delete
└── models/
    └── expense_item.dart  # ExpenseItem model
test/
└── widget_test.dart       # model and widget tests
docs/                      # screenshots
```

## Database

One table, `expenses`, created on first launch:

| Column | Type | Notes |
| --- | --- | --- |
| `id` | INTEGER | primary key, the creation time in milliseconds |
| `title` | TEXT | description of the expense |
| `price` | TEXT | the amount in EGP, stored as text and parsed back to a number |
| `date` | TEXT | ISO 8601 date and time |

## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart 3.11 or newer)
- An Android emulator or device, or an iOS simulator or device

### Run the app

```bash
git clone https://github.com/Youstina-Raouf/Masroufi-App.git
cd Masroufi-App
flutter pub get
flutter run
```

### Run the tests

```bash
flutter test
```

The tests cover the model, the home screen and empty state, the add form and its validation.

### Supported platforms
The app uses `sqflite`, which supports **Android, iOS and macOS**. Running it on web, Windows or Linux would need an additional SQLite package such as `sqflite_common_ffi`.

## Known Limitations and Ideas
- Pagination loads every expense and slices the list in memory, instead of querying the database one page at a time
- Ideas: categories, an edit screen and a monthly summary

## Author

Youstina Raouf
