# frozen_string_literal: true

require 'test_plugin_helper'
require 'integration_test_helper'

module ForemanOvirt
  class ComputeProfileJSTest < IntegrationTestWithJavascript
    setup do
      Fog.mock!
      @ovirt_cr = FactoryBot.create(:ovirt_cr)

      @mock_template = FactoryBot.build(:ovirt_template)
      ForemanOvirt::Ovirt.any_instance.stubs(:template).returns(@mock_template)
    end

    teardown do
      Fog.unmock!
    end

    test 'create compute profile' do
      visit compute_profiles_path
      click_on('Create Compute Profile')
      fill_in('compute_profile_name', with: 'test')
      click_on('Submit')

      click_link(@ovirt_cr.to_s)
      assert page.has_select?('compute_attribute[vm_attrs][vm_template]')

      # Selecting a template triggers a POST to template_selected. The JS handler
      # in ovirt.js receives the response and populates memory and cores via
      # setMemoryInputProps and updateCoresAndSockets.
      select('hwp_small (base version)', from: 'compute_attribute[vm_attrs][vm_template]')
      wait_for_ajax

      click_button('Submit')

      created_profile = ComputeProfile.find_by!(name: 'test')
      assert_current_path compute_profile_path(created_profile)

      # Reload the form and verify the template values were saved and are
      # rendered back correctly by the server.
      visit compute_profiles_path
      click_link('test')
      click_link(@ovirt_cr.to_s)

      assert_equal '512 MB', find_field('compute_attribute_vm_attrs_memory').value
      assert_equal '1', find_field('compute_attribute_vm_attrs_cores').value
    end
  end
end