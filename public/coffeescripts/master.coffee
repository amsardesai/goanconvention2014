range = (min, max, val) ->  Math.max(min, Math.min(max, val))


parallaxSkylineFactor = 0.75;
parallaxSkylineMaskFactor = 1 / 550;

$ ->
	main = $(".main")
	mainMask = $(".main .mask")
	if not Modernizr.touch then $(window).bind "scroll", ->
		main.css("background-position-y", Math.max($(window).scrollTop() * parallaxSkylineFactor, 0))
		mainMask.css("opacity", range(0, 1, $(window).scrollTop() * parallaxSkylineMaskFactor))
