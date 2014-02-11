range = (min, max, val) ->  Math.max(min, Math.min(max, val))


parallaxSkylineFactor = 0.75;
parallaxSkylineMaskFactor = 1 / 700;

delay = 200

$ ->
	main = $(".main")
	mainMask = $(".main .mask")

	if not Modernizr.touch then $(window).bind "scroll", ->
		scrollTop = $(window).scrollTop()
		main.css("background-position-y", Math.max(scrollTop * parallaxSkylineFactor, 0))
		mainMask.css("opacity", range(0, 1, scrollTop * parallaxSkylineMaskFactor))
