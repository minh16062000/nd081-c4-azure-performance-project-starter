import logging
from applicationinsights import TelemetryClient
from applicationinsights.logging import AzureLogHandler

# Khởi tạo logger
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

# Thêm AzureLogHandler với connection string
connection_string = 'InstrumentationKey=885d5304-c58b-4c72-adc3-05b6f2e530a4;IngestionEndpoint=https://southcentralus-3.in.applicationinsights.azure.com/;LiveEndpoint=https://southcentralus.livediagnostics.monitor.azure.com/;ApplicationId=bec6892d-8028-4289-add5-991a31e09660'
logger.addHandler(AzureLogHandler(connection_string=connection_string))

# Gửi một số thông điệp log
logger.info('This is an info message')
logger.warning('This is a warning message')
logger.error('This is an error message')

print("Logs have been sent to Azure Application Insights.")
