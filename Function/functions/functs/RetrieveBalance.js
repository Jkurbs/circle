
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const stripe = require('stripe')('sk_test_QfBDc4JT7E6iz8EwrsuJcR58');


exports = module.exports = functions.https.onCall((data, context) => {

	console.log('USERID:', data.userId);
	const userId = context.auth.uid;
	console.log(userId);

	if (userId === null) {
		return null;
	}

	const stripeRef = admin.database().ref('/stripe').child(userId);

	return stripeRef.once('value').then(function(snapshot) {
		return snapshot.val().accountId;
	}).then(function(accountId) {
		return stripe.balance.retrieve({
			stripe_account: accountId,
		}).then(function(balance) {
			let amount = balance.available[0].amount || 0;
			console.log('amount:', amount);
      admin.database().ref(`/users/${userId}`).child('balance').set(balance.amount);
			return { amount: amount };
		});
	});
});
