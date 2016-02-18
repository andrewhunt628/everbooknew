module AlbumsHelper
  def display_album_pins(album)
    pins = album.pins_for_displaying
    iteration = 0
    result = ''.html_safe
    limit = (pins.count / 3).to_i >= 2 ? 6 : 3
    while (iteration < limit && iteration < pins.count) do
      result += link_to album, 'data-toggle' => "modal", 'data-target'=>"#pinModal" do 
                  content_tag :div, style: "background-image: url('#{pins[iteration].image.url(:thumb)}');", class: 'icon' do
                  end
                end
      iteration += 1
    end
    result

  end
end
