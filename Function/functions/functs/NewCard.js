const functions = require('firebase-functions');
const admin = require('firebase-admin');
const stripe = require('stripe')('sk_test_QfBDc4JT7E6iz8EwrsuJcR58');

exports = module.exports =  functions.database.ref('/cards/{userId}/{id}')
	.onCreate((snap, context) => {

		const accountToken = snap.val().accountToken;
		const sourceToken = snap.val().sourceToken;

		const userId = context.params.userId;

		const stripeRef = admin.database().ref('/stripe').child(userId);

		let accountId;
		let customerId;

		return stripeRef.once('value').then(function(snapshot) {
			accountId = snapshot.val().accountId;
			customerId = snapshot.val().customerId;
		}).then(() => {
			return stripe.accounts.createExternalAccount(
				accountId,
				{external_account: accountToken}
			).then(() => {
				return stripe.customers.createSource(
					customerId,
					{ source: sourceToken }
				);
			});
		});
	});
