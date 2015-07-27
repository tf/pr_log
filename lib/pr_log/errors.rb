module PrLog
  class Error < StandardError
  end

  class InsertPointNotFound < Error
  end

  class ChangelogFileNotFound < Error
  end

  class GemspecNotFound < Error
  end

  class GithubRepositoryRequired < Error
  end

  class NonGithubHomepage < Error
  end

  class NoPullRequestsForMilestone < Error
  end
end
