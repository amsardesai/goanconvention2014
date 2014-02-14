range = (min, max, val) ->  Math.max(min, Math.min(max, val))


delay = 200

$ ->

	$("header").hide().delay(delay*2).fadeIn(delay*3)

	# Parallax for main

	main = $(".main")
	if not Modernizr.touch
		mainMask = $(".main .mask").css("background-color": "black", opacity: 0)
		(parallax = ->
			mainMask.css(opacity: range(0, 1, $(window).scrollTop() / $(window).height())
		)()
		$(window).bind "scroll", parallax
