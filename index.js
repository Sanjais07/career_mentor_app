const express = require('express');
const nodemailer = require('nodemailer');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
const PORT = 5000;

app.use(cors());
app.use(bodyParser.json());

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: '71762234039@cit.edu.in',        // ✅ replace with your Gmail
    pass: 'tmyvrhlynahwhvnd'       // ✅ paste the 16-char app password here
  }
});

app.post('/send', (req, res) => {
  const { to, subject, text } = req.body;

  const mailOptions = {
    from: '71762234039@cit.edu.in',       // ✅ same Gmail
    to,
    subject,
    text,
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.error('Email failed:', error);
      return res.status(500).send({ message: 'Failed to send email', error });
    }
    console.log('Email sent:', info.response);
    res.status(200).send({ message: 'Email sent successfully' });
  });
});

app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
