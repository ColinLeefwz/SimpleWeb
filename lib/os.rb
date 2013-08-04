class Os

=begin
MemTotal:       33011208 kB 0
MemFree:          462076 kB 1
Buffers:          280300 kB 2
Cached:         21867716 kB 3
SwapCached:            0 kB 4
Active:         15713580 kB 5
Inactive:       15343876 kB 6
Active(anon):    7916544 kB 7
Inactive(anon):  1014416 kB 8
Active(file):    7797036 kB 9
Inactive(file): 14329460 kB 10
Unevictable:           0 kB 11
Mlocked:               0 kB 12
SwapTotal:             0 kB 13
=end
  
  def self.overload?(load_factor=1)
    load = `nproc`.to_i * load_factor
    cur_load > load
  end
  
  def self.cur_load
    `cat /proc/loadavg`.split(" ")[0].to_f
  end

  # Active / Cached / MemFree / SwapTotal in MB
  def self.mem
	arr = `cat /proc/meminfo | head -n 14 | awk '{print $2}'`.split
	ret = [arr[5],arr[3],arr[1],arr[13]]
	ret.map! {|x| x.to_i/1000}
	return ret
  end


=begin
  21393697606 pages paged in
   4459683716 pages paged out
            0 pages swapped in
            0 pages swapped out
   3625213195 interrupts
    232121069 CPU context switches
   1260255789 boot time
     86065499 forks
=end

  # page in / page out, 1000
  def self.page_io
	ret = `vmstat -s | tail -n 8 | head -n 2 | awk '{print $1}'`.split
	ret.map! {|x| x.to_i/1000}
	return ret
  end



=begin
Inter-|   Receive                                                |  Transmit
 face |bytes    packets errs drop fifo frame compressed multicast|bytes    packets errs drop fifo colls carrier compressed
    lo:10700151561930 7034132632    0    0    0     0          0         0 10700151561930 7034132632    0    0    0     0       0          0
  eth0:21640669318499 31571567918   14  224    0    14          0         6 13083258233549 31800252573    0    0    0     0       0          0
  eth1:1199739053814 8497827603    0    0    0     0          0         6 13129595212572 10937582415    0    0    0     0       0          0
=end

  # Receive / Transmit in kB
  def self.net_io
	begin
		arr = `cat /proc/net/dev | tail -n 1`.split
		arr[0] = arr[0].split(":").last
		ret = [arr[0],arr[8]]
		ret.map! {|x| x.to_i/1000}
		return ret
	rescue Exception => error
		return [-1,-1]
	end
  end

  def self.disk_remain
	`df | head -n 2 | tail -n 1 | awk '{print $4}'`.to_i
  end

  def self.cpu_load
	arr = `uptime`.split(",")
	arr[arr.length-2].to_f
  end


  def self.netstat
	states = []
	ss = `netstat -na`.split(/[\r|\n]+/)
	ss.each_with_index do |line,i|
		next if i<2
		break unless line.start_with? "tcp"
		states << line.split[5]
	end
	return states.group_by {|x| x}.map {|arr| [arr[0],arr[1].length]}
  end


end
