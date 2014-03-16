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
		parallaxElements = $(".parallax")
		(parallax = ->
			windowScrollTop = $(window).scrollTop()
			windowHeight = $(window).height()
			if windowScrollTop < windowHeight
				mainMask.css(opacity: windowScrollTop / windowHeight)
			parallaxElements.each (i) ->
				scrollMax = windowHeight + $(this).outerHeight()
				scrollTop = windowScrollTop + windowHeight - $(this).offset().top
				if scrollTop > 0 and scrollTop < scrollMax
					$(this).css("background-position": "center " + (scrollTop / scrollMax * 500 - 500) + "px")
		)()
		$(window).bind "scroll resize", parallax

	else
		$(".goa-blurred, .goa").addClass("mobile");


	reloadButton = $(".didyouknow a.reload")
	factText = $(".didyouknow p")

	(reloadFact = ->
		text = $(this).html()
		$(this).
			removeAttr("href").
			removeClass("link").
			html "Loading..."
		$.getJSON "/random-fact", (data, textStatus, jqXHR) ->
			fact = data.fact
			factText.html fact
			reloadButton.
				attr("href", "javascript:void()").
				addClass("link").
				html "Tell me something else"

	)()

	reloadButton.click (e) ->
		e.preventDefault()
		reloadFact()
















