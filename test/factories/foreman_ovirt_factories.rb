# frozen_string_literal: true

FactoryBot.define do
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

    after(:build) do |cr|
      cr.stubs(:update_public_key)
    end
  end
end
