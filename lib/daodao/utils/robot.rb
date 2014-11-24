#!/usr/bin/env ruby

module Util

  class Robot
    def initialize( worker_count, min_sleep_time, max_sleep_time)
      @worker_count = worker_count
      @requester = Util::HttpRequester.new
      @min_sleep_time = min_sleep_time
      @max_sleep_time = max_sleep_time
    end

    def start()
      @stopped = false

      @threads = Robot.newthreads(@worker_count, self, :job)
    end

    def stop
      @stopped = true
    end

    def job
      #do somethinf
    end
  end

  def self.newthreads(count, obj, method_name)
    threads = []

    i = 0
    while i < count
      t = Thread.new do
        obj.send(method_name)
      end

      threads << t
      i += 1
    end

    return threads
  end

end
