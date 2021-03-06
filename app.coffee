# Modules
express =     require 'express'
fs =          require 'fs'
multiparty =  require 'multiparty'
mongojs =     require 'mongojs'
csvtojson =   require 'csvtojson'
routes =      require './routes'

# Initialize Express
app = express()

# Get port and environment
port = process.env.PORT or 3000
env = app.get 'env'

# Database connections
databaseUrl = process.env.MONGOHQ_URL
collections = ['families', 'facts']
db = mongojs.connect databaseUrl, collections

# all environments
app.configure ->
	app.set 'port', port
	app.set 'views', __dirname + '/views'
	app.set 'view engine', 'jade'
	app.use express.favicon(__dirname + '/public/favicon.ico')
	app.use express.logger('dev')
	app.use express.json()
	app.use express.urlencoded()
	app.use express.methodOverride()
	app.use require('less-middleware')(
		src: __dirname + '/public'
		yuicompress: true
	)
	app.use require('express-coffee')(
		path: __dirname + '/public'
		uglify: env is 'production'
	)
	app.use express.static(__dirname + '/public')
	app.use app.router

# development only
app.configure 'development', -> app.use express.errorHandler()

routes app, db, multiparty, csvtojson

app.listen port, ->
	console.log 'Goan Convention 2014 running at port ' + port + ' in ' + env + ' mode'

