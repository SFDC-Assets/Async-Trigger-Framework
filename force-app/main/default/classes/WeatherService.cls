// Weather call to OpenWeather API Version 2.5
public class WeatherService {

    public static String appId = '<enter API key here>';
    public static String url = 'https://api.openweathermap.org';
    public static String apiInfo = '/data/2.5/weather';
    public static String byZip = 'zip';
    public static String byCity = 'q';

    // WeatherService.getWeather('New York');

    public static WeatherResponse getWeather(String cityName) {

        String endpoint = url + apiInfo;
        String queryStr = byCity + '=' + cityName + '&APPID=' + appId;

        HttpRequest req = new HttpRequest();

        req.setEndpoint(endpoint + '?' + queryStr);
        req.setMethod('GET');

        Http http = new Http();
        HTTPResponse res = http.send(req);

        WeatherResponse wr = (WeatherResponse)JSON.deserialize(res.getBody(), WeatherResponse.class);

        System.debug('response');
        System.debug(wr);

        return wr;
    }
}
