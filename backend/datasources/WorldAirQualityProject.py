import datasources.DataSource as DataSource


class WorldAirQualityProject(DataSource):
    _API_KEY = ''
    _URL = 'https://api.waqi.info/feed/'  # geo:10.3;20.7/?token=

    def request_metrics(self):
        pass
