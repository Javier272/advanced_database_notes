-- excercise 1
SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;

UPDATE accounts SET balance = balance - 50 WHERE account_id = 3;
UPDATE accounts SET balance = balance + 50 WHERE account_id = 1;

SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;
COMMIT;


-- excersice 2
SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;

UPDATE accounts SET balance = balance - 10000 WHERE account_id = 2;
UPDATE accounts SET balance = balance + 10000 WHERE account_id = 3;

SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;

ROLLBACK;
SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;


-- excercise 3
SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;

UPDATE accounts SET balance = balance - 10000 WHERE account_id = 2;
UPDATE accounts SET balance = balance + 10000 WHERE account_id = 3;

SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;

ROLLBACK;
SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;


-- excercise 4
CREATE OR REPLACE PROCEDURE deposit_funds(
    p_account_id IN NUMBER,
    p_amount     IN NUMBER
) AS
BEGIN

    IF p_amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Amount must be greater than 0');
    END IF;

    UPDATE accounts
    SET balance = balance + p_amount
    WHERE account_id = p_account_id;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Deposit successful: $' || p_amount);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Deposit failed');
        RAISE;
END;
/


-- excercise 5
--Q1: You're building a patient appointment booking system.
--a) Reserve the time slot
--b) Create the appointment record

--Which of these should be inside the transaction? Which should be outside? Why?


-- Q2: Your stored procedure calls COMMIT at the end.
-- A developer calls your procedure from inside their own larger transaction.
-- What problem does this create?
--The time slot reservation and appointment creation must be atomic to ensure data consistency. 
--If one fails, both should be rolled back.


-- Q3: You have a function called calculate_copay() and a procedure called post_payment().
-- A colleague wants to use calculate_copay() inside a SELECT statement.
-- Can they? Can they do the same with post_payment()? Why or why not?
--calculate_copay() because Functions return a value and are designed for computations, 
--so they can be used in SQL statements like SELECT.