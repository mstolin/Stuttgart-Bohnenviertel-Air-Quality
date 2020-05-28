from requests_futures.sessions import FuturesSession
from datasources.DataSource import DataSource
from os import environ


class WorldAirQualityProject(DataSource):
    def __init__(self):
        self._api_endpoint_url = 'https://api.waqi.info/feed'

    def _get_api_url(self, lat, lng):
        token = environ.get('AQODP_API_TOKEN')
        if (token is None):
            raise TypeError

        return f'{self._api_endpoint_url}/geo:{lat};{lng}/?token={token}'

    def _map_json_response(self, response):
        result = {'metrics': {}, 'last_update': {}}

        quality_data = response['data']['iaqi']
        result['metrics'] = self._map_metrics(quality_data)

        time_data = response['data']['time']
        result['last_update'] = self._map_last_update(time_data)

        return result

    def _map_metrics(self, data):
        metrics = {}
        if ('pm10' in data):
            metrics['pm10'] = data['pm10'].get('v', 0.0)
        if ('o3' in data):
            metrics['o3'] = data['o3'].get('v', 0.0)
        if ('no2' in data):
            metrics['no2'] = data['no2'].get('v', 0.0)
        if ('t' in data):
            metrics['temperature'] = data['t'].get('v', 0.0)

        return metrics

    def _map_last_update(self, data):
        last_update = {}
        last_update['date'] = data.get('s', '')
        last_update['timezone'] = data.get('tz', '')
        return last_update

    def request_metrics(self, lat, lng):
        session = FuturesSession()
        api_future = session.get(self._get_api_url(lat, lng))
        api_json_response = api_future.result().json()

        return self._map_json_response(api_json_response)
