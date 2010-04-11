module Merb
  module GlobalHelpers
    # helpers defined here available to all views.  
  end

  module Helpers
    module Form
      def error_messages_for(obj = nil, opts = {})
        current_form_context.error_messages_for(obj, opts[:error_class] || "error",
          opts[:build_li] || "<li>%s</li>",
          opts[:header] || '',
          opts.key?(:before) ? opts[:before] : true)
      end
    end
  end
end
