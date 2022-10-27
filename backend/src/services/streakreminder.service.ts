import { User } from "../models/user.model";
import { sendPushNotification } from "./notifications.service";

export async function sendStreakReminder() {
    console.log("\nSENDING STREAK REMINDER NOTIFICATION\n");
    const _users = await User.find();
    // console.log(_users);

    for (const user of _users) {
        //   console.log(user.fullName);
        if (user.fullName !== "" && user.deviceToken !== undefined) {
            if (user.streak === undefined || user.streak == 0) {
                //console.log("\nSending notification to " + user.fullName + "\n");
                // sendPushNotification(
                //     [user.deviceToken],
                //     `Hi ${user.fullName.split(" ")[0]}! Try meditating for just 5 minutes!`,
                //     `Start a new habit (and collect turtles too 🐢)`,
                //     {}, true, null
                // );
                // console.log(`Hi ${user.fullName.split(" ")[0]}! Try meditating for just 5 minutes!`);
                //console.log(`Start a new habit (and collect turtles too 🐢)`);
            }

            //First day after meditating
            if (user.fullName == "joemama") {
                // console.log("\nSending notification to " + user.fullName + "\n");
                // sendPushNotification(
                //     [user.deviceToken],
                //     `${user.fullName.split(" ")[0]}! Your egg is so close to hatching 🥚`,
                //     `Can you meditate two days in a row?`,
                //     {}, true, null
                // );
                //console.log(`${user.fullName.split(" ")[0]}! Your egg is so close to hatching 🥚`);
                // console.log(`Can you meditate two days in a row?`);
            }


            // if (user.fullName == "mizuki") {
            //     console.log("\nSending notification to " + user.fullName + "\n");
            //     sendPushNotification(
            //         [user.deviceToken],
            //         `${user.fullName.split(" ")[0]}! Don't lose your streak 🔥`,
            //         `or I will be ANGERY :0`,
            //         {}, true, null
            //     );
            //     console.log(`${user.fullName.split(" ")[0]}! Don't lose your streak 🔥`);
            //     console.log(`Can you meditate four days in a row?`);
            // }
        }
    }

}
