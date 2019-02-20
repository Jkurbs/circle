const functions = require('firebase-functions');
const admin = require('firebase-admin');
const stripe = require('stripe')('sk_test_QfBDc4JT7E6iz8EwrsuJcR58');
const ip = require('ip');


exports = module.exports = functions.database.ref('/users/{id}')
	.onCreate((change, context) => {

		const userId = context.params.id;

		const firstName = change.val().first_name;
		const lastName = change.val().last_name;
		const email = change.val().email;

		const dobRef = change.ref.child('dateOfBirth');

		return dobRef.once('value').then(function(snapshot) {
			let day = snapshot.val().day;
			let month = snapshot.val().month;
			let year = snapshot.val().year;
			return stripe.accounts.create({
				country: 'US',
				type: 'custom',
				email: email,
				default_currency: 'usd',
				legal_entity: {
					first_name: firstName,
					last_name: lastName,
					type : 'individual',
					dob: {
						day: day,
						month: month,
						year: year,
					},
				},
				tos_acceptance: {
					date: Math.floor(Date.now() / 1000),
					ip: ip.address(), // Assumes you're not using a proxy
				},
				support_email: email,
			}).then(function(acct) {
				return admin.database().ref(`/stripe/${userId}/accountId`).set(acct.id);
			});
		});
	});
