#
# MIT License
#
# Copyright (c) 2016 Paul Taylor
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

Gem::Specification.new do |s|
  s.name        = 'ppool'
  s.version     = '1.2.1'
  s.date        = '2016-12-05'
  s.summary     = "Pool of processes running a single command"
  s.description = "Start of pool of processes running a single command and control the pool size via the keyboard."
  s.author      = "Paul Taylor"
  s.email       = 'pftylr@gmail.com'
  s.homepage    = 'https://github.com/ptaylor/ppool'
  s.files       = [
                  "lib/ppool.rb",
  		  "lib/process_pool_util.rb",
  		  "lib/process_pool.rb",
  		  "lib/basic_process_controller.rb",
  		  "lib/shell_process_controller.rb",
  		  "lib/timed_process_controller.rb",
  		  "lib/terminal_process_controller.rb",
  		  "lib/curses_process_controller.rb"
		]
  s.executables << 'ppool'

  s.add_runtime_dependency "curses", ['~> 1.0']
  s.add_development_dependency "bundler", "~> 1.13"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec", "~> 3.0"

  s.homepage    =  'http://rubygems.org/gems/ppool'
  s.license     = 'MIT'
  s.required_ruby_version = ['~> 2.0']
end
