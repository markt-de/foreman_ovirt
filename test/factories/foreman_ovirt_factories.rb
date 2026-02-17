# frozen_string_literal: true

FactoryBot.define do
  # This file defines factories for the ForemanOvirt plugin.
  factory :ovirt_host, parent: :host do
    name { 'foreman_ovirt' }
  end

  # The factory for the oVirt compute resource.
  factory :ovirt_cr, class: 'ForemanOvirt::Ovirt', parent: :compute_resource do
    name { 'oVirt' }
    url { 'https://ovirt.example.com/ovirt-engine/api' }
    user { 'admin@internal' }
    password { 'secret' }
    uuid { '56396f90-84c4-11e1-88f5-1231381c4021' }
    provider { 'Ovirt' }

    # This ensures the test doesn't actually try to talk to a real server
    after(:build) { |cr| cr.stubs(:update_public_key) }
  end
end
