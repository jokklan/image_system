class CreateImageWithCdnFields < ActiveRecord::Migration
  def change
    create_table(:<%= class_name.pluralize %>) do |t|
      t.string  :uuid
      t.integer :width  # width in px
      t.integer :height # height in px

      t.timestamps
    end

    add_index :<%= class_name.pluralize %>, :uuid, unique: true
  end
end
