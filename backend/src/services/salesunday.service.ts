import { User } from "../models/user.model";
import { sendPushNotification } from "./notifications.service";
import { run } from "./revery.service";

export async function sendSaleSundayNotification() {
    console.log("\nSENDING SALES SUNDAY NOTIFICATION\n");
    const _users = await User.find();
    console.log(_users);

    for (const user of _users) {
        console.log(user.fullName);
        if (user.fullName !== "" && user.deviceToken !== undefined){
            console.log("\nSending notification to " + user.fullName + "\n");
            sendPushNotification(
            [user.deviceToken], 
            `Hi ${user.fullName.split(" ")[0]}! It's Sale Sundays 🤑🤑`,
            `Check out our biggest sales, only available until midnight 🔥`,
            {}, true, null
            );
            }
        }

  }
