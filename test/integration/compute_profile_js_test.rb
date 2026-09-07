# frozen_string_literal: true

require 'test_plugin_helper'
require 'integration_test_helper'

module ForemanOvirt
  class ComputeProfileJSTest < IntegrationTestWithJavascript
    setup do
      Fog.mock!
      @ovirt_cr = FactoryBot.create(:ovirt_cr)
    end

    teardown do
      Fog.unmock!
    end

    test 'create compute profile' do
      visit compute_profiles_path
      click_on('Create Compute Profile')
      fill_in('compute_profile_name', with: 'test-profile')
      click_on('Submit')

      click_link(@ovirt_cr.to_s)
      assert page.has_select?('compute_attribute[vm_attrs][vm_template]')

      # Selecting a template triggers a POST to template_selected. The JS handler
      # in ovirt.js receives the response and populates memory and cores via
      # setMemoryInputProps and updateCoresAndSockets.
      # Fog.mock! intercepts the client calls so no real oVirt connection is made.
      select('hwp_small (base version)', from: 'compute_attribute[vm_attrs][vm_template]')
      wait_for_ajax

      click_button('Submit')

      created_profile = ComputeProfile.find_by!(name: 'test-profile')
      assert_current_path compute_profile_path(created_profile)

      # Assert database values rather than display values to avoid fragility
      # from React component formatting differences across CI environments.
      saved_ca = created_profile.compute_attributes.find_by!(compute_resource: @ovirt_cr)
      assert_equal 536_870_912, saved_ca.vm_attrs['memory'].to_i
      assert_equal '1', saved_ca.vm_attrs['cores']
    end
  end
end
