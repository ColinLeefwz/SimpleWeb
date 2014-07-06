=begin  
 file lock for inter-process sync.  
 usage:  
  FSLock('mylock') do  
    # protected by lock,  
    # do your job here ...  
  end  
=end   
class FSLock  
  def initialize(name=nil)  
    name ||= 'global'  
    @fname = name + '.lock'  
    if block_given?  
      lock()  
      begin  
        yield  
      ensure  
        unlock()  
      end  
    end  
  end  
  
  def critical  
    lock()  
    begin  
      yield() if block_given?  
    ensure  
      unlock()  
    end  
  end  
  
  def lock  
    @f = File.new(@fname, "ab")  
    @f.flock(File::LOCK_EX) if @f  
  end  
  
  def unlock  
    @f.close if @f  
  end  
end  
