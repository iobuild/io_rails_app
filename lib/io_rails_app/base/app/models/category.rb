class Category < ActiveRecord::Base
  acts_as_nested_set

  # scope :read_root, -> { where(:name => 'read').first }

end