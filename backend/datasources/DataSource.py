from abc import ABC, abstractmethod


class DataSource(ABC):
    @abstractmethod
    def request_metrics(self, lat, lng):
        pass