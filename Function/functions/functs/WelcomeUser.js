'use strict';


// Sends a goodbye email to the given user.


let sendWelcomeEmail = (() => {
	var _ref2 = _asyncToGenerator(function* (email, displayName) {
		const mailOptions = {
			from: `${APP_NAME} <noreply@firebase.com>`,
			to: email
		};

		// The user unsubscribed to the newsletter.
		mailOptions.subject = 'Welcome!';
		mailOptions.text = `Hey ${displayName || ''}! Welcome to ${APP_NAME}. We provide an easy way to save money with your friends, familly or other thrusted users. I hope you will enjoy our service.`;
		yield mailTransport.sendMail(mailOptions);
		console.log('Welcome email sent to:', email); 
	});

	return function sendWelcomeEmail() {
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
 * Sends a welcome email to new user.
 */
// [START onCreateTrigger]
exports = module.exports = functions.auth.user().onCreate(user => {
	// [END onCreateTrigger]
	// [START eventAttributes]
	const email = user.email; // The email of the user.
	const displayName = user.displayName; // The display name of the user.

	return sendWelcomeEmail(email, displayName);
});
// [END sendWelcomeEmail]
