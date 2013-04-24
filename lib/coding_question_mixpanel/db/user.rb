class User
  include DataMapper::Resource
  property :id, Serial
  property :email, String
  property :bounce_count, Integer, :default => 0
  property :last_bounce, DateTime
end
