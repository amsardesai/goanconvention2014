range = (min, max, val) ->  Math.max(min, Math.min(max, val))

delay = 200

$ ->

	if not Modernizr.touch
		mainEvent = $(".index .main .event").css(opacity: 0)
		header = $(".index header").css(opacity: 0)
		scrollDown = $(".index .main .scrolldown").css(opacity: 0)
		
		animated = false
		fadeInEverything = ->
			if not animated
				mainEvent.delay(delay).animate (opacity: 1), delay * 4
				header.delay(delay*2).animate (opacity: 0.95), delay * 3
				scrollDown.delay(delay*3).animate (opacity: 1), delay * 4
				animated = true

		$(window).load fadeInEverything
		setTimeout fadeInEverything, 2500

		mainMask = $(".index .main .mask").css("background-color": "black")
		(parallax = ->
			mainMask.css(opacity: range(0, 1, $(window).scrollTop() / $(window).height()))
		)()
		$(window).bind "scroll", parallax

	else
		$(".goa-blurred, .goa").addClass("mobile");
