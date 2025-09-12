# 💸 Family Expense Tracker

A simple Flutter app to track family expenses 👨‍👩‍👧‍👦.  
Supports **Income & Expense tabs**, **categories**, and **user selection** (Mehmet & Şehbal).  
Data is stored locally for now, and will later be synced with Firebase ☁️.  

---

## 🚀 Features

- 📊 **Two tabs** → Income & Expense  
- 🏷️ **Category tags** → Living Costs, Daily Needs, Extras  
- 👤 **User selector** → M = Mehmet, Ş = Şehbal  
- ➕ **Add new expenses** with amount, note, category, and user  
- 🎨 **Custom color-coded cards** for readability  
- 🔍 **Category filter** with pill-style buttons  

---

## 📱 How to Use

1. Launch the app ▶️  
2. On the **Welcome screen**, tap **“Let’s see!”**  
3. You’ll land on the **Expense screen**  
   - Switch between **Income** and **Expense** tabs at the top  
   - Use category chips to filter expenses  
4. Tap the **➕ button (bottom right)** to add a new item  
   - Enter the **amount** 💵  
   - Add a **note** 📝  
   - Select a **category** 🏷️  
   - Choose the **user (M or Ş)** 👥  
   - Press **Add** ✅  
5. Your expense appears in the list, styled with user avatar, category tag, and date.  

---

## 🛠️ Tech Stack

- ⚡ **Flutter** (cross-platform UI)  
- 🎨 Custom **Widgets** (ExpenseCard, ToggleTabs, CategoryChips)  
- ☁️ Future → Firebase Firestore for real-time sync  



## Roadmap
- [x] Basic UI with tabs and expense list
- [ ] Firebase integration for real-time sync
- [ ] User authentication
- [ ] Monthly reports and analytics
- [ ] Dark mode support
- [ ] Localization for multiple languages
- [ ] Publish on TestFlight