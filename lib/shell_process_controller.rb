class SpawningProcessController < BasicProcessController

  def initialize(script, logdir)
    @script = script
    @logdir = logdir
  end

  def run_process

    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    pid = Process.pid
 
    stdout = "#{@logdir}/process_#{pid}_#{timestamp}.stdout"
    stderr = "#{@logdir}/process_#{pid}_#{timestamp}.stderr"
    stdin = "/dev/null"

    exec("#{@script} > #{stdout} 2> #{stderr} < #{stdin}")

  end
end
