# Public: Install the basic debian packages required for smooth boxening.
#         The $list and $defaults variables are by default defined in puppet-boxen/data/Debian.yaml
#
# Usage:
#
#   include boxen::debian_dependencies

class boxen::debian_dependencies($list, $defaults) {
  create_resources(package,$list,$defaults)
}