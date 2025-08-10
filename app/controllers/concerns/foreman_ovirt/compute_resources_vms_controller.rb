module ForemanOvirt
  module ComputeResourcesVmsController
    extend ActiveSupport::Concern

    included do
      prepend Overrides
    end

    module Overrides
      def index
        load_vms
        @authorizer = Authorizer.new(User.current, collection: [@compute_resource])

        respond_to do |format|
          format.html
          format.json do
            if @compute_resource.supports_vms_pagination?
              # XXX: Foreman Core uses ".json", but this results in a "partial missing" error.
              render partial: "compute_resources_vms/index/#{@compute_resource.provider.downcase}_json"
            else
              render json: _('JSON VM listing is not supported for this compute resource.'),
                     status: :not_implemented
            end
          end
        end
      end
    end
  end
end
