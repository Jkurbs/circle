


const functions = require('firebase-functions');
const admin = require('firebase-admin');
const stripe = require('stripe')('sk_test_QfBDc4JT7E6iz8EwrsuJcR58');


exports = module.exports = functions.auth.user().onCreate((user) => {    
    
	return admin.database().ref('/users').child(user.uid).once('value').then(function(snapshot) {
        
		const val = snapshot.val();
        
		return stripe.accounts.create({
			country: 'US',
			type: 'individual',
			first_name: val.first_name,
			last_name: val.last_name, 
			email: user.email

		}).then(function(acct) {
			return admin.database().ref(`/stripe/${user.uid}/accountId`).set(acct.id);
		}).then(() => {
			return stripe.customers.create({
				email: user.email,
			}).then((customer) => {
				return admin.database().ref(`/stripe/${user.uid}/customerId`).set(customer.id);
			});
		});    
	});
});