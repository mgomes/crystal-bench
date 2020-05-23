#!/usr/bin/env ruby
def mem(pid); `ps p #{pid} -o rss`.split.last.to_i; end
start_t = Process.clock_gettime(Process::CLOCK_MONOTONIC)
pid = Process.spawn(*ARGV.to_a)
mm = 0

Thread.new do
  mm = mem(pid)
  while true
    sleep 0.3
    m = mem(pid)
    mm = m if m > mm
  end
end

Process.waitall
end_t = Process.clock_gettime(Process::CLOCK_MONOTONIC)
STDERR.puts "== %.2fs, %.1fMb ==" % [end_t - start_t, mm / 1024.0]
