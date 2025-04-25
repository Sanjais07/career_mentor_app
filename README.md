# Career Mentor - Student Guidance App 📘

Career Mentor is a Flutter-based mobile application designed to help collect and visualize student information including academic performance and areas of interest. It provides insightful course distribution through pie charts and includes support for notifications, location, RSS feed, and email functionalities.

---

## ✨ Features

- 📋 Student information form
- 📊 Course-wise distribution via pie chart
- 🧾 Tabular view of added students
- 🔔 Notification, 📍 Location, 📡 RSS Feed, 📧 Email integration
- 💾 Local SQLite storage for persistence
- 📬 Email sending via Node.js backend

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/career-mentor.git
cd career-mentor
```

### 2. Flutter Setup

Ensure you have Flutter installed. If not, follow: https://flutter.dev/docs/get-started/install

Then run:

```bash
flutter pub get
flutter run
```

---

## 🗂️ Project Structure

```
lib/
├── main.dart                # Main Flutter app
├── notification.dart        # Notification screen
├── location.dart            # Location screen
├── rssfeed.dart             # RSS Feed screen
├── email.dart               # Email form
├── db_helper.dart           # SQLite DB helper
├── student_model.dart       # Student data model
```

---

## 💾 SQLite Local Storage

- Data is stored using the `sqflite` package.
- Database: `students.db`
- Table: `students`

Each student entry stores:
- Name, Email, Course
- 10th & 12th Grades
- College CGPA
- Areas of Interest

---

## 📈 Pie Chart Visualization

- Integrated using `pie_chart` package.
- Shows distribution of students across courses.

---

## 📧 Node.js Email Backend

### Prerequisites
- Node.js and npm installed

### Backend Setup

Navigate to the backend directory (create a `backend/` folder):

```bash
mkdir backend
cd backend
```

Create a file `server.js`:

```js
const express = require('express');
const nodemailer = require('nodemailer');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

app.post('/send-email', (req, res) => {
  const { name, email, message } = req.body;

  const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: 'your_email@gmail.com',      // Replace with your Gmail
      pass: 'your_app_password',         // Use App Password if 2FA is enabled
    },
  });

  const mailOptions = {
    from: 'your_email@gmail.com',
    to: email,
    subject: `Career Mentor: Hello ${name}`,
    text: message,
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) return res.status(500).send(error.toString());
    res.send('Email sent successfully');
  });
});

const PORT = 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
```

Then install dependencies and run:

```bash
npm install express nodemailer cors
node server.js
```

---

## 🔗 Flutter Email Integration

In `email.dart`, send a POST request to the Node backend:

```dart
final response = await http.post(
  Uri.parse('http://<your-local-ip>:3000/send-email'),
  headers: {'Content-Type': 'application/json'},
  body: json.encode({
    'name': name,
    'email': email,
    'message': message,
  }),
);
```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  pie_chart: ^5.1.0
  sqflite: ^2.3.0
  path: ^1.8.3
  http: ^0.13.5
```

---

## ✅ To Do

- [ ] Add student detail editing/deletion
- [ ] Firebase integration for cloud storage
- [ ] Authentication (Google/Email login)
- [ ] Export student list as CSV or PDF

📸 OUTPUT:

![Screenshot 2025-04-22 140707](https://github.com/user-attachments/assets/646b971d-ebda-4af4-b35f-bb59230fd460)
![Screenshot 2025-04-22 232914](https://github.com/user-attachments/assets/7a187d99-75e2-4c6c-bc00-e33a5dc5adef)
![Screenshot 2025-04-22 232931](https://github.com/user-attachments/assets/bbed0fa0-3445-4f34-9176-1492eaff150e)
![Screenshot 2025-04-22 233034](https://github.com/user-attachments/assets/d9b96f59-f2c9-485e-a4fb-a8ba342594f0)
![Screenshot 2025-04-22 233137](https://github.com/user-attachments/assets/0cb3a33d-261f-421f-968c-20400628ee5a)
![Screenshot 2025-04-22 233155](https://github.com/user-attachments/assets/3b11405d-f36d-4dd2-b809-6bcb515a54eb)
![Screenshot 2025-04-22 233224](https://github.com/user-attachments/assets/723abe3d-1912-4853-aa56-3897eda53b84)
![Screenshot 2025-04-22 233333](https://github.com/user-attachments/assets/c903867a-6b11-4a31-8c69-e663259d92e1)
![Screenshot 2025-04-22 233456](https://github.com/user-attachments/assets/75ab2b21-5534-49de-8d2c-19bbd28d7e09)

