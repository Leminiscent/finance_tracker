-- Add a New Account
INSERT INTO
    "accounts" ("account_name", "account_type", "balance")
VALUES
    ('Checking Account', 'Checking', 5000.00);

-- Update an Account Balance
UPDATE "accounts"
SET
    "balance" = 5200.00
WHERE
    "account_id" = 1;

-- Delete an Account
DELETE FROM "accounts"
WHERE
    "account_id" = 2;

-- Add a New Category
INSERT INTO
    "categories" ("category_name", "category_type")
VALUES
    ('Groceries', 'expense');

-- Modify a Category
UPDATE "categories"
SET
    "category_name" = 'Utilities',
    "category_type" = 'expense'
WHERE
    "category_id" = 1;

-- Delete a Category
DELETE FROM "categories"
WHERE
    "category_id" = 3;

-- Record a New Transaction
INSERT INTO
    "transactions" (
        "account_id",
        "category_id",
        "amount",
        "transaction_date",
        "description"
    )
VALUES
    (1, 1, 150.00, '2023-03-15', 'Grocery shopping');

-- Update a Transaction
UPDATE "transactions"
SET
    "account_id" = 1,
    "category_id" = 1,
    "amount" = 160.00,
    "transaction_date" = '2023-03-15',
    "description" = 'Grocery shopping revised'
WHERE
    "transaction_id" = 1;

-- Delete a Transaction
DELETE FROM "transactions"
WHERE
    "transaction_id" = 2;

-- List Transactions for a Specific Account
SELECT
    *
FROM
    "transactions"
WHERE
    "account_id" = 1;

-- Sum of All Expenses for a Given Month
SELECT
    SUM("amount")
FROM
    "transactions"
WHERE
    "category_id" IN (
        SELECT
            "category_id"
        FROM
            "categories"
        WHERE
            "category_type" = 'expense'
    )
    AND strftime ('%Y-%m', "transaction_date") = '2023-03';

-- List All Transactions in a Category
SELECT
    *
FROM
    "transactions"
WHERE
    "category_id" = 1;

-- Add a New Budget
INSERT INTO
    "budgets" ("category_id", "amount", "month")
VALUES
    (1, 500.00, '2023-04');

-- Update a Budget
UPDATE "budgets"
SET
    "category_id" = 1,
    "amount" = 550.00,
    "month" = '2023-04'
WHERE
    "budget_id" = 1;

-- List Budgets Exceeding a Certain Amount
SELECT
    *
FROM
    "budgets"
WHERE
    "amount" > 1000.00;

-- Create a Savings Goal
INSERT INTO
    "savings_goals" (
        "goal_name",
        "target_amount",
        "current_amount",
        "target_date"
    )
VALUES
    ('Vacation Fund', 3000.00, 500.00, '2023-12-01');

-- Update a Savings Goal
UPDATE "savings_goals"
SET
    "goal_name" = 'Vacation Fund',
    "target_amount" = 3500.00,
    "current_amount" = 600.00,
    "target_date" = '2023-12-01'
WHERE
    "goal_id" = 1;

-- Delete a Savings Goal
DELETE FROM "savings_goals"
WHERE
    "goal_id" = 2;

-- List All Savings Goals
SELECT
    *
FROM
    "savings_goals";

-- View Monthly Expenses
SELECT
    *
FROM
    "monthly_expenses_view"
WHERE
    "month" = '2023-03';

-- View Account Balances
SELECT
    *
FROM
    "account_balances_view";

-- List Transactions Within a Date Range
SELECT
    *
FROM
    "transactions"
WHERE
    "transaction_date" BETWEEN '2023-03-01' AND '2023-03-31';

-- Sum of All Incomes for a Given Month
SELECT
    SUM("amount")
FROM
    "transactions"
WHERE
    "category_id" IN (
        SELECT
            "category_id"
        FROM
            "categories"
        WHERE
            "category_type" = 'income'
    )
    AND strftime ('%Y-%m', "transaction_date") = '2023-03';

-- List Transactions by Description
SELECT
    *
FROM
    "transactions"
WHERE
    "description" LIKE '%grocery%';

-- List Accounts by Type
SELECT
    *
FROM
    "accounts"
WHERE
    "account_type" = 'Savings';

-- Total Budget for a Specific Month
SELECT
    SUM("amount")
FROM
    "budgets"
WHERE
    strftime ('%Y-%m', "month") = '2023-04';

-- Check Progress Towards a Specific Savings Goal
SELECT
    "goal_name",
    "target_amount",
    "current_amount"
FROM
    "savings_goals"
WHERE
    "goal_id" = 1;

-- List All Categories of a Specific Type
SELECT
    *
FROM
    "categories"
WHERE
    "category_type" = 'expense';

-- List Transactions for a Specific Category and Month
SELECT
    *
FROM
    "transactions"
WHERE
    "category_id" = 1
    AND strftime ('%Y-%m', "transaction_date") = '2023-03';

-- Check Total Expenses Against Total Income for a Month
SELECT
    (
        SELECT
            SUM("amount")
        FROM
            "transactions"
        WHERE
            "category_id" IN (
                SELECT
                    "category_id"
                FROM
                    "categories"
                WHERE
                    "category_type" = 'income'
            )
            AND strftime ('%Y-%m', "transaction_date") = '2023-03'
    ) AS "total_income",
    (
        SELECT
            SUM("amount")
        FROM
            "transactions"
        WHERE
            "category_id" IN (
                SELECT
                    "category_id"
                FROM
                    "categories"
                WHERE
                    "category_type" = 'expense'
            )
            AND strftime ('%Y-%m', "transaction_date") = '2023-03'
    ) AS "total_expenses";
