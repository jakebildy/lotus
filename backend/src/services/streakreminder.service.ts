import { User } from "../models/user.model";
import { sendPushNotification } from "./notifications.service";

export async function sendStreakReminder() {
    console.log("\nSENDING STREAK REMINDER NOTIFICATION\n");
    const _users = await User.find();
    // console.log(_users);

    for (const user of _users) {
        //   console.log(user.fullName);
        if (user.username === "jacob" && user.deviceToken !== undefined) { //switch back to user.fullName !== ""
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
            console.log("\nSending notification to " + user.fullName + "\n");
            sendPushNotification(
                    [user.deviceToken],
                    `Time to meditate!`,
                    `You definitely have 5 minutes to spare`,
                    {}, true, null
                );

            //First day after meditating
            // if (user.streak == 0) {
            //     console.log("\nSending notification to " + user.fullName + "\n");
            //     sendPushNotification(
            //         [user.deviceToken],
            //         `It's time to start meditating again!`,
            //         `Feel more relaxed after just 5 minutes 🐢`,
            //         {}, true, null
            //     );
            //     //console.log(`${user.fullName.split(" ")[0]}! Your egg is so close to hatching 🥚`);
            //     // console.log(`Can you meditate two days in a row?`);
            // }

  
            // if (user.streak == 0) {
            //     console.log("\nSending notification to " + user.fullName + "\n");
            //     sendPushNotification(
            //         [user.deviceToken],
            //         `You'll enjoy today more if you meditate`,
            //         `You have five minutes to spare 🔥`,
            //         {}, true, null
            //     );
            
            // }
        }
    }

}
