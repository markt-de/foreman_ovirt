# frozen_string_literal: true

module FogExtensions
  module Ovirt
    module Server
      extend ActiveSupport::Concern

      include ActionView::Helpers::NumberHelper

      attr_accessor :image_id

      def to_s
        name
      end

      def state
        status
      end

      def interfaces_attributes=(attrs)
      end

      def volumes_attributes=(attrs)
      end

      def poweroff
        service.vm_action(id: id, action: :shutdown)
      end

      def reset
        reboot
      end

      def vm_description
        format(
          _('%<cores>s Cores and %<memory>s memory'), cores: cores, memory: number_to_human_size(memory.to_i)
        )
      end

      def select_nic(fog_nics, nic)
        nic_network = @service.list_networks(@attributes[:cluster]).detect do |n|
          n.name == nic.compute_attributes['network']
        end.try(:id) || nic.compute_attributes['network']
        # grab any nic on the same network
        fog_nics.detect do |fn|
          fn.network == nic_network
        end
      end
    end
  end
end
