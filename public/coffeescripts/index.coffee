range = (min, max, val) ->  Math.max(min, Math.min(max, val))

delay = 200

$ ->

	# Initial Animations & Parallax

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
			windowWidth = $(window).width()
			windowHeight = $(window).height()
			windowScrollTop = $(window).scrollTop()
			if windowScrollTop < windowHeight
				mainMask.css(opacity: windowScrollTop / windowHeight)
			parallaxElements.each (i) ->
				scrollMax = windowHeight + $(this).outerHeight()
				scrollTop = windowScrollTop + windowHeight - $(this).offset().top
				if scrollTop > 0 and scrollTop < scrollMax
					factor = if windowWidth > 680 then 450 else 220
					$(this).css("background-position": "center " + (scrollTop / scrollMax * factor - factor) + "px")
		)()
		$(window).bind "scroll resize", parallax


	# Reload Facts Button

	reloadButton = $(".didyouknow a.reload")
	factText = $(".didyouknow p")

	(reloadFact = (curFact) ->
		text = reloadButton.html()
		reloadButton.
			removeAttr("href").
			removeClass("link").
			html "Loading..."
		$.getJSON "/random-fact", (prev: curFact), (data, textStatus, jqXHR) ->
			fact = data.fact
			factText.data("fact", data.id).html fact
			reloadButton.
				attr("href", "javascript:void()").
				addClass("link").
				html "Tell me something else"

	)(-1)


	# Event Tracking

	reloadButton.click (e) ->
		e.preventDefault()
		try _gaq.push ["_trackEvent", "Main Page Events", "Click - Reload Facts"] catch
		reloadFact factText.data("fact")

	$("section.where").waypoint
		handler: ->
			try _gaq.push ["_trackEvent", "Main Page Events", "Scroll - Below Main Section"] catch
		offset: "99%"
		triggerOnce: true

	$("footer").waypoint
		handler: ->
			try _gaq.push ["_trackEvent", "Main Page Events", "Scroll - Bottom Of Page"] catch
		offset: "100%"
		triggerOnce: true



