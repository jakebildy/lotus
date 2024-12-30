import nodemailer from "nodemailer";

export default function resetPasswordEmail(email: string) {



const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: "shellevate.app@gmail.com",
      pass:  process.env.EMAIL_PASSWORD,
    },
  });
  
  const mailOptions = {
    from: "shellevate.app@gmail.com",
    to: email,
    subject: "Test Email",
    text: "Hello, this is a test email!",
  };
  
  transporter.sendMail(mailOptions, (error: any, info) => {
    if (error) {
      console.error("Error:", error);
    } else {
      console.log("Email sent:", info.response);
    }
  });

}