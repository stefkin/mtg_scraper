module MtgScraper::Procify
  def to_proc
    method(:call).to_proc
  end
end
