

const functions = require('firebase-functions');
const admin = require('firebase-admin');
try {admin.initializeApp(functions.config().firebase);} catch(e) {}

const stripe = require('stripe')("sk_test_QfBDc4JT7E6iz8EwrsuJcR58");

// [START createExternalAccount]
exports = module.exports = functions.firestore.document('/users/{userId}/sources/{pushkey}').onWrite(event => {
      const token = event.data.data().token;
        console.log('STRIPE TOKEN', token);
      if (token === null) return null;
      // Look up the Stripe customer id written in createStripeAccount
      return admin.firestore().collection('users').doc(`${event.params.userId}`).get().then(snapshot => {
         return snapshot.data(); 
      }).then(customer => {
           if (customer === null) return null;
          return stripe.accounts.createExternalAccount(customer.customer_id,{ 
                external_account: token
        });  
    });
});