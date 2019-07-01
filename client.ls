if Meteor.isClient

	@m = require \mithril
	@ml5 = require \ml5
	@state = {}

	view = -> m.mount document.body, view: -> m \.content,
		m \.file, m \label.file-label,
			m \input.file-input, type: \file, name: \img, onchange: (e) ->
				reader = new FileReader!
				reader.onloadend = ->
					state.image = reader.result
					m.redraw!
				reader.readAsDataURL e.target.files.0
			m \span.file-cta,
				m \span.file-icon, m \i.fa.fa-upload
				m \span.file-label, 'Select Image'
		if state.image
			m \img#img, src: that, oncreate: ->
				eye.predict document.getElementById(\img), (err, res) -> if res
					state.result = res
					m.redraw!
		if state.result then m \table.table,
			m \thead, m \tr,
				m \th, \Confidence
				m \th, \Keywords
			m \tbody, that.map (i) -> m \tr,
				m \td, i.confidence
				m \td, i.label
		m \h5, 'Thanks ML5'
	@eye = ml5.imageClassifier \MobileNet, view
