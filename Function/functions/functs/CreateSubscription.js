

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const stripe = require('stripe')('sk_test_QfBDc4JT7E6iz8EwrsuJcR58');


exports = module.exports = functions.database.ref('/insights/{circleId}').onCreate((change, context) => {

	const circleId = context.params.circleId;
	const amount = (change.val().weeklyAmount + 1.0 ) * 100 ;

	const circleRef = admin.database().ref('/circles').child(circleId);
	const membersRef = admin.database().ref('/members').child(circleId);
	const stripeRef = admin.database().ref('/stripe');

	let productId;

	circleRef.once('value').then(function(snapshot) {
		productId = snapshot.val().productId;
	});

	return membersRef.once('value').then(function(snapshot) {
		return snapshot.forEach(function(childSnapshot) {
			var childKey = childSnapshot.key;
			stripeRef.child(childKey).on('value', function(snapshot) {
				const customerId = snapshot.val().customerId;

				return stripe.plans.create({
					currency: 'usd',
					interval: 'week',
					product: productId,
					amount: Math.round(amount),
				}).then(function(plan) {
					return stripe.subscriptions.create({
						customer: customerId,
						billing: 'charge_automatically',
						items: [
							{
								plan: plan.id,
							},
						],
					}).then(function(subscription) {
						return admin.database().ref(`/circles/${circleId}/subscriptionId`).set(subscription.id);
					});
				});
			});
		});
	});
});
