# frozen_string_literal: true

module ForemanOvirt
  module ApiComputeResourcesControllerExtension
    extend ActiveSupport::Concern

    included do
      # rubocop:disable Rails/LexicallyScopedActionFilter
      before_action :convert_datacenter_to_uuid, only: %i[create update]
      # rubocop:enable Rails/LexicallyScopedActionFilter
    end

    private

    def convert_datacenter_to_uuid
      datacenter = params[:compute_resource][:datacenter]
      return if datacenter.blank? || Foreman.is_uuid?(datacenter)

      case params[:action]
      when 'create'
        return unless compute_resource_params[:provider]&.downcase == 'ovirt'
        @compute_resource = ComputeResource.new_provider(compute_resource_params.except(:datacenter))
      when 'update'
        return unless @compute_resource.is_a?(ForemanOvirt::Ovirt)
      else
        Rails.logger.error("Convert datacenter to UUID should not be called for action #{params[:action]}")
        return
      end

      uuid = change_datacenter_to_uuid(datacenter)
      params[:compute_resource][:datacenter] = uuid if uuid.present?
    rescue Foreman::Exception => e
      render_exception(e, status: :unprocessable_entity)
      false
    end

    def change_datacenter_to_uuid(datacenter)
      @compute_resource.test_connection
      @compute_resource.get_datacenter_uuid(datacenter)
    end
  end
end
