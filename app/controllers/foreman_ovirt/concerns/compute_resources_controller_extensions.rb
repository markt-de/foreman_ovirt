module ForemanOvirt
  module Concerns
    module ComputeResourcesControllerExtensions
      extend ActiveSupport::Concern

      prepended do
        before_action :change_datacenter_to_uuid, only: [:create, :update]
        rescue_from ::ProxyAPI::Ovirt::Unauthorized, with: :render_ovirt_unauthorized_error
      end

      def available_clusters
        organization = find_organization_by_id_or_name(params[:organization_id], params[:organization_name])
        location = find_location_by_id_or_name(params[:location_id], params[:location_name])
        proxy = find_resource(params[:id], [organization, location].compact, ::ProxyAPI::Ovirt)
        render json: proxy.clusters
      rescue Foreman::Exception => e
        render_error e.message, status: :not_found
      end

      def available_vnic_profiles
        organization = find_organization_by_id_or_name(params[:organization_id], params[:organization_name])
        location = find_location_by_id_or_name(params[:location_id], params[:location_name])
        proxy = find_resource(params[:id], [organization, location].compact, ::ProxyAPI::Ovirt)
        render json: proxy.vnic_profiles(params[:network_id])
      rescue Foreman::Exception => e
        render_error e.message, status: :not_found
      end

      def action_permission
        case params[:action]
        when 'available_clusters', 'available_vnic_profiles'
          :view
        else
          super
        end
      end

      private

      def change_datacenter_to_uuid
        return unless params[:compute_resource] && params[:compute_resource][:provider] == 'Ovirt' && params[:compute_resource][:datacenter]
        proxy = find_resource(params[:id]) if params[:id].present?
        proxy ||= ::ProxyAPI::Ovirt.new(
          url: params[:compute_resource][:url],
          user: params[:compute_resource][:user],
          password: params[:compute_resource][:password]
        )
        uuid = proxy.datacenter_uuid_by_name(params[:compute_resource][:datacenter])
        params[:compute_resource][:datacenter] = uuid
      rescue ::ProxyAPI::Ovirt::Unauthorized
      rescue Foreman::Exception => e
        render_error e.message, status: :not_found
      end

      def render_ovirt_unauthorized_error
        render_error "401 Unauthorized", status: :unauthorized
      end
    end
  end
end
