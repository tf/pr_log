module PrLog
  class Error < StandardError
  end

  class InsertPointNotFound < Error
  end

  class ChangelogFileNotFound < Error
  end
end
