import { User } from "../models/user.model";
import { sendPushNotification } from "./notifications.service";

function getRandomItem<T>(items: T[]): T {
  return items[Math.floor(Math.random() * items.length)];
}

const notificationTitles = [
  "Time to meditate!",
  "Meditation time!",
  "Let’s meditate!",
  "Take a moment to meditate",
  "Step back and meditate",
];

const notificationMessages = [
  "Take some time to just be",
  "Your mind deserves a break",
  "You will enjoy today more if you meditate",
  "Reconnect with yourself",
  "Give yourself permission to pause",
  "It will make your day better",
];

// Sends a reminder push notification to every user that has a device token.
export async function sendStreakReminder(): Promise<void> {
  console.log("\nSENDING STREAK REMINDER NOTIFICATION\n");
  const users = await User.find();

  for (const user of users) {
    if (user.fullName !== "" && user.deviceToken !== undefined) {
      console.log("\nSending notification to " + user.fullName + "\n");
      const title = getRandomItem(notificationTitles);
      const message = getRandomItem(notificationMessages);

      sendPushNotification([user.deviceToken], title, message, {}, true, null);
    }
  }
}
