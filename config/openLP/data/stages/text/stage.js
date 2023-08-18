window.OpenLP = { // Connect to the OpenLP Remote WebSocket to get pushed updates
  myWebSocket: function (data, status) {
    const host = window.location.hostname;
    const websocket_port = 4317;

    ws = new WebSocket(`ws://${host}:${websocket_port}`);
    ws.onmessage = (event) => {
      const reader = new FileReader();
      reader.onload = () => {
        data = JSON.parse(reader.result.toString()).results;
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
					data.forEach(function(item, index, array) {
						//if (data.length > index + 1) {
								//console.log("next title");
								//console.log(data[index + 1].title);
						//};
						if (item.selected) {
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
		var text = '';
		try {
			var slide = OpenLP.currentSlides[OpenLP.currentSlide];
			if (!slide['img']) { // nur Text, keine Bildreferenzen anzeigen
				text = slide["text"];
			}
			// "slide_notes"
			text = text.replace(/\n/g, "<br />");
		}
		catch (error) {
			console.error(error);
		}
    $("#currentslide").html(text);
  },
}
$.ajaxSetup({ cache: false });
OpenLP.myWebSocket();