# 📰 News Topic Explorer (Flutter OJT Project)

A modern, topic-focused news application built with **Flutter**, **Riverpod**, and **Clean Architecture principles**. This app allows users to browse top headlines, filter by category, and read full articles seamlessly within the app.

---

## 🚀 Features

* **Top Headlines Feed:** Fetches the latest news from GNews API instantly.
* **Category Filtering:** Interactive chips to filter news by topics (Tech, Business, Sports, Health, etc.).
* **State Management:** Powered by **Riverpod** for compile-safe, reactive state updates (Loading, Data, Error states).
* [cite_start]**In-App WebView:** Users can read the full news story without leaving the app.
* [cite_start]**Robust Error Handling:** Gracefully handles network failures (e.g., "No Internet") with a retry mechanism[cite: 28].
* **Modern UI:** Clean, responsive design with `ArticleCard` widgets and a user-friendly layout.

---

## 🛠️ Tech Stack & Architecture

* **Framework:** Flutter (Dart)
* [cite_start]**State Management:** `flutter_riverpod` (MVVM Pattern)[cite: 63].
* **Networking:** `http` package (REST API Integration).
* [cite_start]**Navigation:** Linear stack-based navigation (`Navigator.push`)[cite: 75].
* **Utilities:** `webview_flutter` (In-App Browser), `intl` (Date Formatting).

### Architecture: MVVM with Riverpod
[cite_start]We chose the **MVVM (Model-View-ViewModel)** pattern to separate business logic from the UI[cite: 63].
* **Model:** `ArticleModel` (Parses JSON data).
* **View:** `HomeScreen`, `DetailScreen` (Widgets that consume state).
* **ViewModel:** `NewsProvider` (Manages API calls and state).

---

## 📸 Screenshots

| Home Screen | Detail Screen | In-App WebView |
| :---: | :---: | :---: |
| <img src="screenshots/home.png" width="250" /> | <img src="screenshots/detail.png" width="250" /> | <img src="screenshots/webview.png" width="250" /> |

*(Note: Add your screenshots to a `screenshots` folder in your repo)*

---

## 🔧 Installation & Setup

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/aparna-modi/News-topic-explorer-OJT.git](https://github.com/aparna-modi/News-topic-explorer-OJT.git)
    cd News-topic-explorer-OJT
    ```

2.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```

3.  **API Key Configuration:**
    * Get a free API Key from [GNews.io](https://gnews.io/).
    * Open `lib/data/services/api_service.dart`.
    * Replace `YOUR_API_KEY` with your actual key.

4.  **Run the App:**
    ```bash
    flutter run
    ```

---

## 📂 Project Structure