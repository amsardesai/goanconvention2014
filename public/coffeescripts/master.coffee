range = (min, max, val) ->  Math.max(min, Math.min(max, val))

parallaxSkylineFactor = 0.75;
parallaxSkylineMaskFactor = 1 / 700;

delay = 200

$ ->

	$("header").hide().delay(delay*2).fadeIn(delay*3)

	# Parallax for main

	main = $(".main")
	if not Modernizr.touch
		mainMask = $(".main .mask").css("background-color": "black", opacity: 0)
		(parallax = ->
			scrollTop = $(window).scrollTop()
			main.css("background-position-y": Math.max(scrollTop * parallaxSkylineFactor, 0))
			mainMask.css(opacity: range(0, 1, scrollTop * parallaxSkylineMaskFactor))
		)()
		$(window).bind "scroll", parallax
