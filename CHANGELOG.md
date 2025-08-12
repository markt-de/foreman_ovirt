# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [v2.0.0] - 2025-08-12
This is mostly a 1:1 port of the original code from Foreman 3.15.0.

### Added
* Add oVirt card to host details page
* Add workaround for core db migration 20250414121956 to prevent removal of oVirt data
* Add migration for old oVirt compute resource data (Foreman::Model::Ovirt -> ForemanOvirt::Ovirt)

### Fixed
* Fix rendering of JSON partials on Rails 7

[Unreleased]: https://github.com/markt-de/foreman_ovirt/compare/v2.0.0...HEAD
[v2.0.0]: https://github.com/markt-de/foreman_ovirt/compare/v1.0.0...v2.0.0
[#1]: https://github.com/markt-de/foreman_ovirt/pull/1
