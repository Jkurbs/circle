
const admin = require('firebase-admin');
const functions = require('firebase-functions');

// TODO: Make sure you configure the 'dev_motivator.device_token' Google Cloud environment variables.
const deviceToken = 'f0t2SmIJtXs:APA91bF0FkN9yn354oWiUmA0V8-pvEIYNFkIekxPny68XZ92G1UxjlQ-h4Llro7icotn4BqTqK1lb_fPzzWeU8f0naZO9LEWSPfTogJuMDN4fNY-PH5CQao8F1OWAgxcIJvOb6XLBv2t'


/**
 * Triggers when the app is opened the first time in a user device and sends a notification to your developer device.
 *
 * The device model name, the city and the country of the user are sent in the notification message
 */

exports = module.exports = functions.analytics.event('first_open').onLog((event) => {
  const payload = {
    notification: {
      title: 'You have a new user \uD83D\uDE43',
      body: event.data.user.deviceInfo.mobileModelName + ' from ' + event.data.user.geoInfo.city + ', ' + event.data.user.geoInfo.country,
      sound:"default",
      vibrate:"true"
    },
  };
    return admin.messaging().sendToDevice(deviceToken, payload);
});

