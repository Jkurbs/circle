const functions = require('firebase-functions');
const admin = require('firebase-admin');
const stripe = require('stripe')('sk_test_QfBDc4JT7E6iz8EwrsuJcR58');

exports = module.exports = functions.auth.user().onCreate((user) => {
	return stripe.customers.create({
		email: user.email,
	}).then((customer) => {
		return admin.database().ref(`/stripe/${user.uid}/customerId`).set(customer.id);
	});
});
