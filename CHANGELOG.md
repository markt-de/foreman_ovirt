# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [v2.0.4] - 2026-07-13

### Added
* Revive code tests ([#12],[#22],[#23],[#24,[#25],[#26],[#30]])

### Changed
* Update plugin description ([#13])

### Fixed
* Fix oVirt datacenter name to UUID conversion in API ([#29])
* Fix to prevent the recreation of view_compute_resource permission ([#35])

## [v2.0.3] - 2025-12-03

### Fixed
* Fix cloning of hosts ([#11])

## [v2.0.2] - 2025-11-18

### Fixed
* Hide card if not compute resource oVirt ([#9])

## [v2.0.1] - 2025-08-18

### Fixed
* Fix metadata (email and site URL)

## [v2.0.0] - 2025-08-12
This is mostly a 1:1 port of the original code from Foreman 3.15.0.

### Added
* Add oVirt card to host details page
* Add workaround for core db migration 20250414121956 to prevent removal of oVirt data
* Add migration for old oVirt compute resource data (Foreman::Model::Ovirt -> ForemanOvirt::Ovirt)

### Fixed
* Fix rendering of JSON partials on Rails 7

[Unreleased]: https://github.com/markt-de/foreman_ovirt/compare/v2.0.4...HEAD
[v2.0.4]: https://github.com/markt-de/foreman_ovirt/compare/v2.0.3...v2.0.4
[v2.0.3]: https://github.com/markt-de/foreman_ovirt/compare/v2.0.2...v2.0.3
[v2.0.2]: https://github.com/markt-de/foreman_ovirt/compare/v2.0.1...v2.0.2
[v2.0.1]: https://github.com/markt-de/foreman_ovirt/compare/v2.0.0...v2.0.1
[v2.0.0]: https://github.com/markt-de/foreman_ovirt/compare/v1.0.0...v2.0.0
[#35]: https://github.com/markt-de/foreman_ovirt/pull/35
[#30]: https://github.com/markt-de/foreman_ovirt/pull/30
[#29]: https://github.com/markt-de/foreman_ovirt/pull/29
[#26]: https://github.com/markt-de/foreman_ovirt/pull/26
[#25]: https://github.com/markt-de/foreman_ovirt/pull/25
[#24]: https://github.com/markt-de/foreman_ovirt/pull/24
[#23]: https://github.com/markt-de/foreman_ovirt/pull/23
[#22]: https://github.com/markt-de/foreman_ovirt/pull/22
[#13]: https://github.com/markt-de/foreman_ovirt/pull/13
[#12]: https://github.com/markt-de/foreman_ovirt/pull/12
[#11]: https://github.com/markt-de/foreman_ovirt/pull/11
[#9]: https://github.com/markt-de/foreman_ovirt/pull/9
