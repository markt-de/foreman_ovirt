class UpdateLegacyOvirtComputeResourceType < ActiveRecord::Migration[7.0]
  # Temporary model definition to ensure the migration is self-contained
  # and independent of the application's model, which may change over time.
  class ComputeResource < ActiveRecord::Base
    self.table_name = :compute_resources
    # Disable STI to allow direct manipulation of the 'type' column.
    self.inheritance_column = :_type_disabled
  end

  # Migrate the legacy class name to the new plugin class name.
  def up
    say "Updating legacy oVirt compute resource types to ForemanOvirt::Ovirt"
    ComputeResource.where(type: 'Foreman::Model::Ovirt').update_all(type: 'ForemanOvirt::Ovirt')
  end

  # Revert the class name back to the legacy value.
  def down
    say "Reverting oVirt compute resource types back to legacy Foreman::Model::Ovirt"
    ComputeResource.where(type: 'ForemanOvirt::Ovirt').update_all(type: 'Foreman::Model::Ovirt')
  end
end
