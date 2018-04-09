



const admin = require('firebase-admin');
const functions = require('firebase-functions');

// TODO: Make sure you configure the 'dev_motivator.device_token' Google Cloud environment variables.
const deviceToken = 'fLQweBJF-dU:APA91bE7BCyn9Y_cqTbRfTzlrcLqPzzapPl1pGsSEgYR3_3v-u7ieaEYTmre2vh5oVnOIrb1z9P1VkNitljRYoY2UI0K9bxN0aO2pZ1astR2D2_wUrGVI68LSeYoDF_7VLyMm01rWLbF'

/**
 * Triggers when the app is opened the first time in a user device and sends a notification to your developer device.
 *
 * The device model name, the city and the country of the user are sent in the notification message
 */

exports = module.exports = functions.firestore.document('/users/{userId}/events/{id}').onWrite(event => {
    
    const val = event.data.data();
    const amount = val.amount;
    const first_name = val.first_name; 
    const last_name = val.last_name; 
    const type = val.type; 
    
    return admin.firestore().collection('users').doc(`${event.params.userId}`).get().then(snapshot => {
    return snapshot.data();
  }).then(account => { 
         const sender_first_name = account.first_name; 
         const deviceToken = account.device_token;
         var body = ''
         if (type === 'send') { 
            body = `You received ${amount} dollards from ${sender_first_name}.`
            sendNotification(sender_first_name, body, deviceToken);
         } else if (type === 'request') {
            body = `${first_name} requested ${amount} from you.`
            sendNotification(first_name, body, deviceToken);
         } 
    });
});


function sendNotification(first_name, body, deviceToken) {
    
     const options = {
        priority: 'high',
        content_available: true,
      };

     const payload = {
        notification: {
        title: first_name,
        body: body,
        sound:'default',
        vibrate:'true',
     },
    };
        return admin.messaging().sendToDevice(deviceToken, payload, options)
          .then(function(response) {
            console.log("Successfully sent message:", response);
          })
          .catch(function(error) {
         console.log("Error sending message:", error);
    });
}


