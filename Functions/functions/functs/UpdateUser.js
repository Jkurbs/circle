'use strict';


const functions = require('firebase-functions');
const admin = require('firebase-admin');
try {admin.initializeApp(functions.config().firebase);} catch(e) {}

const stripe = require('stripe')("sk_test_QfBDc4JT7E6iz8EwrsuJcR58");

exports = module.exports = functions.firestore.document('/users/{userId}').onWrite(event => {
      const val = event.data.data();
      if (val === null) return null;
      // Look up the Stripe customer id written in createStripeAccount
      return admin.firestore().collection('users').doc(`${event.params.userId}`).get().then(snapshot => {
         return snapshot.data(); 
      }).then(account => {
           const email_address = val.email_address;
           const first_name = val.first_name;
           const last_name = val.last_name;
           const day = val.dob_day;
           const month = val.dob_month;
           const year = val.dob_year;
           const ip_address = val.ip_address;
                         
          return stripe.accounts.update(account.account_id, {
                email: email_address,
                legal_entity: {
                dob: {
                    day: day,
                    month: month,
                    year: year
                },
                    first_name: first_name,
                    last_name: last_name,
                    type: 'individual'
                },

                tos_acceptance: {
                    date: Math.floor(Date.now() / 1000),
                    ip: ip_address // Assumes you're not using a proxy
                }
             });
         });
    });
