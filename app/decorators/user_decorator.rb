class UserDecorator < Draper::Decorator
  delegate_all


  def full_name
    first_name = source.first_name || ''
    last_name = source.last_name || ''

    return source.email if (first_name && last_name).blank?

   [first_name, last_name].map(&:capitalize).join ' '
  end
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end


  def address
    if (source.location == 'Reserved') || (source.location.nil?)
      return nil
    else
      source.location
    end
  end

end
