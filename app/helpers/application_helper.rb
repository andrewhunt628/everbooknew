module ApplicationHelper
  def get_mark_tag_url(tag)
    tags = tags_list.push(tag.name).uniq
    tag_path(tags)
  end

  def get_unmark_tag_url(tag)
    tags = tags_list - [tag.name]
    if tags.length > 0
      tag_path(tags)
    else
      root_path
    end
  end
end
