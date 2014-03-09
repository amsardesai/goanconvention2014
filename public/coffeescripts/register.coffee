delay = 200
alphabet = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']


$ ->

	weCanAnimate = not Modernizr.touch and $(window).width() > 680
	
	registrants = $(".registrants")

	if weCanAnimate
		registrants.find(".family").css(opacity: 0).each (i) ->
			offset = 70
			scanSpeed = 10
			layingSpeed = 2

			$(this).delay(delay*i/scanSpeed).waypoint
				handler: (dir) ->
					$(this).animate (opacity: 1), delay * layingSpeed
				offset: "95%"
				triggerOnce: true