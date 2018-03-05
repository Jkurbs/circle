

const functions = require('firebase-functions');
const admin = require('firebase-admin');
try {admin.initializeApp(functions.config().firebase);} catch(e) {}

const stripe = require('stripe')("sk_test_QfBDc4JT7E6iz8EwrsuJcR58");


//When a user is created, register them with Stripe
exports = module.exports = functions.firestore.document('/users/{userId}/sources/{id}').onCreate(event => {
    const val = event.data.data();
    if (val === null) return null;
    const email = val.email_address; 
    const token = val.token; 
    console.log('CUSTOMER token', token);

    return admin.firestore().collection('users').doc(`${event.params.userId}`).get().then(snapshot => {
    return snapshot.data();
  }).then(customer => {
    return stripe.customers.create({
        email: email,
        source: token,
       }).then(customer => {
         var data = {
             customer_id: customer.id
        };
          return admin.firestore().collection('users').doc(`${event.params.userId}`).set(data, {merge: true});
        });
    });
});