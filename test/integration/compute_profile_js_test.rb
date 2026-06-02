# frozen_string_literal: true

require 'test_plugin_helper'
require 'integration_test_helper'

module ForemanOvirt
  class ComputeProfileJSTest < IntegrationTestWithJavascript
    HWP_SMALL_ATTRS = {
      id: '2a08ba05-f3b1-4e5a-ade9-496466a8b323',
      name: 'hwp_small',
      memory: 536_870_912,
      cores: 1,
      sockets: 1,
      ha: false,
      interfaces: [],
      volumes: [],
    }.freeze

    setup do
      Fog.mock!
      @ovirt_cr = FactoryBot.create(:ovirt_cr)
      mock_template = OpenStruct.new(HWP_SMALL_ATTRS)
      ForemanOvirt::Ovirt.any_instance.stubs(:template).returns(mock_template)
    end

    teardown do
      Fog.unmock!
    end

    test 'create compute profile' do
      visit compute_profiles_path
      click_on('Create Compute Profile')
      fill_in('compute_profile_name', with: 'test')
      click_on('Submit')

      assert click_link(@ovirt_cr.to_s), 'Failed to click oVirt compute resource link'
      assert page.has_select?('compute_attribute[vm_attrs][vm_template]'),
             'Template select field not found on compute attribute form'
      select('hwp_small (base version)', from: 'compute_attribute[vm_attrs][vm_template]')
      wait_for_ajax

      assert_equal '512 MB', find_field('compute_attribute_vm_attrs_memory').value,
                   'Memory should auto-populate from the selected template via AJAX'
      assert_equal '1', find_field('compute_attribute_vm_attrs_cores').value,
                   'Cores should auto-populate from the selected template via AJAX'

      click_button('Submit')
      assert_current_path compute_profile_path(ComputeProfile.find_by!(name: 'test'))
      visit compute_profiles_path
      click_link('test')
      assert click_link(@ovirt_cr.to_s), 'Failed to click oVirt compute resource link on reload'

      assert_equal '512 MB', find_field('compute_attribute_vm_attrs_memory').value,
                   'Memory should persist as 512 MB after reload'
      assert_equal '1', find_field('compute_attribute_vm_attrs_cores').value,
                   'Cores should persist as 1 after reload'
    end
  end
end