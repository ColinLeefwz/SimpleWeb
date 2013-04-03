# Minimal sample configuration file for Unicorn (not Rack) when used
# with daemonization (unicorn -D) started in your working directory.
#
# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.
# See also http://unicorn.bogomips.org/examples/unicorn.conf.rb for
# a more verbose configuration using more features.

listen "127.0.0.1:8082" # by default Unicorn listens on port 8080
listen "#{`echo -n $ipaddr0`}:8082"
worker_processes `nproc`.to_i+1  # this should be >= nr_cpus
pid "/mnt/lianlian/log/unicorn.pid"
stderr_path "/mnt/lianlian/log/unicorn.log"
stdout_path "/mnt/lianlian/log/unicorn.log"

