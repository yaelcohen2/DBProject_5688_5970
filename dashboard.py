import customtkinter as ctk
from tkinter import ttk

class HotelDashboard(ctk.CTk):
    def __init__(self, employee_name):
        super().__init__()
        self.title("LuxeStay - מערכת ניהול משק בית")
        self.geometry("900x600")

        # --- מבנה גריד (Grid) ---
        self.grid_columnconfigure(1, weight=1) # מרכז המסך יתרחב
        self.grid_rowconfigure(0, weight=1)

        # 1. תפריט צדדי (Sidebar)
        self.sidebar = ctk.CTkFrame(self, width=200, corner_radius=0)
        self.sidebar.grid(row=0, column=0, sticky="nsew")
        
        self.logo_label = ctk.CTkLabel(self.sidebar, text="LuxeStay", font=("Arial", 20, "bold"))
        self.logo_label.pack(pady=20)

        self.btn_rooms = ctk.CTkButton(self.sidebar, text="חדרים", fg_color="transparent")
        self.btn_rooms.pack(pady=10, padx=10)

        self.btn_tasks = ctk.CTkButton(self.sidebar, text="משימות", fg_color="transparent")
        self.btn_tasks.pack(pady=10, padx=10)

        # 2. מרכז המסך (Main Area)
        self.main_frame = ctk.CTkFrame(self, fg_color="transparent")
        self.main_frame.grid(row=0, column=1, sticky="nsew", padx=20, pady=20)

        self.welcome_label = ctk.CTkLabel(self.main_frame, text=f"שלום {employee_name}, ברוך הבא!", font=("Arial", 24))
        self.welcome_label.pack(pady=20)

        # כאן בעתיד נכניס את הטבלה (Treeview)
        self.table_label = ctk.CTkLabel(self.main_frame, text="חדרים לטיפולך:", font=("Arial", 16))
        self.table_label.pack(pady=10)