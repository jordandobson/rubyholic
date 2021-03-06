class Post < ActiveRecord::Base
  has_many :comments, :dependent => :destroy
  has_many :tags, :dependent => :destroy
  
  define_index do
    indexes subject
    indexes content
    indexes tags.text, :as => :tags
    indexes comments.content, :as => :comments

    has comments(:id), :as => :comment_ids, :source => :ranged_query
  end
end