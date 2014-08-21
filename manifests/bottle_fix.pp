# Public: provides a package specific fix 
#
# Usage:
#
#   boxen::env_script {
#    'config':
#      content  => template('boxen/config.sh.erb'),
#      priority => 'highest';
#   }

define boxen::bottle_fix ($formula_title = undef) {
	# the default behavior for boxen is to use bottles the boxen team brews themselves and hosts on their S3 site, rather than the default homebrew bottles
	# for "reasons"[https://github.com/boxen/puppet-homebrew/issues/18], this royally screws up installing certain programs (gcc,python,nginx,imagemagick) on older macs and virtual machines. If you have the related problem, your build will fail with something like "Illegal instruction: 4" 
	# the following resource collector fixes this on a package specific level by taking advantage of a quirk in the homebrew.rb provider
	if $formula_title != undef
	{
	  Package <| (title == $formula_title) and (install_options == undef or install_options == []) |> { 
	    install_options => [ '--verbose' ]
	  }
	}
	else
	{
	# this resource collector does the same as above, but for all homebrew packages. Checking provider against undef is meant to capture packages which use the default provider, has not been tested
		Package <| (provider == homebrew or provider == undef) and (install_options == undef or install_options == []) |> {
		  install_options => [ '--verbose' ]
		}
	}
}