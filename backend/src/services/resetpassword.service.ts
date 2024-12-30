import nodemailer from "nodemailer";
import { ResetCode } from "../models/resetcode.model";
import bcrypt from "bcrypt";
import { User } from "../models/user.model";

export async function resetPasswordEmail(email: string) {



const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: "shellevate.app@gmail.com",
      pass:  process.env.EMAIL_PASSWORD,
    },
  });

//   generate a random numeric code of 4 digits
const resetCode =  Math.floor(1000 + Math.random() * 9000);

//   create a mongoose ResetCode with the email and the reset code
  await ResetCode.create({  email: email,
    code: bcrypt.hashSync(resetCode.toString(), bcrypt.genSaltSync(10)), });

  const mailOptions = {
    from: "shellevate.app@gmail.com",
    to: email,
    subject: "Reset Password",
    text: "Hi, \nYour code to reset your password is: " + resetCode + "\n\nThis code will expire in 30 minutes. \n\nBest,\nShellevate Team\n\n Please do not reply to this email.",
  };
  
  transporter.sendMail(mailOptions, (error: any, info) => {
    if (error) {
      console.error("Error:", error);
    } else {
      console.log("Email sent:", info.response);
    }
  });

}

export async function checkResetCodeAndResetPassword(email: string, code: string, newPassword: string) {
    const hashedCode = bcrypt.hashSync(code, bcrypt.genSaltSync(10));
    const resetCode = await ResetCode.findOne({ email, hashedCode });

    if (!resetCode) {
        console.error("Error: could not find reset code");
      return false;
    } else {
        // if it was within 30 minutes
        if (new Date().getTime() - resetCode.createdAt.getTime() < 30 * 60 * 1000) {
            // find user by email
            const user = await User.findOne({ email });

            if (!user) {
                console.error("Error: could not find user");
                return false;
            } else {
                // update user password
                user.password = bcrypt.hashSync(newPassword, bcrypt.genSaltSync(10));
                await user.save();
                console.log("Password reset successfully");
                return true;
            }
        } else {
            console.error("Error: reset code expired");
            return false;
        }
    }
}