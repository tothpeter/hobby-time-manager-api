module RSpec
  module Expectations
    # @private
    module ExpectationHelper
      def self.handle_failure(matcher, message, failure_message_method)
        if matcher.is_a?(RSpec::Matchers::BuiltIn::Eq) && message.present? && message.is_a?(String)
          message += matcher.__send__(failure_message_method)
        else
          message = message.call if message.respond_to?(:call)
          message ||= matcher.__send__(failure_message_method)
        end

        if matcher.respond_to?(:diffable?) && matcher.diffable?
          ::RSpec::Expectations.fail_with message, matcher.expected, matcher.actual
        else
          ::RSpec::Expectations.fail_with message
        end
      end
    end
  end
end
