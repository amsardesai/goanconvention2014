range = (min, max, val) ->  Math.max(min, Math.min(max, val))

delay = 200

$ ->

	if not Modernizr.touch
		$(".index .main .event").css(opacity: 0).delay(delay).animate (opacity: 1), delay * 2
		$(".index header").css(opacity: 0).delay(delay*3).animate (opacity: 1), delay * 2
		$(".index .main .scrolldown").css(opacity: 0).delay(delay * 5).animate (opacity: 1), delay * 2

		mainMask = $(".main .mask").css("background-color": "black", opacity: 0)
		(parallax = ->
			scrollTip = 
			mainMask.css(opacity: range(0, 1, $(window).scrollTop() / $(window).height()))
		)()
		$(window).bind "scroll", parallax

	else
		$(".goa-blurred, .goa").addClass("mobile");
