import customtkinter as ctk
from db_connection import get_connection 

ctk.set_appearance_mode("System")
ctk.set_default_color_theme("blue")

class HotelLoginScreen(ctk.CTk):
    def __init__(self):
        super().__init__()
        self.title("מערכת ניהול - מלון")
        self.geometry("400x350")
        
        self.title_label = ctk.CTkLabel(self, text="התחברות למערכת", font=("Arial", 24, "bold"))
        self.title_label.pack(pady=(40, 20))

        self.username_entry = ctk.CTkEntry(self, placeholder_text="user@hotel.com", width=200)
        self.username_entry.pack(pady=10)

        self.password_entry = ctk.CTkEntry(self, placeholder_text="שם פרטי", show="", width=200)
        self.password_entry.pack(pady=10)

        self.login_btn = ctk.CTkButton(self, text="היכנס", width=200, command=self.login_attempt)
        self.login_btn.pack(pady=20)
        
        self.error_label = ctk.CTkLabel(self, text="", text_color="red")
        self.error_label.pack()

    def login_attempt(self):
        email_input = self.username_entry.get()
        name_input = self.password_entry.get()
        
        # חיבור למסד הנתונים
        conn = get_connection()
        if conn:
            try:
                cursor = conn.cursor()
                # שאילתה שבודקת התאמה של אימייל ושם פרטי
                query = "SELECT * FROM employees WHERE email = %s AND firstname = %s"
                cursor.execute(query, (email_input, name_input))
                user = cursor.fetchone()
                
                if user:
                    self.error_label.configure(text="התחברת בהצלחה!", text_color="green")
                    print(f"שלום {user[1]}, ברוך הבא!") 
                else:
                    self.error_label.configure(text="פרטים אינם תואמים", text_color="red")
                
                cursor.close()
                conn.close()
            except Exception as e:
                self.error_label.configure(text="שגיאה בחיבור למסד", text_color="red")
                print(e)
        else:
            self.error_label.configure(text="אין חיבור למסד הנתונים", text_color="red")
            

if __name__ == "__main__":
    app = HotelLoginScreen()
    app.mainloop()