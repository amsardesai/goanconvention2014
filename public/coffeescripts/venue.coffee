$(window).load ->

	# Viewport
	viewport = null
	(reloadViewport = ->
		viewport =
			width: $(window).width()
			height: $(window).height()
	)()
	$(window).resize reloadViewport

	# Set Styles
	styleArray = [
		featureType: "poi"
		stylers: [ visibility: "off" ]
	]

	# Set Initial Latitude
	lat = if viewport.width < 680 then -80.21014 else -80.26

	# Set Options
	mapOptions =
		center: new google.maps.LatLng 40.50215, lat
		zoom: 12
		panControl: !Modernizr.touch
		panControlOptions:
			position: google.maps.ControlPosition.RIGHT_TOP
		zoomControl: true
		zoomControlOptions:
			position: google.maps.ControlPosition.RIGHT_TOP
		mapTypeControl: false
		scaleControl: false
		streetViewControl: true
		streetViewControlOptions:
			position: google.maps.ControlPosition.RIGHT_TOP
		rotateControl: false
		overviewMapControl: false

	# Set Options
	map = new google.maps.Map $("#map").get(0), mapOptions
	map.setOptions (styles: styleArray)

	# Add Marker
	google.maps.event.addListenerOnce map, 'idle', ->
		marker = new google.maps.Marker
			position: new google.maps.LatLng 40.50215, -80.21014
			map: map
			animation: google.maps.Animation.DROP
			title: "Sheraton Pittsburgh Airport Hotel"

	# Add Listener for Street View
	panorama = map.getStreetView()
	google.maps.event.addListener panorama, 'visible_changed', ->
		if panorama.getVisible()
			$(".venue section.container").addClass "hide"
		else
			$(".venue section.container").removeClass "hide"
