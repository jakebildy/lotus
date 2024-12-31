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
  // Find all reset codes for the given email
  const resetCodes = await ResetCode.find({ email });

  if (!resetCodes || resetCodes.length === 0) {
      console.error("Error: could not find any reset codes for the email");
      return "No reset codes found for this email.";
  }

  // Check if any reset code matches and is within the valid time frame
  const validResetCode = resetCodes.find(resetCode => {
      const isCodeValid = bcrypt.compareSync(code, resetCode.code);
      const isWithinTimeFrame = (new Date().getTime() - resetCode.createdAt.getTime() < 30 * 60 * 1000);
      return isCodeValid && isWithinTimeFrame;
  });

  if (!validResetCode) {
      console.error("Error: no valid reset code found (either mismatched or expired)");
      return "Invalid or expired reset code.";
  }

  // Find the user by email
  const user = await User.findOne({ email });

  if (!user) {
      console.error("Error: could not find user");
      return "Couldn't find a user with that email.";
  }

  // Update the user's password
  user.password = bcrypt.hashSync(newPassword, bcrypt.genSaltSync(10));
  await user.save();
  console.log("Password reset successfully");
  return "Success";
}