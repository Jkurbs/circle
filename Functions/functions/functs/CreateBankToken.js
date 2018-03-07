

'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
try {admin.initializeApp(functions.config().firebase);} catch(e) {}

const stripe = require('stripe')("sk_test_QfBDc4JT7E6iz8EwrsuJcR58");

var plaid = require('plaid');
var plaidClient = new plaid.Client('5a996f57bdc6a467e110751b', 'c3748d52f353056b2319ecc5aced77', 'f4ca51e7acd2e7241957a0df256d8e', plaid.environments.sandbox);

//When a user is created, register them with Stripe
exports = module.exports = functions.firestore.document('/users/{userId}/plaid/{id}').onCreate(event => {
    const val = event.data.data();
    if (val === null) return null;
    const publicToken = val.public_token; 
    const accountId = val.account_id; 
    const email = val.email_address; 
    console.log('CUSTOMER token', publicToken);
    console.log('EMAIL_ADDRESS', email);
    return admin.firestore().collection('users').doc(`${event.params.userId}`).get().then(snapshot => {
    return snapshot.data();
  }).then(customer => {
        console.log('ACCOUNT ID', accountId);
        console.log('CUSTOMER EMAIL', customer.email_address);
          return plaidClient.exchangePublicToken(publicToken, function(err, res) {
            console.log('ACCOUNT_ID', res.account_id);
            var accessToken = res.access_token;
            var item_id = res.item_id;
            console.log('REF', res);
           console.log('ACCESS TOKEN', accessToken);
          // Generate a bank account token
            console.log('SECOND ACCOUNT ID', accountId);
          plaidClient.createStripeToken(accessToken, accountId, function(err, res) {
              console.log('BANK ACCOUNT TOKEN ERROR', err);
              console.log('BANK ACCOUNT TOKEN RESULT', res);
              var bankAccountToken = res.stripe_bank_account_token;
              var data = {
               token: bankAccountToken,
              };
             return admin.firestore().collection('users').doc(`${event.params.userId}`).collection('sources').doc(`${event.params.id}`).set(data, {merge: true});

          });
        });        
    });
});

