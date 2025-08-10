# ForemanOvirt

#### Table of Contents

1. [Overview](#overview)
1. [Installation](#installation)
1. [Usage](#usage)
1. [Development](#development)
    - [Dev prerequisites](#dev-prerequisites)
    - [Dev server](#dev-server)
1. [Contributing](#contributing)
1. [Copyright](#copyright)
    - [Plugin](#plugin)
    - [The Foreman](#the-forman)

## Overview

[Foreman](http://theforeman.org/) plugin that adds [oVirt](https://www.ovirt.org) compute resource: managing virtual machines using the [fog-ovirt](https://github.com/fog/fog-ovirt) module.

This plugin continues the oVirt support that was part of Foreman up to version 3.15 and is now maintained as a standalone plugin. It requires Foreman 3.16+.

## Installation

### From OS packages

On Rocky/Alma/RedHat:

```shell
sudo dnf install rubygem-foreman_ovirt
```

On Debian/Ubuntu:

```shell
sudo apt-get install ruby-foreman-ovirt
```

## Usage

Create a oVirt compute resource and set:

* Provider: `oVirt`
* URL: `https://ovirt.example.com/ovirt-engine/api`
* Username: `admin@internal`

Then click on "Load Datacenters" and add all necessary information to the form.

## Development

### Dev prerequisites

See [Foreman dev setup](https://github.com/theforeman/foreman/blob/develop/developer_docs/foreman_dev_setup.asciidoc) and [foreman plugin development](https://github.com/theforeman/foreman/blob/develop/developer_docs/how_to_create_a_plugin.asciidoc) for details and a full explanation.

* oVirt 4.5+ is required
* NodeJS on the dev machine to run webpack-dev-server

### Dev server

NOTE: The following ignores all OS-dependant tasks and commands. Please see the official Foreman developer guide for an in-depth walkthrough.

Fork and clone this plugin repository:

```shell
git clone https://github.com/YOUR_FORK/foreman_ovirt.git
```

Minimal steps to setup a Foreman dev instance:

```shell
git clone https://github.com/theforeman/foreman.git -b develop
cd foreman
cp config/settings.yaml.example config/settings.yaml
cp config/database.yml.example config/database.yml
```

Edit `bundler.d/ovirt.rb` and add this content:

```ruby
gem 'fog-ovirt'
gem 'foreman_ovirt', :path => '/path/to/foreman_ovirt'
gem 'irb' # dev
```

In foreman directory, install dependencies:

```shell
bundle install --path vendor
npm install
```

Run Foreman dev server:

```shell
BIND=0.0.0.0 bundle exec foreman start
```

Note that the bundled webpack server may consume HUGE amounts of RAM on startup.

## Contributing

Fork and send a Pull Request. Thanks!

## Copyright

### Plugin

Copyright (c) 2025 markt.de GmbH & Co. KG

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

The [LICENSE](LICENSE) file contains the full text of the GNU GPL v3 license, along with the text for all additional licenses referenced above.

### The Foreman

This plugin is based on code from Foreman 3.15.0.

The Foreman repository/package is licensed under the GNU GPL v3 or newer, with some exceptions.

Copyright (c) 2009-2020 to Ohad Levy, Paul Kelly and their respective owners.

All copyright holders for the Foreman project are in the separate file called Contributors.

Except where specified below, this program and entire repository is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see [GNU licenses](http://www.gnu.org/licenses/).

All rights reserved.
