class AddTextToMeme < ActiveRecord::Migration
  def change
  	add_column(:memes, :top_text, :string)
  	add_column(:memes, :bottom_text, :string)
  end
end
