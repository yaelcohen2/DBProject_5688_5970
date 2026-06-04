import psycopg2
from psycopg2 import Error

def get_connection():
    try:
        connection = psycopg2.connect(
            host="localhost",   
            port="5432",
            database="hotel",      
            user="myUser",          
            password="1234"         
        )
        return connection
    except Error as e:
        print(f"Error connecting to PostgreSQL: {e}")
        return None

if __name__ == "__main__":
    conn = get_connection()
    if conn:
        print("חיבור לבסיס הנתונים 'hotel' בוצע בהצלחה!")
        conn.close()