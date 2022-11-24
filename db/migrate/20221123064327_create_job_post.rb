class CreateJobPost < ActiveRecord::Migration[6.1]
  def change
    create_table :job_posts do |t|
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true
      t.string :type

      t.timestamps
    end
  end
end
