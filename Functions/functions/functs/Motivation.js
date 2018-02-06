
const admin = require('firebase-admin');
const functions = require('firebase-functions');

// TODO: Make sure you configure the 'dev_motivator.device_token' Google Cloud environment variables.
const deviceToken = 'c4UbtwKQow:APA91bHsYSlR2Bh4EjNcGLZBsJwyTNPCIRtuRmALWdO8HBZjzGpx1MOz8AJYd_4wTXkUowErdQnoaAiB5bMqBb37GUGk6rWfDFetGTK0beOmHX8A9jHadijsFym9ldpjujfMCzk6j8_p'

/**
 * Triggers when the app is opened the first time in a user device and sends a notification to your developer device.
 *
 * The device model name, the city and the country of the user are sent in the notification message
 */
exports = module.exports = functions.analytics.event('first_open').onLog(event => {
    const payload = {
      notification: {
        title: 'you have a new user \uD83D\uDE43',
        body: event.data.user.deviceInfo.mobileModelName + ' from ' + event.data.user.geoInfo.city + ', ' + event.data.user.geoInfo.country,
        sound:"default",
        vibrate:"true"
      }
    };

    admin.messaging().sendToDevice(deviceToken, payload);
});

