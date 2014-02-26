# Routes file

module.exports = (app, db, multiparty, csvtojson) ->
	# Universal Headers

	app.get "*", (req, res, next) -> 
		res.header "X-UA-Compatible", "IE=edge,chrome=1"
		next()


	# GET requests for every page on site

	app.get "/", (req, res) -> res.render "index"
	app.get "/schedule", (req, res) -> res.render "schedule"
	app.get "/sponsors", (req, res) -> res.render "sponsors"
	app.get "/pastevents", (req, res) -> res.render "pastevents"
	app.get "/register", (req, res) -> res.render "register"


	# Registration List REST API

	app.get "/registration-list", (req, res) ->
		res.header "Content-type", "text/json"
		db.families.find({}, (_id: 0)).sort (last: 1), (err, data) ->
			res.json data

	app.post "/registration-list", (req, res) ->

		output = (code, success, message) ->
			message = message or ""
			res.status(code).json (success: success, message: message)

		unless req.headers['content-type']? and req.headers['content-type'].substring(0, 19) is "multipart/form-data"
			output 403, false, "You did not upload a file!"
			return

		form = new multiparty.Form()
		form.parse req, (err, fields, files) ->

			unless fields.pass? and fields.pass[0] is process.env.AUTH_PASS
				output 401, false, "Invalid password! Password must be in 'pass' parameter."
				return

			unless files.file? 
				output 403, false, "Invalid POST request! File must be in 'file' parameter."
				return

			converter = new csvtojson.core.Converter()
			path = files.file[0].path
			results = []

			converter.on "record_parsed", (row, raw, i) ->
				first = row['First Name:']
				last = row['Last Name:']
				city = row['City:']
				state = row['State:']
				guestFirst = row['Guest of First Name']
				guestLast = row['Guest of Last Name']

				if guestFirst and guestLast
					# is a guest
					db.families.update (
						first: guestFirst
						last: guestLast
					), (
						$push: (
							guests: (
								$each: [first]
							)
						)
					)
					results.push "-> " + first + " has been added as a guest of " + guestFirst + " " + guestLast
				else
					# is a leader
					db.families.insert (
						first: first
						last: last
						city: city
						state: state
						guests: []
					)
					results.push first + " " + last + " lives in " + city + ", " + state

			converter.on "end_parsed", (json) -> output 200, true, results

			db.families.remove {}, -> converter.from path


	# 404 Errors

	app.get "*", (req, res) -> res.status(404).render "404"
	app.post "*", (req, res) -> res.status(404).render "404"