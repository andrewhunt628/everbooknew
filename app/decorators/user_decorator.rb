class UserDecorator < Draper::Decorator
  delegate_all

  def full_name
    first_name = source.first_name || ''
    last_name = source.last_name || ''

    return source.email if (first_name && last_name).blank?

    [first_name, last_name].map(&:capitalize).join ' '
  end
end
