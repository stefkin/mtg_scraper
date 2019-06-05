module MtgScraper::Retryable
  module_function

  def call(link, attempts = 5, timeout = 10, &block)
    block.call
  rescue StandardError => e
    puts e.message
    puts e.backtrace
    puts "retrying in #{timeout} sec. #{attempts} attempts left"
    sleep timeout
    if attempts > 1
      call(link, attempts - 1, timeout, &block)
    else
      File.write('failures2.org', link, File.size('failures2.org'), mode: 'a')
    end
  end
end
