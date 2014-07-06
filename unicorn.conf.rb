# Minimal sample configuration file for Unicorn (not Rack) when used
# with daemonization (unicorn -D) started in your working directory.
#
# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.
# See also http://unicorn.bogomips.org/examples/unicorn.conf.rb for
# a more verbose configuration using more features.

listen "/tmp/unicorn.sock", :backlog => 64
listen "127.0.0.1:8082" # by default Unicorn listens on port 8080
listen "#{`echo -n $ipaddr0`}:8082"
worker_processes `nproc`.to_i+1  # this should be >= nr_cpus
pid "/mnt/lianlian/log/unicorn.pid"
stderr_path "/mnt/lianlian/log/unicorn.log"
stdout_path "/mnt/lianlian/log/unicorn.log"

preload_app true

before_exec do |_|
  ENV["BUNDLE_GEMFILE"] = File.join("/mnt/lianlian/", 'Gemfile')
end

before_fork do |server, worker|
  # 参考 http://unicorn.bogomips.org/SIGNALS.html
  # 使用USR2信号，以及在进程完成后用QUIT信号来实现无缝重启
  old_pid = '/mnt/lianlian/log/unicorn.pid.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end

end

after_fork do |server, worker|
  # 禁止GC，配合后续的OOB，来减少请求的执行时间
  GC.disable
end