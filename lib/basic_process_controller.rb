class BasicProcessController 

  def initialize
    @time_started = Time.new.to_i
  end

  def running?
    return true
  end

  def num_processes
    return 1
  end

  def process_started(pid, num_processes) 
    puts "> process started #{pid}; num_processes #{num_processes}"
  end

  def run_process 
    info "#{Process.pid} running"
    exit 0
  end

  def process_ended(pid, status)
    puts "> process ended - pid #{pid}, status #{status}"
  end

  def progress(stats)
    puts "> active #{stats[:active_processes]} started #{stats[:processes_started]} ended #{stats[:processes_ended]} errors #{stats[:errors]}"
  end

  def delay
    return 0.1
  end

  def info(m)
    puts "+ #{m}"
  end

  def time_running
    secs = Time.new.to_i - @time_started
    hours = (secs / (60 * 60)) % 24
    mins = (secs / 60) % 60
    secs = secs % 60

    return "%.2d:%.2d:%.2d" % [hours, mins,secs]
  end


end

