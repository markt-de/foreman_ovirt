# Ensure the task is only defined when the main app is loaded.
if defined?(Rails) && Rails.application
  namespace :foreman_ovirt do
    namespace :db do
      desc "Prevents the destructive core oVirt data migration from being run by marking it as complete."
      task :prevent_core_migration => :environment do
        # The version of the Foreman core migration to skip.
        version_to_skip = 20250414121956
        migration_context = ActiveRecord::Base.connection.migration_context

        all_migrations = migration_context.migrations.map(&:version)
        run_migrations = migration_context.get_all_versions

        # A migration needs to be run if
        # - it's not a fresh (empty) database
        # - the migration exists on disk but is not yet marked as run in the database
        if migration_context.current_version != 0 && all_migrations.include?(version_to_skip) && !run_migrations.include?(version_to_skip)
          Rails.logger.info "[foreman_ovirt] Marking core migration #{version_to_skip} (MigrateOvirtResources) as complete to prevent data loss."
          ActiveRecord::SchemaMigration.create!(version: version_to_skip.to_s)
          Rails.logger.info "[foreman_ovirt] Core migration successfully skipped."
        else
          Rails.logger.debug "[foreman_ovirt] Core migration #{version_to_skip} does not need to be skipped (already migrated or not found)."
        end
      end
    end
  end

  # Enhance the core db:migrate task to run our prevention task first.
  if Rake::Task.task_defined?('db:migrate')
    Rake::Task['db:migrate'].enhance(['foreman_ovirt:db:prevent_core_migration'])
  end
end

# Tests
namespace :test do
  desc 'Test ForemanOvirt'
  Rake::TestTask.new(:foreman_ovirt) do |t|
    test_dir = File.expand_path('../../test', __dir__)
    t.libs << 'test'
    t.libs << test_dir
    t.pattern = "#{test_dir}/**/*_test.rb"
    t.verbose = true
    t.warning = false
  end
end

Rake::Task[:test].enhance ['test:foreman_ovirt']
