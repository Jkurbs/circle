
const admin = require('firebase-admin');
const functions = require('firebase-functions');

// TODO: Make sure you configure the 'dev_motivator.device_token' Google Cloud environment variables.
const deviceToken = 'fLQweBJF-dU:APA91bE7BCyn9Y_cqTbRfTzlrcLqPzzapPl1pGsSEgYR3_3v-u7ieaEYTmre2vh5oVnOIrb1z9P1VkNitljRYoY2UI0K9bxN0aO2pZ1astR2D2_wUrGVI68LSeYoDF_7VLyMm01rWLbF'


/**
 * Triggers when the app is opened the first time in a user device and sends a notification to your developer device.
 *
 * The device model name, the city and the country of the user are sent in the notification message
 */

exports = module.exports = functions.analytics.event('first_open').onLog((event) => {
    
    
   const options = {
      priority: 'high',
   };
  const payload = {
    notification: {
      title: 'You have a new user \uD83D\uDE43',
      body: event.data.user.deviceInfo.mobileModelName + ' from ' + event.data.user.geoInfo.city + ', ' + event.data.user.geoInfo.country,
      sound:'default',
      vibrate:'true',
    },
  };
    return admin.messaging().sendToDevice(deviceToken, payload, options);
});

