module Kraid::Agent
  class AgentError < StandardError; end

  # Thrown when an actor was expected to be running but wasn't
  class NotStartedError < AgentError; end
end
