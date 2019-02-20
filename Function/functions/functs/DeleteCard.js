
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const stripe = require('stripe')('sk_test_QfBDc4JT7E6iz8EwrsuJcR58');

exports = module.exports =  functions.database.ref('/cards/{userId}/{id}')
	.onDelete((snap, context) => {

		const cardId = snap.val().id;

		const userId = context.params.userId;

		const stripeRef = admin.database().ref('/stripe').child(userId).child('customerId');
		let customerId;

		return stripeRef.once('value').then(function(snapshot) {
			customerId = snapshot.val();
		}).then(() => {
			return stripe.customers.deleteCard(
				customerId,
				cardId,
				function(err, confirmation) {
					console.log('Card deleted:', confirmation.deleted);
					return admin.database().ref('/cards').child(userId).child(cardId).remove();
				}
			);
		});
	});
