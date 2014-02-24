start:
	PORT="5000" coffee app.coffee

startdb:
	mongod --dbpath=data

production:
	PORT="5000" NODE_ENV="production" coffee app.coffee