//        __
//       /oo\
//      |    |
//  ^^  (vvvv)  ^^
//  \\  /\__/\ //
//  \\/      \//
//  /        \        
// |          |    ^  
// /          \___/ | 
// (            )   |
//  \----------/   /
//   //    \\_____/      ANCIENT CODE (prehistoric code tbh)
//   W       W

import dotenv from "dotenv";
import axios from "axios";
// const axios = require('axios').default;
import admin, { ServiceAccount } from "firebase-admin";
import serviceAccount = require("../firebase/firebase.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount as ServiceAccount),
    databaseURL: "https://shellevate-41398-default-rtdb.firebaseio.com"
});

export function sendPushNotification(devices: any, title: any, body: any, data: any, sound: any, type: any) {
    if (devices.length == 0) return;
    const notification: any = {};
    notification.sound = sound != null ? sound : false;
    notification.registration_ids = devices;
    notification.data = {
        ...data,
        "type": type ?? data["type"] ?? "",
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
    }; //{"type": data.type, "data": data};
    notification.priority = "high"
    notification.tokens = devices
    notification.notification = { title: title, body: body }//, data: data, priority:  "high"},


    //https://fcm.googleapis.com/fcm/send
    //add to headers: "Authorization: key=<FCM SERVER KEY>"
    admin.messaging().sendEachForMulticast(notification)
        .then((response) => {

            // TODO fix notification failure because old tokens.
            // console.log(response.responses[0].error);
            if (response.failureCount > 0) {
                const failedTokens = [];
                response.responses.forEach((resp, idx) => {
                    if (!resp.success) {
                        // failedTokens.push(registrationTokens[idx]);
                        console.log("failed to send push notification :(");
                        console.log(resp.error);
                    } else {
                        console.log("succesfully sent push notification");
                    }
                });
                // console.log('List of tokens that caused failures: ' + failedTokens);
            }
        });
    // console.log(devices);
}


module.exports = {
    sendPushNotification
}