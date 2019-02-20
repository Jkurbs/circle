const functions = require('firebase-functions');
const admin = require('firebase-admin');
const stripe = require('stripe')('sk_test_QfBDc4JT7E6iz8EwrsuJcR58');



exports = module.exports = functions.database.ref('/circles/{id}')
	.onCreate((change, context) => {

		const circleId = context.params.id;

		return stripe.products.create({
			name: circleId,
			type: 'service',
		}).then(function(product) {
			return admin.database().ref(`/circles/${circleId}/productId`).set(product.id);
		});
	});
