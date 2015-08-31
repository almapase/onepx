class Image < ActiveRecord::Base
  enum category: %w(portrait landscape city\ exploration nature animals)

  def tags_text
    self.tags.join(', ')
  end

  def tags_text=(value)
    self.tags = value.split(',').map{ |tag| tag.strip}
  end
end
