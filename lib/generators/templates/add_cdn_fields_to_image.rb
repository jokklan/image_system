class AddCdnFieldsToImage < ActiveRecord::Migration
  def change
    change_table(:<%= class_name.pluralize %>) do |t|
      t.string  :uuid
      t.integer :width  # width in px
      t.integer :height # height in px
    end

    add_index :<%= class_name.pluralize %>, :uuid, :unique => true

  end

end
