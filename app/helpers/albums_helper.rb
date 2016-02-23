module AlbumsHelper
  def display_album_pins(album)
    iteration = 0
    result = ''.html_safe
    limit  = get_limit_for_album(album)
    while (iteration < limit) do
      pin     = album.pins_for_displaying[iteration]
      iteration += 1
      result += content_tag :div, class: 'icon' do
                  if iteration == limit && get_remaining_pins_quantity(album) > 0
                    link_to album, style: "background-image: url('#{pin.image.url(:thumb)}');" do
                      content_tag :div, class: 'album-counter' do
                        counter = content_tag :h4, get_remaining_pins_quantity(album)
                        counter += content_tag :h5, 'more'
                      end
                    end
                  else
                    link_to pin, style: "background-image: url('#{pin.image.url(:thumb)}');", 'data-toggle' => "modal", 'data-target'=>"#pin#{pin.id}" do
                    end
                  end
                end
    end
    result
  end

  def display_modal_windows_for_album_pins(album)
    result    = ''.html_safe
    limit     = get_limit_for_album(album)
    iteration = 0
    album.pins.each do |pin|
      result += content_tag :div, class: 'modal fade', id: "pin#{pin.id}", "aria-labelledby" => "signUpModalLabel", :role => "dialog", :tabindex => "-1" do
        content_tag :div, class: 'modal-dialog modal-lg' do
          content_tag :div, '', class: 'modal-content'
        end
      end
      iteration += 1
    end
    result
  end

  private
    def get_limit_for_album(album)
      limit = (album.pins_for_displaying.count / 3).to_i >= 2 ? 6 : 3
      [limit, album.pins_for_displaying.count].min
    end

    def get_remaining_pins_quantity(album)
      pins_count = album.pins_for_displaying.count
      if pins_count > 6
        pins_count - 6
      elsif pins_count > 3 && pins_count < 6
        pins_count - 3
      else
        0
      end

    end
end
