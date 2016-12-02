class BasicProcessController 

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
    t = rand(5) + 5
    puts "> [#{Process.pid}] child sleeping #{t}"
    sleep t
    s = rand(3)
    puts "> [#{Process.pid}] child exiting #{s}"
    exit s
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

end

