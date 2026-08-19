{ ... }:

{
  assets = { };

  corn = ''
    $temp_info ={ type = "sys_info" format = ["{temp_c}"] interval = 10 }
    $sys_info = { type = "sys_info" format = [" {cpu_percent}%" " {memory_percent}%" "{temp_c}"] interval = 10 }
  '';

  css = ''
    /* --- sysinfo --- */

        .sysinfo > .item + .item {
            margin-left: var(--margin-sm);
        }
  '';
}
