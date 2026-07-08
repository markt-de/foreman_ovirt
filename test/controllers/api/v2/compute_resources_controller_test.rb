# frozen_string_literal: true

require 'test_plugin_helper'
require 'fog/ovirt/models/compute/quota'

module Api
  module V2
    # rubocop:disable Metrics/ClassLength
    class OvirtComputeResourcesControllerTest < ActionController::TestCase
      # rubocop:enable Metrics/ClassLength
      tests Api::V2::ComputeResourcesController

      def setup
        Fog.mock!
      end

      def teardown
        Fog.unmock!
      end

      context 'ovirt available resources' do
        setup do
          @ovirt_object = Object.new
          @ovirt_object.stubs(:name).returns('test_ovirt_object')
          @ovirt_object.stubs(:id).returns('my11-test35-uuid99')

          quota = Fog::Ovirt::Compute::Quota.new(id: '1', name: 'Default')
          client_mock = mock.tap { |m| m.stubs(datacenters: [], quotas: [quota], servers: []) }
          ForemanOvirt::Ovirt.any_instance.stubs(:client).returns(client_mock)

          @ovirt_cr = FactoryBot.create(:ovirt_cr)
        end

        teardown do
          if @response.present? && @response.code.to_i.between?(200, 299)
            available_objects = ActiveSupport::JSON.decode(@response.body)
            assert_not_empty available_objects
          end
        end

        test 'should get available virtual machines' do
          ForemanOvirt::Ovirt.any_instance.stubs(:available_virtual_machines).returns([@ovirt_object])
          get :available_virtual_machines, params: { id: @ovirt_cr.to_param }
        end

        test 'should get available networks' do
          ForemanOvirt::Ovirt.any_instance.stubs(:available_networks).returns([@ovirt_object])
          get :available_networks, params: { id: @ovirt_cr.to_param, cluster_id: '123-456-789' }
        end

        test 'should get available clusters' do
          ForemanOvirt::Ovirt.any_instance.stubs(:available_clusters).returns([@ovirt_object])
          get :available_clusters, params: { id: @ovirt_cr.to_param }
        end

        test 'should get available storage domains' do
          ForemanOvirt::Ovirt.any_instance.stubs(:available_storage_domains).returns([@ovirt_object])
          get :available_storage_domains, params: { id: @ovirt_cr.to_param }
        end
      end

      context 'ovirt datacenters' do
        setup do
          quota = Fog::Ovirt::Compute::Quota.new(id: '1', name: 'Default')
          client_mock = mock.tap { |m| m.stubs(datacenters: [], quotas: [quota], servers: []) }
          ForemanOvirt::Ovirt.any_instance.stubs(:client).returns(client_mock)
        end

        test 'should create with datacenter name' do
          datacenter_uuid = Foreman.uuid
          ForemanOvirt::Ovirt.any_instance.stubs(:get_datacenter_uuid).returns(datacenter_uuid)
          ForemanOvirt::Ovirt.any_instance.stubs(:test_connection).returns(true)

          attrs = { name: 'Ovirt-create-test', url: 'https://myovirt/api', provider: 'ovirt',
                    datacenter: 'test', user: 'user@example.com', password: 'secret' }
          post :create, params: { compute_resource: attrs }

          assert_response :created
          assert_equal datacenter_uuid, ActiveSupport::JSON.decode(@response.body)['datacenter']
        end

        test 'should create with datacenter uuid' do
          datacenter_uuid = Foreman.uuid
          # Implicitly tests that conversion is skipped
          ForemanOvirt::Ovirt.any_instance.expects(:get_datacenter_uuid).never

          attrs = { name: 'Ovirt-create-test', url: 'https://myovirt/api', provider: 'ovirt',
                    datacenter: datacenter_uuid, user: 'user@example.com', password: 'secret' }
          post :create, params: { compute_resource: attrs }

          assert_response :created
          assert_equal datacenter_uuid, ActiveSupport::JSON.decode(@response.body)['datacenter']
        end

        test 'should update with datacenter name' do
          datacenter_uuid = Foreman.uuid
          compute_resource = FactoryBot.create(:ovirt_cr)

          ForemanOvirt::Ovirt.any_instance.stubs(:get_datacenter_uuid).returns(datacenter_uuid)
          ForemanOvirt::Ovirt.any_instance.stubs(:test_connection).returns(true)

          attrs = { datacenter: 'test' }
          put :update, params: { id: compute_resource.id, compute_resource: attrs }

          assert_response :ok
          assert_equal datacenter_uuid, ActiveSupport::JSON.decode(@response.body)['datacenter']
        end

        test 'should update with datacenter uuid' do
          datacenter_uuid = Foreman.uuid
          compute_resource = FactoryBot.create(:ovirt_cr)

          # Implicitly tests that conversion is skipped
          ForemanOvirt::Ovirt.any_instance.expects(:get_datacenter_uuid).never

          attrs = { datacenter: datacenter_uuid }
          put :update, params: { id: compute_resource.id, compute_resource: attrs }

          assert_response :ok
          assert_equal datacenter_uuid, ActiveSupport::JSON.decode(@response.body)['datacenter']
        end

        test 'should handle datacenter conversion failure' do
          exception_msg = 'Datacenter not found or Auth failed'
          ForemanOvirt::Ovirt.any_instance.stubs(:test_connection).raises(Foreman::Exception.new(exception_msg))

          attrs = { name: 'Ovirt-rescue-test', url: 'https://myovirt/api', provider: 'ovirt',
                    datacenter: 'Failing-DC', user: 'user@example.com', password: 'secret' }
          post :create, params: { compute_resource: attrs }

          assert_response :unprocessable_entity
        end

        test 'should skip conversion safely if datacenter is completely omitted or blank' do
          ForemanOvirt::Ovirt.any_instance.expects(:get_datacenter_uuid).never
          attrs = { name: 'Ovirt-omitted-test', url: 'https://myovirt/api', provider: 'ovirt',
                    user: 'user@example.com', password: 'secret' }
          post :create, params: { compute_resource: attrs }

          assert_response :created
          assert_nil ActiveSupport::JSON.decode(@response.body)['datacenter']
        end

        test 'should skip datacenter conversion if provider is not ovirt' do
          ForemanOvirt::Ovirt.any_instance.expects(:get_datacenter_uuid).never

          attrs = { name: 'Non-Ovirt-test', url: 'qemu:///system', provider: 'Libvirt', datacenter: 'leave-me-alone' }
          post :create, params: { compute_resource: attrs }

          assert_equal 'leave-me-alone', @controller.params[:compute_resource][:datacenter]
        end

        test 'should handle provider name with different casing' do
          datacenter_uuid = Foreman.uuid
          ForemanOvirt::Ovirt.any_instance.stubs(:get_datacenter_uuid).returns(datacenter_uuid)
          ForemanOvirt::Ovirt.any_instance.stubs(:test_connection).returns(true)

          attrs = { name: 'Ovirt-uppercase-test', url: 'https://myovirt/api', provider: 'OVIRT',
                    datacenter: 'test', user: 'user@example.com', password: 'secret' }
          post :create, params: { compute_resource: attrs }

          assert_response :created
          assert_equal datacenter_uuid, ActiveSupport::JSON.decode(@response.body)['datacenter']
        end
      end

      test 'should skip datacenter conversion on update if provider is not ovirt' do
        compute_resource = FactoryBot.create(:vmware_cr)
        ForemanOvirt::Ovirt.any_instance.expects(:get_datacenter_uuid).never

        attrs = { datacenter: 'leave-me-alone' }
        put :update, params: { id: compute_resource.id, compute_resource: attrs }

        assert_equal 'leave-me-alone', @controller.params[:compute_resource][:datacenter]
      end

      context 'ovirt cache refreshing' do
        test 'should fail if unsupported' do
          ovirt_cr = FactoryBot.create(:ovirt_cr)
          put :refresh_cache, params: { id: ovirt_cr.to_param }
          assert_response :error
        end
      end
    end
  end
end
