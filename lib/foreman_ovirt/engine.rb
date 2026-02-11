module ForemanOvirt
  class Engine < ::Rails::Engine
    engine_name 'foreman_ovirt'

    initializer 'foreman_ovirt.load_app_instance_data' do |app|
      ForemanOvirt::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_ovirt.register_plugin', before: :finisher_hook do |app|
      app.reloader.to_prepare do
        Foreman::Plugin.register :foreman_ovirt do
          requires_foreman '>= 3.16'
          compute_resource ForemanOvirt::Ovirt
          register_gettext

          register_global_js_file 'global'

          security_block :foreman_ovirt do
            permission :view_compute_resources,
              { 'foreman_ovirt/compute_resources': [:available_vnic_profiles] }
          end
        end
      end
    end

    # Precompile any JS or CSS files under app/assets/
    # If requiring files from each other, list them explicitly here to avoid precompiling the same
    # content twice.
    assets_to_precompile =
      Dir.chdir(root) do
        Dir['app/assets/javascripts/foreman_ovirt/**/*',
          'app/assets/stylesheets/foreman_ovirt/**/*'].map do |f|
          f.split(File::SEPARATOR, 4).last
        end
      end
    initializer 'foreman_ovirt.assets.precompile' do |app|
      app.config.assets.precompile += assets_to_precompile
    end
    initializer 'foreman_ovirt.configure_assets', group: :assets do
      SETTINGS[:foreman_ovirt] = {
        assets: {
          precompile: assets_to_precompile,
        },
      }
    end

    config.to_prepare do
      require 'fog/ovirt'
      require 'fog/ovirt/models/compute/server'
      Fog::Ovirt::Compute::Server.include FogExtensions::Ovirt::Server
      require 'fog/ovirt/models/compute/template'
      Fog::Ovirt::Compute::Template.include FogExtensions::Ovirt::Template
      require 'fog/ovirt/models/compute/volume'
      Fog::Ovirt::Compute::Volume.include FogExtensions::Ovirt::Volume

      ::ComputeResourcesVmsController.include ForemanOvirt::ComputeResourcesVmsController
      ::ComputeResourcesController.include ForemanOvirt::ParametersExtension
    rescue StandardError => e
      Rails.logger.warn "ForemanOvirt: skipping engine hook (#{e})"
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanOvirt::Engine.load_seed
      end
    end
  end
end
