# Public: provides a package specific fix for https://github.com/boxen/puppet-homebrew/issues/18
#
# Examples
#
#   $bottle_broken_packages = [ 'boxen/brews/gcc48', 'some-other-busted-package', etc. ]
#   class {'boxen::bottle_fixes':
#     formula_titles => $bottle_broken_packages,
#   }

class boxen::bottle_fixes ($formula_titles) {
  if ($formula_titles != [] and $formula_titles != undef) 
  {
    boxen::bottle_fix { $formula_titles: 
      before => Package["${formula_titles}"]
    }
  }
}

define boxen::bottle_fix {
	# the default behavior for boxen is to use bottles the boxen team brews themselves and hosts on their S3 site, rather than the default homebrew bottles
	# for "reasons"[https://github.com/boxen/puppet-homebrew/issues/18], this royally screws up installing certain programs (gcc,python,nginx,imagemagick) on older macs and virtual machines. If you have the related problem, your build will fail with something like "Illegal instruction: 4" 
	# the following resource collector fixes this on a package specific level by taking advantage of a quirk in the homebrew.rb provider, forcing boxen to use the standard homebrew bottles for the specified packages
  Package <| title == $title and (install_options == undef or install_options == []) |> { 
    install_options => [ '--verbose' ]
  }
	# this resource collector is meant to do the same as above, but for all homebrew packages. Checking provider against undef is meant to capture packages which use the default provider, seems not to work.
#  Package <| (provider == homebrew or provider == undef) and (install_options == undef or install_options == []) |> {
#   install_options => [ '--verbose' ]
}
