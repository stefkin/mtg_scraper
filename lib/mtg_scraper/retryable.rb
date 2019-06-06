module MtgScraper::Retryable
  module_function

  def call(link, attempts = 5, timeout = 10, on_failure:, &block)
    block.call
  rescue StandardError => e
    puts e.message
    puts e.backtrace
    puts "retrying in #{timeout} sec. #{attempts} attempts left"
    sleep timeout
    if attempts > 1
      call(link, attempts - 1, timeout, &block)
    else
      on_failure.call
    end
  end
end
