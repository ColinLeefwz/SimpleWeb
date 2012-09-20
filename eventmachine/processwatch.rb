require 'eventmachine'

module ProcessWatcher
  def process_exited
    put 'the forked child died!'
  end
end

pid = fork{ sleep }

EM.run{
  EM.watch_process(pid, ProcessWatcher)
  EM.add_timer(1){ Process.kill('TERM', pid) }
}