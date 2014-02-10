parallaxSkylineFactor = 0.5;

$ ->
	main = $(".main")
	if not Modernizr.touch then $(window).bind "scroll", ->
		main.css("background-position-y", Math.max($(window).scrollTop() * parallaxSkylineFactor, 0))
