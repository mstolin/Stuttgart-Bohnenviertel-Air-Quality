import datasources.DataSource as DataSource
from os import environ


class WorldAirQualityProject(DataSource):
    @property
    def _api_endpoint_url(self):
        return 'https://api.waqi.info/feed'

    @property
    def _api_url(self, lat, lng):
        token = environ.get('AQODP_API_TOKEN')
        if (token is None):
            raise TypeError

        return f'${self._api_endpoint_url}/geo:${lat};${lng}/?token=${token}'

    def request_metrics(self):
        pass
