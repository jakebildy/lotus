import { User } from "../models/user.model";
import { sendPushNotification } from "./notifications.service";


// Function to get a random item from an array
function getRandomItem<T>(items: T[]): T {
    return items[Math.floor(Math.random() * items.length)];
}

const notificationTitles = [
    'Time to meditate!',
    'Meditation time!',
    'Let’s meditate!',
    'Take a moment to meditate',
    'Step back and meditate'
];

const notificationMessages = [
    'Take some time to just be',
    'Your mind deserves a break',
    'You will enjoy today more if you meditate',
    'Reconnect with yourself',
    'Give yourself permission to pause',
    'It will make your day better',
];


export async function sendStreakReminder() {
    console.log("\nSENDING STREAK REMINDER NOTIFICATION\n");
    const _users = await User.find();
    // console.log(_users);

    for (const user of _users) {
        //   console.log(user.fullName);
        if (user.fullName !== "" && user.deviceToken !== undefined) { //switch back to user.fullName !== ""
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
            let title = getRandomItem(notificationTitles);
            let message = getRandomItem(notificationMessages);

            if (user.lastMeditated && user.streak && user.streak !== 0) {
                const lastMeditatedTime = new Date(user.lastMeditated).getTime();
                const currentTime = Date.now();
                const hoursSinceLastMeditation = (currentTime - lastMeditatedTime) / (1000 * 60 * 60);
            
                if (hoursSinceLastMeditation <= 24) {
                    title = getRandomItem([
                        'Keep your ' + user.streak + ' day streak going 🔥',
                        `Don't let your ` + user.streak + ` day streak die 🔥`,
                    `Can you make it to ` + (user.streak! + 1).toString() + ` days? 🔥`]);
                }
            }

            // if (user.totalMinutes == 0 && user.streak == 0) {
            //     title = getRandomItem([
            //         'Can you meditate for just 1 minute 🥺',
            //         'Want meditation as a habit? Start today 🔥',
            //         'I dare you to meditate today 😎',
            //         'how about 1 minute of meditation? 🤔',
            //         'hey. 1 minute of meditation. now. 🤨',
            //         `imagine how cool you'd be if you meditated today 🤯`,
                
            //     ]);
            //     message = '';
            // }

            sendPushNotification(
                    [user.deviceToken],
                    title,
                    message,
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
