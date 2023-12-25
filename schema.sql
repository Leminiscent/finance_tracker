-- Create 'accounts' table
CREATE TABLE
    "accounts" (
        "account_id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "account_name" TEXT NOT NULL,
        "account_type" TEXT,
        "balance" REAL
    );

-- Create 'categories' table
CREATE TABLE
    "categories" (
        "category_id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "category_name" TEXT NOT NULL,
        "category_type" TEXT CHECK (category_type IN ('income', 'expense'))
    );

-- Create 'transactions' table
CREATE TABLE
    "transactions" (
        "transaction_id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "account_id" INTEGER,
        "category_id" INTEGER,
        "amount" REAL NOT NULL,
        "transaction_date" DATE NOT NULL,
        "description" TEXT,
        FOREIGN KEY ("account_id") REFERENCES "accounts" ("account_id"),
        FOREIGN KEY ("category_id") REFERENCES "categories" ("category_id")
    );

-- Create 'budgets' table
CREATE TABLE
    "budgets" (
        "budget_id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "category_id" INTEGER,
        "amount" REAL NOT NULL,
        "month" DATE NOT NULL,
        FOREIGN KEY ("category_id") REFERENCES "categories" ("category_id")
    );

-- Create 'savings_goals' table
CREATE TABLE
    "savings_goals" (
        "goal_id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "goal_name" TEXT NOT NULL,
        "target_amount" REAL NOT NULL,
        "current_amount" REAL NOT NULL,
        "target_date" DATE
    );

-- Create indexes for faster query performance
CREATE INDEX "idx_transactions_account" ON "transactions" ("account_id");

CREATE INDEX "idx_transactions_category" ON "transactions" ("category_id");

-- Create a view for monthly expenses
CREATE VIEW
    "monthly_expenses_view" AS
SELECT
    c.category_name,
    SUM(t.amount) AS total_amount,
    strftime ('%Y-%m', t.transaction_date) AS MONTH
FROM
    transactions t
    JOIN categories c ON t.category_id = c.category_id
WHERE
    c.category_type = 'expense'
GROUP BY
    c.category_name,
    MONTH;

-- Create a view for account balances
CREATE VIEW
    "account_balances_view" AS
SELECT
    account_name,
    balance
FROM
    accounts;

-- Trigger to update account balance after a transaction
CREATE TRIGGER "after_insert_transaction_trigger" AFTER INSERT ON "transactions" BEGIN
UPDATE accounts
SET
    balance = balance - NEW.amount
WHERE
    account_id = NEW.account_id;

END;

-- Trigger to notify if a budget is exceeded
CREATE TRIGGER "after_insert_budget_trigger" AFTER INSERT ON "transactions" BEGIN
SELECT
    CASE
        WHEN (
            SELECT
                SUM(amount)
            FROM
                transactions
            WHERE
                category_id = NEW.category_id
                AND strftime ('%Y-%m', transaction_date) = strftime ('%Y-%m', 'now')
        ) > (
            SELECT
                amount
            FROM
                budgets
            WHERE
                category_id = NEW.category_id
                AND strftime ('%Y-%m', MONTH) = strftime ('%Y-%m', 'now')
        ) THEN RAISE (ABORT, 'Budget exceeded for the category')
    END;

END;
