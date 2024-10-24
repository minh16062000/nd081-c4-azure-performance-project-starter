import logging
from applicationinsights import TelemetryClient
from applicationinsights.logging import AzureLogHandler

# Khởi tạo logger
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

# Thêm AzureLogHandler với connection string
connection_string = 'InstrumentationKey=bc78d1dd-d45c-4c43-bedc-8b9edf698946;IngestionEndpoint=https://eastasia-0.in.applicationinsights.azure.com/;LiveEndpoint=https://eastasia.livediagnostics.monitor.azure.com/;ApplicationId=30425753-d629-4c36-8bfe-55816ecd5ca3'
logger.addHandler(AzureLogHandler(connection_string=connection_string))

# Gửi một số thông điệp log
logger.info('This is an info message')
logger.warning('This is a warning message')
logger.error('This is an error message')

print("Logs have been sent to Azure Application Insights.")
