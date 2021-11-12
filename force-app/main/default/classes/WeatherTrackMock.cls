@isTest
global class WeatherTrackMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse result = new HttpResponse();
        result.setHeader('Content-Type', 'application/json');
        result.setBody('{"main": {"temp": 282.55, "pressure": 1023, "humidity": 100}, "weather": [{"id": 800, "main": "Clear", "description": "clear sky"}]}');
        result.setStatusCode(200);
        return result;
    }
}
