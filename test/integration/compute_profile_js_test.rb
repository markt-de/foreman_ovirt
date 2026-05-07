# frozen_string_literal: true

require 'test_plugin_helper'
require 'integration_test_helper'

module ForemanOvirt
  class ComputeProfileJSTest < IntegrationTestWithJavascript
    setup do
      Fog.mock!
    end

    teardown do
      Fog.unmock!
    end

    test 'create compute profile' do
      @ovirt_cr = FactoryBot.create(:ovirt_cr)

      # Mock templates so they're available in the form dropdown
      template1 = Struct.new(:id, :full_name).new('tpl1', 'template 1')
      template2 = Struct.new(:id, :full_name).new('tpl2', 'template 2')
      ForemanOvirt::Ovirt.any_instance.stubs(:templates).returns([template1, template2])

      visit compute_profiles_path
      click_on('Create Compute Profile')

      work_around_selenium_file_detector_bug if respond_to?(:work_around_selenium_file_detector_bug)

      fill_in('compute_profile_name', with: 'test')
      click_on('Submit')

      # Click into the oVirt compute resource tab
      assert click_link(@ovirt_cr.to_s), 'Failed to click oVirt compute resource link'

      # Verify the form has the required fields
      assert page.has_select?('compute_attribute_vm_attrs_vm_template'), 'Template field not found'
      assert page.has_field?('compute_attribute_vm_attrs_memory'), 'Memory field not found'
      assert page.has_field?('compute_attribute_vm_attrs_cores'), 'Cores field not found'

      # Select a template
      select('template 1', from: 'compute_attribute_vm_attrs_vm_template')
      wait_for_ajax

      fill_in('compute_attribute_vm_attrs_memory', with: '512')
      fill_in('compute_attribute_vm_attrs_cores', with: '2')

      click_button('Submit')

      # Verify submission succeeded
      assert page.has_text?('test'), 'Profile name not found after submission'

      # Reload the profile and verify the values persisted to the database
      visit compute_profiles_path
      click_link('test')
      assert click_link(@ovirt_cr.to_s), 'Failed to click oVirt compute resource link on reload'

      memory_value = find_field('compute_attribute_vm_attrs_memory').value
      cores_value = find_field('compute_attribute_vm_attrs_cores').value

      assert_not memory_value.empty?, 'Memory value should not be empty after reload'
      assert_equal '2', cores_value, 'Cores value should persist after reload'
    end
  end
end
