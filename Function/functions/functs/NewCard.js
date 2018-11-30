
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const stripe = require('stripe')('sk_test_QfBDc4JT7E6iz8EwrsuJcR58');






exports = module.exports =  functions.database.ref('/cards/{userId}')
	.onCreate((snap, context) => {       
		const token = snap.token; 
		const userId = context.params.userId;
     
		const userRef = admin.database().ref('/stripe').child(userId).child('customerId');
		let customerId;
     
		return userRef.once('value').then(function(snapshot) { 
     
			customerId = snapshot.val();
     
     
		}).then(() => {
			return stripe.customers.createSource(
				customerId,
				{ source: token },
				function(err, card) {

					console.log('cardId:', card.id);
					console.log('error:', err);
					// asynchronously called
				}
			);
		});
	});
     
    