module OvirtComputeResourceHelper
  # Really counting vms is as expensive as loading them all, especially when
  # a filter is in place. So we create a fake count to get table pagination to work.
  def ovirt_fake_vms_count
    params['start'].to_i + 1 + [@vms.length, params['length'].to_i].min
  end

  def ovirt_storage_domains_for_select(compute_resource)
    compute_resource.storage_domains.map do |sd|
      OpenStruct.new({ id: sd.id,
     label: "#{sd.name} (" + _('Available') + ": #{sd.available.to_i / 1.gigabyte} GiB, " + _('Used') + ": #{sd.used.to_i / 1.gigabyte} GiB)" })
    end
  end

  def ovirt_vms_data
    data = @vms.map do |vm|
      [
        link_to_if_authorized(html_escape(vm.name),
          hash_for_compute_resource_vm_path(compute_resource_id: @compute_resource, id: vm.id).merge(
            auth_object: @compute_resource, auth_action: 'view', authorizer: authorizer
          )),
        vm.cores,
        number_to_human_size(vm.memory),
        "<span #{vm_power_class(vm.ready?)}>#{vm_state(vm)}</span>",
        action_buttons(vm_power_action(vm, authorizer),
          vm_import_action(vm), vm_associate_link(vm),
          display_delete_if_authorized(hash_for_compute_resource_vm_path(compute_resource_id: @compute_resource, id: vm.id).merge(auth_object: @compute_resource, authorizer: authorizer))),
      ]
    end
    JSON.fast_generate(data).html_safe
  end
end
