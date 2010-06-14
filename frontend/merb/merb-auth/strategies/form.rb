class Merb::Authentication
  module Strategies
    module Basic
      class Form < Base
        def strategy_error_message
          "Nieprawidłowy login lub hasło."
        end
      end
    end
  end
end
