from abc import ABC


class DataSource(ABC):
    @abstractmethod
    def request_metrics(self):
        pass