module Merb
  module GlobalHelpers
    # helpers defined here available to all views.  

    def form(*args)
      token, timestamp = generate_token
      super(*args).sub(">", ">" +
        hidden_field(:name => "_csrf_token", :value => token) +
        hidden_field(:name => "_csrf_timestamp", :value => timestamp))
    end

    def form_for(*args)
      token, timestamp = generate_token
      super(*args).sub(">", ">" +
        hidden_field(:name => "_csrf_token", :value => token) +
        hidden_field(:name => "_csrf_timestamp", :value => timestamp))
    end
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
