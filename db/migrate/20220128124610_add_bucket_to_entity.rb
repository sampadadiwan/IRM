class AddBucketToEntity < ActiveRecord::Migration[7.0]
  def change
    add_column :entities, :s3_bucket, :string
  end
end
