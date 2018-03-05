 // Create and Deploy Your First Cloud Functions
 // https://firebase.google.com/docs/functions/write-firebase-functions


'use strict';

const functions = require('firebase-functions'),
      admin = require('firebase-admin'),
      logging = require('@google-cloud/logging')();

admin.initializeApp(functions.config().firebase);

const stripe = require('stripe')("sk_test_QfBDc4JT7E6iz8EwrsuJcR58"),
      currency = 'USD';


var db = admin.firestore();

const fs = require('fs');
const path = require('path');

// Folder where all your individual Cloud Functions files are located.
const FUNCTIONS_FOLDER = './functs';

fs.readdirSync(path.resolve(__dirname, FUNCTIONS_FOLDER)).forEach(file => { // list files in the folder.
  if(file.endsWith('.js')) {
    const fileBaseName = file.slice(0, -3); // Remove the '.js' extension
    if (!process.env.FUNCTION_NAME || process.env.FUNCTION_NAME === fileBaseName) {
      exports[fileBaseName] = require(`${FUNCTIONS_FOLDER}/${fileBaseName}`);
    }
  }
});






 //Add a payment source (card) for a user by writing a stripe payment source token to Realtime database
//exports.addPaymentSource = functions.database.ref('/users/{userId}/sources/{pushId}/token').onWrite(event => {
//  const source = event.data.val();
//  if (source === null) return null;
//  return admin.database().ref(`/users/${event.params.userId}/customer_id`).once('value').then(snapshot => {
//    return snapshot.val();
//  }).then(customer => {
//    return stripe.customers.createSource(customer, {source});
//  }).then(response => {
//      return event.data.adminRef.parent.set(response);
//    }, error => {
//      return event.data.adminRef.parent.child('error').set(userFacingMessage(error)).then(() => {
//        return reportError(error, {user: event.params.userId});
//      });
//  });
//});

// To keep on top of errors, we should raise a verbose error report with Stackdriver rather
// than simply relying on console.error. This will calculate users affected + send you email
// alerts, if you've opted into receiving them.
// [START reporterror]
function reportError(err, context = {}) {
  // This is the name of the StackDriver log stream that will receive the log
  // entry. This name can be any valid log stream name, but must contain "err"
  // in order for the error to be picked up by StackDriver Error Reporting.
  const logName = 'errors';
  const log = logging.log(logName);

  // https://cloud.google.com/logging/docs/api/ref_v2beta1/rest/v2beta1/MonitoredResource
  const metadata = {
    resource: {
      type: 'cloud_function',
      labels: { function_name: process.env.FUNCTION_NAME }
    }
  };

  // https://cloud.google.com/error-reporting/reference/rest/v1beta1/ErrorEvent
  const errorEvent = {
    message: err.stack,
    serviceContext: {
      service: process.env.FUNCTION_NAME,
      resourceType: 'cloud_function'
    },
    context: context
  };

  // Write the error log entry
  return new Promise((resolve, reject) => {
    log.write(log.entry(metadata, errorEvent), error => {
      if (error) { reject(error); }
      resolve();
    });
  });
}
// [END reporterror]

// Sanitize the error message for the user
function userFacingMessage(error) {
  return error.type ? error.message : 'An error occurred, developers have been alerted';
}

