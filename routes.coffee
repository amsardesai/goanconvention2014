# Routes file

module.exports = (app, db, multiparty, csvtojson) ->
	# Universal Headers

	app.get "*", (req, res, next) -> 
		res.header "X-UA-Compatible", "IE=edge,chrome=1"
		next()


	# GET requests for every page on site

	app.get "/", (req, res) -> 
		daysleft = Math.ceil (1404460800000 - Date.now()) / 86400000
		res.render "index", (daysleft: daysleft)
	
	app.get "/schedule", (req, res) -> res.render "schedule"
	app.get "/sponsors", (req, res) -> res.render "sponsors"
	app.get "/venue", (req, res) -> res.render "venue"
	app.get "/team", (req, res) -> res.render "team"
	app.get "/pastevents", (req, res) -> res.render "pastevents"

	app.get "/register", (req, res) -> 
		db.families.find().sort (last: 1), (err, families) ->
			count = families.length
			count += family.guests.length for family in families
			res.render "register", (families: families, count: count)

	app.get "/random-fact", (req, res) ->
		prev = if req.query.prev? then req.query.prev else -1
		prev = parseInt prev, 10
		(getItem = ->
			db.facts.findOne
				random: $near: [Math.random(), 0]
			, (err, data) ->
				if data.id is prev
					getItem()
					return
				res.json (fact: data.fact, id: data.id)
		)()


	# Registration List POST

	app.post "/facts", (req, res) ->

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
				fact = raw[0]
				db.facts.insert
					fact: fact
					random: [Math.random(), 0]
					id: i
				results.push "#{i} -> #{fact}"

			converter.on "end_parsed", (json) -> 
				numItems = json.csvRows.length
				db.facts.find (err, data) ->
					if numItems isnt data.length
						console.log results
						output 500, false, "A problem occurred and not all facts have been uploaded successfully. Please reload this page."
					else
						output 200, true, results

			db.facts.remove {}, -> converter.from path


	# Registration List POST

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
			counter = 0

			converter.on "end_parsed", (json) ->

				complete = ->
					db.families.find (err, data) ->
						numDatabase = data.length
						numDatabase += family.guests.length for family in data
						if numDatabase is json.csvRows.length
							output 200, true, results
						else
							console.log results
							output 500, false, "A problem occurred and not all names have been uploaded successfully. Please reload this page."

				for family, i in json.csvRows
					first = family.first
					last = family.last
					city = family.city
					state = family.state
					guestFirst = family.guestFirst
					guestLast = family.guestLast

					if guestFirst and guestLast
						# is a guest
						db.families.update
							first: guestFirst
							last: guestLast
						,
							$push:
								guests: first
							$setOnInsert:
								first: guestFirst
								last: guestLast
						,
							upsert: true
						, (err, docs) -> 
							complete() if ++counter is json.csvRows.length
						
						results.push "-> #{first} has been added as a guest of #{guestFirst} #{guestLast}"

					else
						# is a leader
						db.families.update
							first: first
							last: last
						,
							$set:
								city: city
								state: state
							$setOnInsert:
								first: first
								last: last
								guests: []
						,
							upsert: true
						, (err, docs) -> 
							complete() if ++counter is json.csvRows.length
						
						results.push "#{first} #{last} lives in #{city}, #{state}"

			db.families.remove {}, -> converter.from path


	# 404 Errors

	app.get "*", (req, res) -> res.status(404).render "404"
	app.post "*", (req, res) -> res.status(404).render "404"