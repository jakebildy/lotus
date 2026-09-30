import nodemailer from "nodemailer";
import { ResetCode } from "../models/resetcode.model";
import bcrypt from "bcrypt";
import { User } from "../models/user.model";

const SENDER_EMAIL = "shellevate.app@gmail.com";
const RESET_CODE_TTL_MS = 30 * 60 * 1000;

export async function resetPasswordEmail(email: string): Promise<void> {
  const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: SENDER_EMAIL,
      pass: process.env.EMAIL_PASSWORD,
    },
  });

  // Random numeric code of 4 digits.
  const resetCode = Math.floor(1000 + Math.random() * 9000);

  // Only the hash of the code is stored.
  await ResetCode.create({
    email,
    code: bcrypt.hashSync(resetCode.toString(), bcrypt.genSaltSync(10)),
  });

  const mailOptions = {
    from: SENDER_EMAIL,
    to: email,
    subject: "Reset Password",
    text:
      "Hi, \nYour code to reset your password is: " +
      resetCode +
      "\n\nThis code will expire in 30 minutes. \n\nBest,\nShellevate Team\n\n Please do not reply to this email.",
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.error("Error:", error);
    } else {
      console.log("Email sent:", info.response);
    }
  });
}

// Returns "Success", or a message describing why the reset failed.
export async function checkResetCodeAndResetPassword(
  email: string,
  code: string,
  newPassword: string,
): Promise<string> {
  // Find all reset codes for the given email
  const resetCodes = await ResetCode.find({ email });

  if (!resetCodes || resetCodes.length === 0) {
    console.error("Error: could not find any reset codes for the email");
    return "No reset codes found for this email.";
  }

  // Check if any reset code matches and is within the valid time frame
  const validResetCode = resetCodes.find((resetCode) => {
    const isCodeValid = bcrypt.compareSync(code, resetCode.code);
    const isWithinTimeFrame =
      new Date().getTime() - resetCode.createdAt.getTime() < RESET_CODE_TTL_MS;
    return isCodeValid && isWithinTimeFrame;
  });

  if (!validResetCode) {
    console.error(
      "Error: no valid reset code found (either mismatched or expired)",
    );
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
