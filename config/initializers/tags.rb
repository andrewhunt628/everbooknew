# Be sure to restart your server when you modify this file.

# This file contains settings for ActionController::ParamsWrapper which
# is enabled by default.

# Enable parameter wrapping for JSON. You can disable this by setting :format to an empty array.
ActsAsTaggableOn.delimiter = ['#', ' ']

# To enable root element in JSON for ActiveRecord objects.
# ActiveSupport.on_load(:active_record) do
#  self.include_root_in_json = true
# end

ActsAsTaggableOn::Tag.class_eval do

  scope :alphabetical, -> { order :name }

end
