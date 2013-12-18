class AddCdnFieldsTo<%= class_name.slice(0,1).capitalize + class_name.pluralize.slice(1..-1) %> < ActiveRecord::Migration
  def change
    change_table(:<%= class_name.pluralize.downcase %>) do |t|
      t.string  :uuid
      t.integer :width  # width in px
      t.integer :height # height in px
    end

    add_index :<%= class_name.pluralize.downcase %>, :uuid, unique: true
  end
end
