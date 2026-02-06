FactoryBot.define do
  # Keep your host factory
  factory :ovirt_host, parent: :host do
    name { "foreman_ovirt" }
  end

  # ADD THIS: This is what the test errors are asking for
  factory :ovirt_cr, class: 'ForemanOvirt::Ovirt', parent: :compute_resource do
    name { "oVirt" }
    url { "https://ovirt.example.com/ovirt-engine/api" }
    user { "admin@internal" }
    password { "secret" }
    uuid { "56396f90-84c4-11e1-88f5-1231381c4021" }
  end
end