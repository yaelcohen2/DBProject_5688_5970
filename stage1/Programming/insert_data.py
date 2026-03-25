import psycopg2
import random
from datetime import datetime, timedelta


# --- 1. פרטי התחברות לבסיס הנתונים שלך ---
connection_params = {
    "host": "localhost",
    "database": "hotel",       
    "user": "myUser",          
    "password": "1234"        
}

def insert_big_data():
    conn = None
    try:
        # התחברות לשרת
        print("Connecting to the PostgreSQL database...")
        conn = psycopg2.connect(**connection_params)
        cur = conn.cursor()

        # כמות השורות להכנסה
        num_rows = 20000
        print(f"Starting to insert {num_rows} rows into CLEANNINGLOG and USES...")

        # --- 2. הכנסת נתונים לטבלת CLEANNINGLOG ---
        for i in range(num_rows):
            task_id = random.randint(1, 500)
            employee_id = random.randint(1, 500)
            start_time = datetime.now() - timedelta(days=random.randint(0, 365))
            end_time = start_time + timedelta(hours=random.randint(1, 3))
            comment = f"Log entry #{i} generated via Python"

            cur.execute(
                "INSERT INTO CLEANNINGLOG (taskID, employeeID, startTime, endTime, comment) VALUES (%s, %s, %s, %s, %s)",
                (task_id, employee_id, start_time, end_time, comment)
            )

        # --- 3. הכנסת נתונים לטבלת USES ---
        for i in range(num_rows):
            supplies_id = random.randint(1, 500)
            task_id = random.randint(1, 500)
            quantity = random.randint(1, 10)

            # שימוש ב-ON CONFLICT כדי למנוע שגיאות אם המפתח כבר קיים
            cur.execute(
                "INSERT INTO USES (suppliesID, taskID, quantityUsed) VALUES (%s, %s, %s) ON CONFLICT DO NOTHING",
                (supplies_id, task_id, quantity)
            )

        # שמירת השינויים בבסיס הנתונים (חשוב מאוד!)
        conn.commit()
        print(f"Successfully inserted {num_rows} rows into both tables!")

    except (Exception, psycopg2.DatabaseError) as error:
        print(f"Error while connecting to PostgreSQL: {error}")
    
    finally:
        # סגירת החיבור
        if conn is not None:
            cur.close()
            conn.close()
            print("PostgreSQL connection is closed.")

if __name__ == "__main__":
    insert_big_data()