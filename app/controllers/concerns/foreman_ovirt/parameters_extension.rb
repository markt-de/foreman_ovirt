# frozen_string_literal: true

module ForemanOvirt
  module ParametersExtension
    extend ActiveSupport::Concern

    # This block is executed when the module is included in the base class.
    # It's responsible for setting up the method alias chain.
    included do
      # We need to modify class methods, so we operate on the singleton class.
      class << self
        # Create an alias for the original method.
        alias_method :compute_resource_params_filter_without_ovirt, :compute_resource_params_filter
        # Make the original method name point to our new implementation.
        alias_method :compute_resource_params_filter, :compute_resource_params_filter_with_ovirt
      end
    end

    module ClassMethods
      # Our new implementation that extends the original functionality.
      def compute_resource_params_filter_with_ovirt
        # Call the original method via its new alias to get the base filter object.
        compute_resource_params_filter_without_ovirt.tap do |filter|
          # Now, add the oVirt specific parameters to the existing filter.
          filter.permit :datacenter,
            :ovirt_quota,
            :keyboard_layout,
            :use_v4,
            :public_key,
            :uuid
        end
      end
    end
  end
end
