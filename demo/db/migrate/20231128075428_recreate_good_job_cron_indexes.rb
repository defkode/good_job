# frozen_string_literal: true

class RecreateGoodJobCronIndexes < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    reversible do |dir|
      dir.up do
        # Ensure this incremental update migration is idempotent
        # with monolithic install migration.
        remove_index :good_jobs, [:cron_key, :created_at] if index_exists?(:good_jobs, [:cron_key, :created_at])
        remove_index :good_jobs, [:cron_key, :cron_at] if index_exists?(:good_jobs, [:cron_key, :cron_at])

        add_index :good_jobs, [:cron_key, :created_at], where: "(cron_key IS NOT NULL)",
          name: :index_good_jobs_on_cron_key_and_created_at, algorithm: :concurrently

        add_index :good_jobs, [:cron_key, :cron_at], where: "(cron_key IS NOT NULL)", unique: true,
          name: :index_good_jobs_on_cron_key_and_cron_at, algorithm: :concurrently
      end
    end
  end
end
