class users {

  user { "edward":
    ensure 	=> "present",
    shell 	=> "/bin/bash",
    managehome 	=> true,
  }

}
