# frozen_string_literal: true

FactoryBot.define do
  # This file defines factories for the ForemanOvirt plugin.
  # The factory for the oVirt compute resource.
  factory :ovirt_cr,
    class: 'ForemanOvirt::Ovirt', parent: :compute_resource do
    name { 'oVirt' }
    url do
      'https://ovirt.example.com/ovirt-engine/api'
    end
    user do
      'admin@internal'
    end
    password do
      'secret'
    end
    uuid do
      '56396f90-84c4-11e1-88f5-1231381c4021'
    end
    provider do
      'Ovirt'
    end

    # This ensures the test doesn't actually try to talk to a real server
    after(:build) do |cr|
      cr.stubs(:update_public_key)
    end
  end
end
