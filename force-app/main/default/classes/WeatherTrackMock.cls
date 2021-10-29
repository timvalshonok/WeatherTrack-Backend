@isTest
global class WeatherTrackMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"main": {"temp": 282.55, "pressure": 1023, "humidity": 100}, "weather": [{"id": 800, "main": "Clear", "description": "clear sky"}]}');
        res.setStatusCode(200);
        return res;
    }
}
