'use strict';

const admin = require('firebase-admin');
const stripe = require('stripe')('sk_test_QfBDc4JT7E6iz8EwrsuJcR58');


// Sends a goodbye email to the given user.


let sendGoodbyeEmail = (() => {
	var _ref2 = _asyncToGenerator(function* (email, displayName) {
		const mailOptions = {
			from: `${APP_NAME} <noreply@firebase.com>`,
			to: email
		};

		// The user unsubscribed to the newsletter.
		mailOptions.subject = 'Bye!';
		mailOptions.text = `Hey ${displayName || ''}!, We confirm that we have deleted your ${APP_NAME} account.`;
		yield mailTransport.sendMail(mailOptions);
		console.log('Account deletion confirmation email sent to:', email);
	});

	return function sendGoodbyeEmail() {
		return _ref2.apply(this, arguments);
	};
})();

function _asyncToGenerator(fn) { return function () { var gen = fn.apply(this, arguments); return new Promise(function (resolve, reject) { function step(key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { return Promise.resolve(value).then(function (value) { step('next', value); }, function (err) { step('throw', err); }); } } return step('next'); }); }; }

const functions = require('firebase-functions');
const nodemailer = require('nodemailer');
// Configure the email transport using the default SMTP transport and a GMail account.
// For Gmail, enable these:
// 1. https://www.google.com/settings/security/lesssecureapps
// 2. https://accounts.google.com/DisplayUnlockCaptcha
// For other types of transports such as Sendgrid see https://nodemailer.com/transports/
// TODO: Configure the `gmail.email` and `gmail.password` Google Cloud environment variables.

const gmailEmail = functions.config().gmail.email;
const gmailPassword = functions.config().gmail.password;

//functions.config().gmail.password;
const mailTransport = nodemailer.createTransport({
	service: 'gmail',
	auth: {
		user: gmailEmail,
		pass: gmailPassword
	}
});

// Your company name to include in the emails
// TODO: Change this to your app or company name to customize the email sent.
const APP_NAME = 'Sparen';

// [START sendWelcomeEmail]
/**


// [START sendByeEmail]
/**
* Send an account deleted email confirmation to users who delete their accounts.
*/
// [START onDeleteTrigger]
exports = module.exports = functions.auth.user().onDelete(user => {
// [END onDeleteTrigger]
	const email = user.email;
	const displayName = user.displayName;

	const stripeRef = admin.database().ref('/stripe').child(user.uid);

	let accountId; let customerId;
	return stripeRef.once('value').then(function(snapshot) {
		accountId = snapshot.val().accountId;
		customerId = snapshot.val().customerId;
	}).then(() => {
		stripe.customers.del(customerId);
		stripe.accounts.del(accountId);
	}).then(() => {
		//Remove everything
		return admin.database().ref(`/users/${user.uid}`).remove();
	}).then(() => {
		return sendGoodbyeEmail(email, displayName);
	});
});
