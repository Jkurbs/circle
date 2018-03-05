
//
//
const functions = require('firebase-functions');
const admin = require('firebase-admin');
try {admin.initializeApp(functions.config().firebase);} catch(e) {}

const stripe = require('stripe')("sk_test_QfBDc4JT7E6iz8EwrsuJcR58");

exports = module.exports = functions.firestore.document('/users/{userId}/sources/{id}').onWrite(event => {
     const val = event.data.data();
     if (val === null) return null;
     const source = val.token;
  return admin.firestore().collection('users').doc(`${event.params.userId}`).get().then(snapshot => {
     return snapshot.data();
  }).then(customer => {
      return stripe.accounts.createExternalAccount(customer.account_id,{ 
         external_account: source, 
    });
  });
});