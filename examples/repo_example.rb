require 'aas'

class Post
  include Aas::Model
  attr_accessor :title, :text
end

class PostRepo
  include Aas::Repo
end
