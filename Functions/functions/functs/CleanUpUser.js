

const functions = require('firebase-functions');
const admin = require('firebase-admin');
try {admin.initializeApp(functions.config().firebase);} catch(e) {}

const stripe = require('stripe')("sk_test_QfBDc4JT7E6iz8EwrsuJcR58");

// When a user deletes their account, clean up after them
exports = module.exports = functions.auth.user().onDelete(event => {
  return admin.firestore().collection('users').doc(`${event.data.uid}`).get().then(snapshot => {
    console.log('USER DELETING DATA..', snapshot.data());
    return snapshot.data();
  }).then(customer => {
        console.log('CUSTOMER ID.', customer.customer_id);
// change below, customer.customer_id vs customer
    return stripe.accounts.del(customer.customer_id);
  }).then(() => {
    return admin.firestore().collection('users').doc(`${event.data.uid}`).delete();
  });
});