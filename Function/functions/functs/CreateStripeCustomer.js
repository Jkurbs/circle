
const functions = require('firebase-functions');
const admin = require('firebase-admin');

var stripe = require('stripe')('sk_test_4eC39HqLyjWDarjtT1zdp7dc');




exports = module.exports = functions.auth.user().onCreate(async (user) => {
	const customer = await stripe.customers.create({email: user.email});
	return admin.firestore().collection('stripe_customers').doc(`${user.uid}`).set({
		customer_id: customer.id,
	}).then(function() {
		console.log('Document successfully written!');
	}).catch(function(error) {
		console.error('Error writing document: ', error);
	}); 
});