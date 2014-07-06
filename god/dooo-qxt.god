
God.watch do |w|
  w.dir      = "/home/dooo/bodu_server/qxt/bin"
  w.name     = "qxt"
  w.group    = 'dooo'
  w.interval = 30.seconds
  w.start    = "/java/jdk/bin/java -cp ../lib/commons-lang-1.0.1.jar:../lib/commons-logging.jar:../lib/commons.jar:../lib/log4j-1.2.7.jar:../lib/log4j.properties:../lib/MobileOpenSDK.jar:../lib/mysql-connector-java-3.1.8-bin.jar:.  -Dfile.encoding=GBK dooo.QxtServer"
  w.keepalive

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
