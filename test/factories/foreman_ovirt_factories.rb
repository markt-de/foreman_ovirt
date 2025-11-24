FactoryBot.define do
  factory :ovirt_cr, :class => ForemanOvirt::Ovirt, :parent => :compute_resource do
    provider { 'Ovirt' }
    user { 'ovirtuser' }
    password { 'ovirtpassword' }
    after(:build) { |cr| cr.stubs(:update_public_key) }
  end
end
