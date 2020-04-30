# duo_openvpn

Puppet module to download, build, and install the [duo_openvpn][1] plugin

## Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with duo_openvpn](#setup)
    * [What duo_openvpn affects](#what-duo_openvpn-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with duo_openvpn](#beginning-with-duo_openvpn)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

If you need two-factor authentication with [OpenVPN][2], you can use the [duo_openvpn][1] plugin to enable 2fa if you already use [Duo][3] in your enterprise.

## Setup

### What duo_openvpn affects

This module only concerns itself with downloading and installing the [duo_openvpn][1] plugin on a system. It does not configure [OpenVPN][2] in any way.  By default, all files are downloaded and installed in the `/opt` directory, but can be overridden with parameters to this class if needed.

### Setup Requirements

This module relies on the [Archive][4] module for downloading the [duo_openvpn][1] software.

### Beginning with duo_openvpn

Not many options should be needed to get this module running. The only thing to watch out for is the fact that certain packages (`curl`, `gcc`, and `make`) are managed by default in this module.  If you already manage these packages elsewhere, it may be necessary to override the `$duo_openvpn::default_packages` array of packages to remove any duplicate packages.

## Usage

For most cases, just including the class is probably enough:

```puppet
include duo_openvpn
```

However if, for example, you want a different version of the module than the default, you can specify that as well:

```puppet
class { 'duo_openvpn':
  version => '2.3',
}
```

## Limitations

None that we know of (yet).

## Development

TBD

### REFERENCE.md

The `REFERENCE.md` file is generated using [puppet-strings][5]. If you make changes to any of the inline documenation, please regenerate this file and add it to your commit:

```sh
puppet strings generate --format markdown
```

[1]: https://github.com/duosecurity/duo_openvpn.git "duo_openvpn"
[2]: https://openvpn.net/ "OpenVPN"
[3]: https://duo.com/ "Duo"
[4]: https://forge.puppet.com/puppet/archive "Archive"
[5]: https://puppet.com/docs/puppet/latest/puppet_strings.html "puppet-strings"
