import psycopg2
import random
from datetime import datetime, timedelta

# --- 1. פרטי התחברות מעודכנים לפי התמונה ---
connection_params = {
    "host": "localhost",     # השאירי localhost כי פייתון רץ מהמחשב שלך אל המכולה (Container)
    "port": "5432",
    "database": "hotel", 
    "user": "myUser",        # בדיוק כפי שמופיע בתמונה
    "password": "1234"       # הסיסמה שהגדרת ב-Docker/pgAdmin
}

def insert_big_data():
    conn = None
    try:
        print("Connecting to the PostgreSQL database...")
        conn = psycopg2.connect(**connection_params)
        cur = conn.cursor()
        print("Connection established!")

        num_rows = 20000
        print(f"Starting to insert {num_rows} rows...")

        for i in range(num_rows):
            task_id = random.randint(1, 10) 
            employee_id = random.randint(1, 10)
            start_time = datetime.now() - timedelta(days=random.randint(0, 365))
            end_time = start_time + timedelta(hours=random.randint(1, 3))
            comment = f"Log entry #{i}"

            cur.execute(
                "INSERT INTO cleaninglog (taskid, employeeid, starttime, endtime, comment) VALUES (%s, %s, %s, %s, %s)",
                (task_id, employee_id, start_time, end_time, comment)
            )

        conn.commit()
        print(f"Successfully inserted {num_rows} rows!")

    except Exception as error:
        print(f"Error: {error}")
    
    finally:
        if conn is not None:
            cur.close()
            conn.close()
            print("PostgreSQL connection is closed.")

if __name__ == "__main__":
    insert_big_data()