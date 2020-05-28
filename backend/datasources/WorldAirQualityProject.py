import requests
from datasources.DataSource import DataSource
from os import environ


class WorldAirQualityProject(DataSource):
    @property
    def _api_endpoint_url(self):
        return 'https://api.waqi.info/feed'

    def _get_api_url(self, lat, lng):
        token = environ.get('AQODP_API_TOKEN')
        if (token is None):
            raise TypeError

        return f'{self._api_endpoint_url}/geo:{lat};{lng}/?token={token}'

    def request_metrics(self, lat, lng):
        response = requests.get(self._get_api_url(lat, lng))
        json_response = response.json()
        return json_response['data']['iaqi']
