keyth
=====

A little gem to manage keys that aren't supposed to leave the machine.

Many local configuration files contain a mixture of keys that it would be fine to commit to the code repo and keys that it would be dangerous to commit to the code repo. Keyth allows you to refer to those values symbolically.

### EXAMPLE USAGE:

For example, my_values.yml was:

	my:
	  values:
	  	our_aws: HERE_IS_A_KEY_THAT_I_CANT_COMMIT
	  	their_aws: HERE_IS_ANOTHER
	  	machine_type: t3.small # but this is fine to commit

..and now becomes

    my:
      values:
        our_aws: keyth:mycompany/AWS_ACCESS_KEY
        their_aws: keyth:client/AWS_ACCESS_KEY
        machine_type: t3.small

and you load it like this:

    settings = Keyth.fetch_keys YAML.load(File.open('my_values.yml'))

### TOOLS:

bin/keyth_admin allows you to add, remove, or list keys in your local store

### TODO:

Mixins for YAML to allow keyth: markers to be loaded automatically

Support code for Ruby GitHooks that will automatically flag any key listed in the key repository that has somehow escaped into commitable files.
