const functions = require('firebase-functions');
const admin = require('firebase-admin');
const stripe = require('stripe')('sk_test_QfBDc4JT7E6iz8EwrsuJcR58');


exports = module.exports = functions.database.ref('/users/{id}/daysLeft')
	.onUpdate((change, context) => {

		const userId = context.params.id;

		const before = change.before.val();
		const after = change.after.val();

		if (before === after || after > 0) { return null; }

		let accountId;

		const stripeRef = admin.database().ref('/stripe').child(userId);
		const usersRef = admin.database().ref('/users').child(userId);

		return stripeRef.once('value').then(function(snapshot) {
			accountId = snapshot.val().accountId;
			return console.log('accountId:', accountId);
		}).then(() => {
			return usersRef.once('value').then(function(snapshot) {
				return snapshot.val().circleId;
			}).then(function(circleId) {
				const circleRef = admin.database().ref('/circles').child(circleId);
				return circleRef.once('value').then(function(snapshot) {
					return snapshot.val().amount;
				}).then(function(amount) {
					return stripe.transfers.create({
						amount: amount * 100,
						currency: 'usd',
						destination: accountId,
					});
				});
			});
		});
	});
