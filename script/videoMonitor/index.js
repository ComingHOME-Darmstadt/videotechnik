const config = {
	caspar: {
		host: "127.0.0.1",
		port: 5250
	},
	source: {
		channel: 18,
		layer: 10
	},
	output: {
		channel: 19
	}
};

const { CasparCG, ConnectionOptions } = require('casparcg-connection');

function logCasparCgConnection(isConnected) {
	if (isConnected) {
		console.log('per AMCP zu CasparCG ' + config.caspar.host + ':' + config.caspar.port + ' verbunden');
	}
	else {
		console.log('AMCP zu CasparCG ' + config.caspar.host + ':' + config.caspar.port + ' gescheitert');
	}
}

const connectionOptions = new ConnectionOptions({
	debug: false,
	host: config.caspar.host,
	port: config.caspar.port,
	autoReconnect: true,
	autoReconnectInterval: 1000,
	onConnectionChanged: logCasparCgConnection,
	onError: function(error) {
		console.error(error);
	},
	onConnected: run
});
const connection = new CasparCG(connectionOptions);

function run(isConnected) {
	launchOverlay();
	pollStatus();
}

function launchOverlay() {
	connection.clear(config.output.channel).catch(() => {
		console.error("Failed to clear output channel")
	});
	connection.cgAdd(config.output.channel, 100, 0, "videoMonitor", true).catch(() => {
		console.error("Failed to load template")
	});
	connection.play(config.output.channel, 90, "route://"+config.source.channel+"-"+config.source.layer).catch(() => {
		console.error("Failed to play output route")
	});
}

function pollStatus() {
	connection.info(config.source.channel, config.source.layer).then(evaluate);
}

const currentState = {
	elapsed: null,
	remaining: null,
	name: null,
	filler: String('+-----')
};

function evaluate(infodata) {
	const data = infodata.response.data;
	var foreground;
	var file;
	if (data.stage && data.stage.layer && data.stage.layer['layer_'+config.source.layer]) {
		foreground = data.stage.layer['layer_'+config.source.layer].foreground;
		file = foreground.file;

		if (fileDataExists(file)) {
			calculateCurrentStateName(file.path);
			calculateCurrentStateTimes(file.time[0], file.time[1]);
		}
		else {
			clearState();
		}

		sendState();
	}

	if (foreground && !foreground.paused && fileDataExists(file)) {
		const lastChar = currentState.filler.substr(-1);
		const withoutLastChar = currentState.filler.substr(0, currentState.filler.length - 1)
		currentState.filler = lastChar + withoutLastChar;

		setTimeout(pollStatus, 200);
	}
	else {
		setTimeout(pollStatus, 2000);
	}
}

function fileDataExists(file) {
	return file && file.time && file.time[0] !== null && file.time[1] !== null;
}

function calculateCurrentStateName(name) {
	const suffixPos = name.lastIndexOf('.');
	const pureName = name.slice(0, suffixPos - name.length);
	currentState.name = pureName.substring(pureName.length-40);
}

function calculateCurrentStateTimes(current, total) {
	currentState.elapsed = formatTimecode(current);
	currentState.remaining = formatTimecode(total - current);
}

function formatTimecode(time) {
	const seconds = Math.floor(time);
	const minutes = Math.floor(seconds / 60)

	const millisecondsString = String(Math.floor((time - seconds) * 1000));
	const secondsString = String(seconds % 60);
	const minutesString = String(minutes % 60);

	return minutesString.padStart(2, '0') + ':' + secondsString.padStart(2, '0') + '.' + millisecondsString.padStart(3, '0');
}

function sendState() {
	if (currentState.name && currentState.elapsed && currentState.remaining) {
		connection.cgInvoke(config.output.channel, 100, 0, "\"setTopTextTime('" + currentState.elapsed + ' ' + currentState.filler + ' ' + currentState.remaining + "')\"");
		connection.cgInvoke(config.output.channel, 100, 0, "\"setTopTextName('" + currentState.name + "')\"");
	}
	else {
		connection.cgInvoke(config.output.channel, 100, 0, "\"setTopTextTime('')\"");
		connection.cgInvoke(config.output.channel, 100, 0, "\"setTopTextName('kein Video geladen')\"");
	}
}

function clearState(){
	currentState.elapsed = null;
	currentState.remaining = null;
	currentState.name = null;
}
