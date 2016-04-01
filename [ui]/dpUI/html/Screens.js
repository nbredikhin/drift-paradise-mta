Screens = {}
var templates = {}
var languageStrings = {}

Screens.passLocales = function (data) {
	if (data) {
		languageStrings = JSON.parse(data)[0];	
	}
}

Screens.unload = function () {
	$("#screen_container").html("");
}

Screens.load = function (name, data) {
	if (data) {
		data = JSON.parse(data)[0];
	} else {
		data = {};
	}

	data.lang = languageStrings;
	if (templates[name] === undefined) {
		$.ajax({
			url: "screens/" + name + "/index.html",
			success: function (html) {
				templates[name] = Handlebars.compile(html);
				$("#screen_container").html(templates[name](data));
			},
			async: true
		});
	} else {
		$("#screen_container").html(templates[name](data));
	}
}