const functions = require('firebase-functions');
const admin = require('firebase-admin');
const stripe = require('stripe')('sk_test_QfBDc4JT7E6iz8EwrsuJcR58');

exports = module.exports = functions.database.ref('/users/{id}/address')
	.onCreate((change, context) => {

		const userId = context.params.id;

		const city = change.val().city;
		const country = change.val().country;
		const line1 = change.val().line1;
		const postalCode = change.val().postalCode;
		const state = change.val().state;

		const stripeRef = admin.database().ref(`/stripe/${userId}/accountId`);

		return stripeRef.once('value').then(function(snapshot) {
			let accountId = snapshot.val();
			return stripe.accounts.update(accountId, {
				legal_entity: {
					address: {
						city: city,
						country: country,
						line1: line1,
						line2: null,
						postal_code: postalCode,
						state: state,
					},
				},
			});
		});
	});
