delay = 200
alphabet = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']


$ ->

	weCanAnimate = not Modernizr.touch and $(window).width() > 680
	
	registrants = $(".registrants")

	$.getJSON "/registration-list", (data, textStatus, jqXHR) ->

		for row in data
			family = $("<div>").addClass "family"
			city = $("<div>").addClass("city").text row.city + ", " + row.state
			lastname = $("<div>").addClass("lastname").text row.last

			guestList = " &mdash; " + row.first
			for guest in row.guests
				guestList += ", " + guest
			guests = $("<div>").addClass("guests").html guestList

			family.append lastname, city, guests
			if weCanAnimate then family.css(opacity: 0)
			registrants.append family

		if weCanAnimate
			registrants.find(".family").each (i) ->
				offset = 70
				scanSpeed = 10
				layingSpeed = 2

				$(this).delay(delay*i/scanSpeed).waypoint
					handler: (dir) ->
						$(this).animate (opacity: 1), delay * layingSpeed
					offset: "95%"
					triggerOnce: true



			