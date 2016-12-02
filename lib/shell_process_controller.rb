class SpawningProcessController < BasicProcessController

  def initialize(script, logdir)
    @script = script
    @logdir = logdir
  end

  def run_process

    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    pid = Process.pid
 
    stdout_file = "#{@logdir}/process_#{pid}_#{timestamp}.stdout"
    stderr_file = "#{@logdir}/process_#{pid}_#{timestamp}.stderr"
    stdin_file = "/dev/null"

    begin
      if system("#{@script} > #{stdout_file} 2> #{stderr_file} < #{stdin_file}")
        exit(0)
      else
        exit(1)
      end
    rescue => e
      err.write("cannot spawn #{@script}, exception #{e}")
      exit(1)
    end

  end
end
