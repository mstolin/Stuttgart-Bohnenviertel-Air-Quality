# Backend

## Getting started

### Create an API key

1. Go to https://aqicn.org/api/ to create an API key
2. Create a `.env` file
3. Add `AQODP_API_TOKEN=<PUT_YOUR_TOKEN_HERE>` to your `.env` file

### Start the service

```
$ pipenv install # if neccessary
$ pipenv run python3 main.py
```

### Example request

#### Command

```
$ curl http://127.0.0.1:1337/airquality?lat=48.7746335&lng=9.1815713
```

#### Output

```
{
    "metrics": {
        "pm10": 8,
        "o3": 33.8,
        "no2": 1.4,
        "temperature": 18.5
    },
    "last_update": {
        "date": "2020-05-31 12:00:00",
        "timezone": "+02:00"
    }
}
```
