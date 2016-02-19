module AlbumsHelper
  def display_album_pins(album)
    iteration = 0
    result = ''.html_safe
    limit  = get_limit_for_album(album)
    while (iteration < limit) do
      pin     = album.pins_for_displaying[iteration]
      result += link_to pin, 'data-toggle' => "modal", 'data-target'=>"#pin#{pin.id}" do 
                  content_tag :div, style: "background-image: url('#{pin.image.url(:thumb)}');", class: 'icon' do
                  end
                end
      iteration += 1
    end
    result
  end

  def display_modal_windows_for_album_pins(album)
    result    = ''.html_safe
    limit     = get_limit_for_album(album)
    iteration = 0
    album.pins_for_displaying.each do |pin|
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

end
