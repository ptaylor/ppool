
Gem::Specification.new do |s|
  s.name        = 'ppool'
  s.version     = '1.0.0'
  s.date        = '2016-11-30'
  s.summary     = "Process pool"
  s.description = "Run a pool of processes"
  s.authors     = ["Paul Taylor"]
  s.email       = 'pftylr@gmail.com'
  s.files       = [
                  "lib/ppool.rb",
  		  "lib/process_pool.rb",
  		  "lib/basic_process_controller.rb",
  		  "lib/shell_process_controller.rb",
  		  "lib/terminal_process_controller.rb",
  		  "lib/curses_process_controller.rb"
		]
  s.executables << 'ppool'
  s.add_runtime_dependency "curses", ['~> 1.0']
  s.homepage    =  'http://rubygems.org/gems/ppool'
  s.license     = 'MIT'
end
