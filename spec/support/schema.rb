require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => ':memory:'
)

ActiveRecord::Schema.define do
  create_table :photos, force: true do |t|
    t.string :title
    t.string :uuid
    t.timestamps
  end
end

class Photo < ActiveRecord::Base
  include ImageSystem::Image

  attr_accessor :path
end
