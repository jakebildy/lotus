import { User } from "../models/user.model";
import { sendPushNotification } from "./notifications.service";

export async function sendStreakReminder() {
    console.log("\nSENDING STREAK REMINDER NOTIFICATION\n");
    const _users = await User.find();
    console.log(_users);

    for (const user of _users) {
        console.log(user.fullName);
        if (user.fullName !== "" && user.deviceToken !== undefined) {
            console.log("\nSending notification to " + user.fullName + "\n");
            if (user.fullName.replace(" ", "") != "Stefano") {
                // sendPushNotification(
                //     [user.deviceToken],
                //     `Hi ${user.fullName.split(" ")[0]}! Don't lose your ${user.streak} day streak!`,
                //     `Keep meditating to build a habit 🔥`,
                //     {}, true, null
                // );
                console.log(`Hi ${user.fullName.split(" ")[0]}! Don't lose your ${user.streak} day streak!`);
                console.log(`Keep meditating to build a habit 🔥`);
            }
        }
    }

}
