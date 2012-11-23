rails_env   = ENV['RAILS_ENV']  || "production"
rails_root  = ENV['RAILS_ROOT'] || "/mnt/lianlian"

[['xmpp',0.1,1],['*',5,2]].each do |queue,inteval,num_workers|
num_workers.times do |num|
  God.watch do |w|
    w.dir      = "#{rails_root}"
    w.log = "#{rails_root}/log/god.log"
    w.name     = "resque-#{queue}#{num}"
    w.group    = 'resque'
    w.interval = 30.seconds
    w.env      = {"QUEUE"=>queue, "RAILS_ENV"=>rails_env}
    w.start    = "INTERVAL=#{inteval} QUEUE='#{queue}' rake -f #{rails_root}/Rakefile environment resque:work"

#    w.uid = 'dooo'
#    w.gid = 'dooo'

    # restart if memory gets too high
    w.transition(:up, :restart) do |on|
      on.condition(:memory_usage) do |c|
        c.above = 350.megabytes
        c.times = 2
      end
    end

    # determine the state on startup
    w.transition(:init, { true => :up, false => :start }) do |on|
      on.condition(:process_running) do |c|
        c.running = true
      end
    end

    # determine when process has finished starting
    w.transition([:start, :restart], :up) do |on|
      on.condition(:process_running) do |c|
        c.running = true
        c.interval = 5.seconds
      end

      # failsafe
      on.condition(:tries) do |c|
        c.times = 5
        c.transition = :start
        c.interval = 5.seconds
      end
    end

    # start if process is not running
    w.transition(:up, :start) do |on|
      on.condition(:process_running) do |c|
        c.running = false
      end
    end
  end
end
end
