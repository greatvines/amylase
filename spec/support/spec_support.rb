module SpecSupport
  def self.wait_for(msg, interval = 0.3, max_iter = 20, &condition)
    iter = 0
    until condition.call || iter >= max_iter
      sleep interval
      iter += 1
    end
    raise "#{msg} wait timed out" if iter >= max_iter
  end
end
