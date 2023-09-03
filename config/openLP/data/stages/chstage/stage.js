window.OpenLP = { // Connect to the OpenLP Remote WebSocket to get pushed updates
	myTwelve: null,
	emptyTextMarker: '[LEER]',

	myWebSocket: function (data, status) {
		const host = window.location.hostname;
		const websocket_port = 4317;

		ws = new WebSocket(`ws://${host}:${websocket_port}`);
		ws.onmessage = (event) => {
			const reader = new FileReader();
			reader.onload = () => {
				data = JSON.parse(reader.result.toString()).results;
				// set some global var
				OpenLP.myTwelve = data.twelve;
				if (OpenLP.currentItem != data.item ||
						OpenLP.currentService != data.service) {
					OpenLP.currentItem = data.item;
					OpenLP.currentService = data.service;
					OpenLP.loadSlides();
				}
				else if (OpenLP.currentSlide != data.slide) {
					OpenLP.currentSlide = parseInt(data.slide, 10);
					OpenLP.updateSlide();
				}
				OpenLP.loadService();
			};
			reader.readAsText(event.data);
		};
		ws.onclose = (event) => {
			console.log('Socket is closed. Reconnect will be attempted in 1 second.', event.reason);
			setTimeout(() => {
				OpenLP.myWebSocket();
			}, 1000);
		};
		ws.onerror = (err) => {
			console.error('Socket encountered error: ', err.message, 'Closing socket');
			ws.close();
		};
	},

	loadService: function (event) {
		try {
			$.getJSON(
				"/api/v2/service/items",
				function (data, status) {
					OpenLP.nextSong = "";
					$("#notes").html("");
					data.forEach(function(item, index, array) {
						//if (data.length > index + 1) {
								//console.log("next title");
								//console.log(data[index + 1].title);
						//};
						if (item.selected) {
							//console.log("notes");
							//console.log(item.notes)
							var notes = item.notes.replace(/\n/g, "<br />");
							$("#notes").html(notes);
							if (data.length > index + 1) {
								OpenLP.nextSong = data[index + 1].title;
							}
							else {
									OpenLP.nextSong = "End of Service";
							}
						}
					});
					OpenLP.updateSlide();
				}
			);
		}
		catch (error) {
			console.error(error);
		}
	},

	loadSlides: function (event) {
		try {
			$.getJSON(
				"/api/v2/controller/live-items",
				function (data, status) {
					OpenLP.currentSlides = data.slides;
					OpenLP.currentSlide = 0;
					OpenLP.currentTags = Array();
					var div = $("#verseorder");
					div.html("");
					var tag = "";
					var tags = 0;
					var lastChange = 0;
					$.each(data.slides, function(idx, slide) {
						var prevtag = tag;
						tag = slide["tag"];
						if (tag != prevtag) {
							// If the tag has changed, add new one to the list
							lastChange = idx;
							tags = tags + 1;
							div.append("&nbsp;<span>");
							$("#verseorder span").last().attr("id", "tag" + tags).text(tag);
						}
						else {
							if ((slide["text"] == data.slides[lastChange]["text"]) &&
								(data.slides.length >= idx + (idx - lastChange))) {
								// If the tag hasn't changed, check to see if the same verse
								// has been repeated consecutively. Note the verse may have been
								// split over several slides, so search through. If so, repeat the tag.
								var match = true;
								for (var idx2 = 0; idx2 < idx - lastChange; idx2++) {
									if(data.slides[lastChange + idx2]["text"] != data.slides[idx + idx2]["text"]) {
											match = false;
											break;
									}
								}
								if (match) {
									lastChange = idx;
									tags = tags + 1;
									div.append("&nbsp;<span>");
									$("#verseorder span").last().attr("id", "tag" + tags).text(tag);
								}
							}
						}
						OpenLP.currentTags[idx] = tags;
						if (slide["selected"])
							OpenLP.currentSlide = idx;
					})
					OpenLP.loadService();
				}
			);
		}
		catch (error) {
			console.error(error);
		}
	},

	updateSlide: function() {
		var text = "";
		try {
			// Show the current slide on top. Any trailing slides for the same verse
			// are shown too underneath in grey.
			// Then leave a blank line between following verses
			$("#verseorder span").removeClass("currenttag");
			$("#tag" + OpenLP.currentTags[OpenLP.currentSlide]).addClass("currenttag");
			var slide = OpenLP.currentSlides[OpenLP.currentSlide];
			if (!slide['img']) { // nur Text, keine Bildreferenzen anzeigen
				if (slide["text"]) {
					text = slide["text"];
				} else {
					text = OpenLP.emptyTextMarker;
				}
			}
			// use thumbnail if available
			//if (slide["img"]) {
			//    text += "<br /><img src='" + slide["img"].replace("//thumbnails//", "//thumbnails//") + "'><br />";
			//}
			// use notes if available
			if (slide["slide_notes"]) {
					text += '<br />' + slide["footer"];
			}
			// "slide_notes"
			text = text.replace(/\n/g, "<br />");
		}
		catch (error) {
			console.error(error);
		}
		$("#currentslide").html(text);

		text = "";
		try {
			if (OpenLP.currentSlide < OpenLP.currentSlides.length - 1) {
				for (var idx = OpenLP.currentSlide + 1; idx < OpenLP.currentSlides.length; idx++) {
					if (OpenLP.currentTags[idx] != OpenLP.currentTags[idx - 1]) {
						text = text + "<p class=\"nextslide\">";
					}
					if (OpenLP.currentSlides[idx]["text"]) {
						text = text + OpenLP.currentSlides[idx]["text"];
					}
					else {
						text = text + OpenLP.emptyTextMarker;
					}
					if (OpenLP.currentTags[idx] != OpenLP.currentTags[idx - 1]) {
						text = text + "</p>";
					}
					else {
						text = text + "<br />";
					}
				}
				text = text.replace(/\n/g, "<br />");
				$("#nextslide").html(text);
			}
			else {
				text = "<p class=\"nextslide\">" + $("#next-text").val() + ": " + OpenLP.nextSong + "</p>";
				$("#nextslide").html(text);
			}
		}
		catch (error) {
			console.error(error);
		}
	},

	updateClock: function(data) {  // get time from results
		var div = $("#clock");
		var t = new Date();
		var h = t.getHours();
		if (OpenLP.myTwelve && h > 12) {
			h = h - 12;
		}
		var m = t.getMinutes();
		if (m < 10) {
			m = '0' + m + '';
		}
		div.html(h + ":" + m);
	},
}
$.ajaxSetup({ cache: false });
setInterval("OpenLP.updateClock();", 500);
OpenLP.myWebSocket();