module.exports = {
	appName: 'Sparen', 
	port: 3000,
	secret: 'YOUR_SECRET',
	// Configuration for Stripe.
	// API Keys: https://dashboard.stripe.com/account/apikeys
	// Connect Settings: https://dashboard.stripe.com/account/applications/settings
	stripe: {
		secretKey: 'sk_test_QfBDc4JT7E6iz8EwrsuJcR58',
		publishableKey: 'pk_test_7El6nynr3wdrWwMltimfThlk',
		clientId: 'YOUR_STRIPE_CLIENT_ID',
		authorizeUri: 'https://connect.stripe.com/express/oauth/authorize',
		tokenUri: 'https://connect.stripe.com/oauth/token'
	},
	// Configuration for MongoDB.
	mongo: {
		uri: 'mongodb://localhost/rocketrides'
	},
	// Configuration for Google Cloud (only useful if you want to deploy to GCP).
	gcloud: {
		projectId: 'YOUR_PROJECT_ID'
	}
};