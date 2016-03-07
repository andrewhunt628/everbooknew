# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
# securing paramater :api_key
Rails.application.config.filter_parameters += [:password, :api_key]
