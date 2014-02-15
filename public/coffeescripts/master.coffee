range = (min, max, val) ->  Math.max(min, Math.min(max, val))

delay = 200

goaBeachColor = "#E9CEB3"

$ ->

	$("header, .main .event").css(opacity: 0).delay(delay).animate (opacity: 1), delay * 4
	$(".main .scrolldown").css(opacity: 0).delay(delay * 6).animate (opacity: 1), delay * 3

	# Parallax for main

	if not Modernizr.touch
		mainMask = $(".main .mask").css("background-color": "black", opacity: 0)
		(parallax = ->
			scrollTip = 
			mainMask.css(opacity: range(0, 1, $(window).scrollTop() / $(window).height()))
		)()
		$(window).bind "scroll", parallax

	else
		$(".goa-blurred").css("background-color": goaBeachColor, "background-image": "none")
