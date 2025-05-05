async function handler(event) {
    var request = event.request;
    var host = request.headers.host.value;
    var uri = request.uri;

  
    if (host === 'cesargoncalves.com') {
        return {
            statusCode: 301,
            statusDescription: 'Moved Permanently',
            headers: {
                "location": {
                    "value": 'https://www.cesargoncalves.com/index.html'
                }
            }
        };
    }

    if (host === 'www.cesargoncalves.com' && uri === '/') {
        request.uri = '/index.html';
    }

    return request;
}
