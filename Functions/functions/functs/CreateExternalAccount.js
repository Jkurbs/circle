

const functions = require('firebase-functions');
const admin = require('firebase-admin');
try {admin.initializeApp(functions.config().firebase);} catch(e) {}

const stripe = require('stripe')("sk_test_QfBDc4JT7E6iz8EwrsuJcR58");

// When a user is created, register them with Stripe
exports = module.exports = functions.auth.user().onCreate(event => {
  const user = event.data;
  return stripe.accounts.create({
    type: 'custom',
    country: 'US', 
    default_currency: 'USD'
  }).then(customer => {
    var data = {
    account_id: customer.id
  };
    return admin.firestore().collection('users').doc(`${user.uid}`).set(data, {merge: true});
  });
});
// [END createStripeAccount]
