# rubocop:disable Metrics/ModuleLength
module ComputeResourceTestHelpers
  def empty_servers
    servers = mock
    servers.stubs(:get).returns(nil)
    servers
  end

  def servers_raising_exception(exception)
    servers = mock
    servers.stubs(:get).raises(exception)
    servers
  end

  def mock_cr_servers(compute_resource, servers)
    client = mock
    client.stubs(:servers).returns(servers)

    compute_resource.stubs(:client).returns(client)
    compute_resource
  end

  def mock_cr(compute_resource, attributes)
    attributes.each do |attr, stubbed_value|
      compute_resource.stubs(attr).returns(stubbed_value)
    end
    compute_resource
  end

  def assert_find_by_uuid_raises(ex_class, compute_resource)
    assert_raises(ex_class) do
      compute_resource.find_vm_by_uuid('abc')
    end
  end

  def assert_blank_attr_nilified(compute_resource, attr_name)
    vm_attrs = {
      attr_name => '',
    }
    normalized = compute_resource.normalize_vm_attrs(vm_attrs)

    assert(normalized.key?(attr_name))
    assert_nil(normalized[attr_name])
  end

  def assert_attrs_mapped(compute_resource, attr_before, attr_after)
    vm_attrs = {
      attr_before => 'ATTR_VALUE',
    }
    normalized = compute_resource.normalize_vm_attrs(vm_attrs)

    assert_not(normalized.key?(attr_before))
    assert_equal('ATTR_VALUE', normalized[attr_after])
  end

  def assert_blank_mapped_attr_nilified(compute_resource, attr_before, attr_after)
    vm_attrs = {
      attr_before => '',
    }
    normalized = compute_resource.normalize_vm_attrs(vm_attrs)

    assert_not(normalized.key?(attr_before))
    assert(normalized.key?(attr_after))
    assert_nil(normalized[attr_after])
  end

  # rubocop:disable Metrics/MethodLength
  #
  def allowed_vm_attr_names
    @allowed_vm_attr_names ||= %w[
      add_cdrom
      annotation
      availability_zone
      boot_from_volume
      boot_volume_size
      cluster_id
      cluster_name
      cores
      cores_per_socket
      cpu_hot_add_enabled
      cpus
      associate_external_ip
      firmware
      flavor_id
      flavor_name
      floating_ip_network
      folder_name
      folder_path
      guest_id
      guest_name
      hardware_version_id
      hardware_version_name
      image_id
      image_name
      interfaces_attributes
      keys
      machine_type
      managed_ip
      memory
      memory_hot_add_enabled
      network
      resource_pool_id
      resource_pool_name
      scheduler_hint_filter
      scsi_controllers
      nvme_controllers
      security_groups
      security_group_id
      security_group_name
      subnet_id
      subnet_name
      template_id
      template_name
      tenant_id
      tenant_name
      volumes_attributes
    ]
  end

  # rubocop:enable Metrics/MethodLength

  def check_vm_attribute_names(compute_resource)
    normalized_keys = compute_resource.normalize_vm_attrs({}).keys

    normalized_keys.each do |name|
      assert_equal(name, name.to_s.underscore, "Attribute '#{name}' breaks naming conventions. All attributes should be in snake_case.")
    end

    unexpected_names = normalized_keys - (normalized_keys & allowed_vm_attr_names)
    msg = "Some unexpected attributes detected: #{unexpected_names.join(', ')}."
    msg += "\nMake user you can't use one of names that already exist. If not, please extend ComputeResourceTestHelpers.allowed_vm_attr_names."
    assert_empty(unexpected_names, msg)
  end
end
# rubocop:enable Metrics/ModuleLength
