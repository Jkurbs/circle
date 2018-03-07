
//
//
const functions = require('firebase-functions');
const admin = require('firebase-admin');
try {admin.initializeApp(functions.config().firebase);} catch(e) {}

const stripe = require('stripe')("sk_test_QfBDc4JT7E6iz8EwrsuJcR58");

var plaid = require('plaid');
var plaidClient = new plaid.Client('5a996f57bdc6a467e110751b', 'c3748d52f353056b2319ecc5aced77', 'f4ca51e7acd2e7241957a0df256d8e', plaid.environments.sandbox);

exports = module.exports = functions.firestore.document('/users/{userId}/plaid/{id}').onWrite(event => {
     const val = event.data.data();
    if (val === null) return null;
    const publicToken = val.public_token; 
    const accountId = val.account_id; 
    const email = val.email_address; 
  return admin.firestore().collection('users').doc(`${event.params.userId}`).get().then(snapshot => {
     return snapshot.data();
  }).then(customer => {
      
    return plaidClient.exchangePublicToken(publicToken, function(err, res) {
        var accessToken = res.access_token;
        var item_id = res.item_id;
      // Generate a bank account token
      plaidClient.createStripeToken(accessToken, accountId, function(err, res) {
          var bankAccountToken = res.stripe_bank_account_token;
         return stripe.accounts.createExternalAccount(customer.account_id,{ 
            external_account: bankAccountToken, 
         });
        });
       });
     });
   });