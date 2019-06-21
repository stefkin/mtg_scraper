# typed: true
module MtgScraper::Procify
  include Kernel

  def to_proc
    method(:call).to_proc
  end
end
