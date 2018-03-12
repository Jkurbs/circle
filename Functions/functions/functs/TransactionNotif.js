

const admin = require('firebase-admin');
const functions = require('firebase-functions');

// TODO: Make sure you configure the 'dev_motivator.device_token' Google Cloud environment variables.
const deviceToken = 'fLQweBJF-dU:APA91bE7BCyn9Y_cqTbRfTzlrcLqPzzapPl1pGsSEgYR3_3v-u7ieaEYTmre2vh5oVnOIrb1z9P1VkNitljRYoY2UI0K9bxN0aO2pZ1astR2D2_wUrGVI68LSeYoDF_7VLyMm01rWLbF'

/**
 * Triggers when the app is opened the first time in a user device and sends a notification to your developer device.
 *
 * The device model name, the city and the country of the user are sent in the notification message
 */

exports = module.exports = functions.firestore.document('/users/{userId}/event/{id}').onWrite(event => {
    
    const val = event.data.data();
    const amount = val.amount;
    const first_name = val.first_name; 
    const last_name = val.last_name; 
    
    
 return admin.firestore().collection('users').doc(`${event.params.userId}`).get().then(snapshot => {
         return snapshot.data(); 
    }).then(account => { 
        const options = {
          priority: 'high',
          content_available: true,
       };
        const payload = {
        notification: {
          title: `You received ${amount}.`,
          body: `You received ${amount} dollards from ${first_name} ${last_name}.`,
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
  });
});




/**
 * Triggers when a user gets a new follower and sends a notification.
 *
 * Followers add a flag to `/followers/{followedUid}/{followerUid}`.
 * Users save their device notification tokens to `/users/{followedUid}/notificationTokens/{notificationToken}`.
 */
//exports = module.exports =  functions.firestore.document('/users/{userId}/received/{id}').onWrite((event) => {
//  const receiverUid = event.params.userId;
//  const val = event.data.data();
//  const first_name = val.first_name;
//console.log('FIRST NAME', first_name);
//  const last_name = val.last_name;
//  // If un-follow we exit the function.
//
//  // Get the list of device notification tokens.
//  const getDeviceTokensPromise = deviceToken;
//
//  // Get the follower profile.
//  const getFollowerProfilePromise = admin.auth().getUser(receiverUid);
//
//  return Promise.all([getDeviceTokensPromise, getFollowerProfilePromise]).then((results) => {
//    const tokensSnapshot = results[0];
//    const follower = results[1];
//
//    // Check if there are any device tokens.
////    if (!tokensSnapshot.hasChildren()) {
////      return console.log('There are no notification tokens to send to.');
////    }
////    console.log('There are', tokensSnapshot.numChildren(), 'tokens to send notifications to.');
////    console.log('Fetched follower profile', follower);
//
//    // Notification details.
//    const payload = {
//      notification: {
//        title: 'You have a new follower!',
//        body: `is now following you.`,
//        //icon: follower.photoURL,
//      },
//    };
//
//    // Listing all tokens.
//   // const tokens = Object.keys(tokensSnapshot.val());
//
//    // Send notifications to all tokens.
//    return admin.messaging().sendToDevice(getDeviceTokensPromise, payload);
//  }).then((response) => {
//    // For each message check if there was an error.
//    const tokensToRemove = [];
//    response.results.forEach((result, index) => {
//      const error = result.error;
//      if (error) {
//        console.error('Failure sending notification to', tokens[index], error);
//        // Cleanup the tokens who are not registered anymore.
//        if (error.code === 'messaging/invalid-registration-token' || error.code === 'messaging/registration-token-not-registered') {
//          tokensToRemove.push(tokensSnapshot.ref.child(tokens[index]).remove());
//        }
//      }
//    });
//    return Promise.all(tokensToRemove);
//  });
//});