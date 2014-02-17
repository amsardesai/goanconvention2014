# Routes file

module.exports = (app) ->
	# Universal Headers
	app.get "*", (req, res, next) -> 
		res.header "X-UA-Compatible", "IE=edge,chrome=1"
		next()

	app.get "/", (req, res) -> res.render "index"
	app.get "/schedule", (req, res) -> res.render "schedule"
	app.get "/sponsors", (req, res) -> res.render "sponsors"
	app.get "/pastconventions", (req, res) -> res.render "pastconventions"
	app.get "*", (req, res) -> res.status(404).render "404"
