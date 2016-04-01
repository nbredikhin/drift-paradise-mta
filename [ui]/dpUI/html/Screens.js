Screens = {}
var templates = {}

Screens.load = function (name, data) {
	if (data) {
		data = JSON.parse(data)[0];
	}
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