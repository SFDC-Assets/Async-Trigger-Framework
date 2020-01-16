// Weather response from OpenWeather API Version 2.5
public class WeatherResponse {

    public CoordData coord;
    public List<WeatherData> weather;
    public String base;
    public MainData main;
    public Integer visibility;
    public WindData wind;
    public CloudsData clouds;
    public Long dt;
    public SysData sys;
    public String id;
    public String name;
    public String cod;

    public class CoordData {
        public Decimal lon;
        public Decimal lat;
    }
    public class WeatherData {
        public Integer id;
        public String main;
        public String description;
        public String icon;
    }
    public class MainData {
        public Decimal temp;
        public Integer pressure;
        public Integer humidity;
        public Decimal temp_min;
        public Decimal temp_max;
    }
    public class WindData {
        public Decimal speed;
        public Integer deg;
    }
    public class CloudsData {
        public Integer all;
    }
    public class SysData {
        public Integer type;
        public Integer id;
        public Decimal message;
        public String country;
        public Long sunrise;
        public Long sunset;
    }
}

/*
Example Response:
{
  "coord": {
    "lon": -0.13,
    "lat": 51.51
  },
  "weather": [
    {
      "id": 300,
      "main": "Drizzle",
      "description": "light intensity drizzle",
      "icon": "09d"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 280.32,
    "pressure": 1012,
    "humidity": 81,
    "temp_min": 279.15,
    "temp_max": 281.15
  },
  "visibility": 10000,
  "wind": {
    "speed": 4.1,
    "deg": 80
  },
  "clouds": {
    "all": 90
  },
  "dt": 1485789600,
  "sys": {
    "type": 1,
    "id": 5091,
    "message": 0.0103,
    "country": "GB",
    "sunrise": 1485762037,
    "sunset": 1485794875
  },
  "id": 2643743,
  "name": "London",
  "cod": 200
}
*/