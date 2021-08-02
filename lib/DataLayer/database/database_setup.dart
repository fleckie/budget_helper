import 'database_constants.dart' as Constants;

var commands = [
  '''
    CREATE TABLE ${Constants.categoriesTable}(
      ${Constants.categoriesId} INTEGER PRIMARY KEY
    );
    ''',
  '''
    CREATE TABLE ${Constants.expensesTable}(
      ${Constants.expensesId} INTEGER PRIMARY KEY,
      ${Constants.expensesName} TEXT NOT NULL,
      ${Constants.expensesColor} INTEGER NOT NULL,
      CONSTRAINT fk_Expenses_Categories FOREIGN KEY (${Constants.expensesId}) REFERENCES ${Constants.categoriesTable} (${Constants.categoriesId}) ON DELETE CASCADE
       );
       ''',
  '''
    CREATE TABLE ${Constants.incomesTable}(
      ${Constants.incomesId} INTEGER PRIMARY KEY,
      ${Constants.incomesName} TEXT NOT NULL,
      ${Constants.incomesColor} INTEGER NOT NULL,
      CONSTRAINT fk_Expenses_Categories FOREIGN KEY (${Constants.incomesId}) REFERENCES ${Constants.categoriesTable} (${Constants.categoriesId}) ON DELETE CASCADE
    );
      ''',
  '''
    CREATE TABLE ${Constants.itemsTable}(
      ${Constants.itemsId} INTEGER PRIMARY KEY,
      ${Constants.itemsName} TEXT,
      ${Constants.itemsCategoryId} INTEGER,
       ${Constants.itemsType} TEXT,
      ${Constants.itemsValue} REAL,
      ${Constants.itemsDate} INTEGER,
      CONSTRAINT fk_Items_Categories FOREIGN KEY (${Constants.itemsCategoryId}) REFERENCES ${Constants.categoriesTable} (${Constants.categoriesId}) ON DELETE CASCADE
    );
    '''
];