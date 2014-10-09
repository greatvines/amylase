module ApplicationHelper

  def conditional_emphasis(condition, tag_true: :strong, tag_false: :null, options: {}, &block)
    if condition
      content_tag(tag_true, capture(&block), options)
    else
      content_tag(tag_false, capture(&block), options)
    end
  end

end
