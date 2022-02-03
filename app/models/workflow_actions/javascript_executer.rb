require "execjs"

module WorkflowActions
  class JavascriptExecuter
    attr_reader :js_context

    def initialize(workflow_input_args:, action_results:)
      @js_context = build_js_context(workflow_input_args, action_results)
    end

    def eval(value)
      case value
      when Hash
        value.each do |k, v|
          value[k] = v.gsub(/(\$\{)(.+?)(\})/) { |_| js_context.eval(Regexp.last_match(2)).to_s }
        end
      when String
        value.gsub(/(\$\{)(.+?)(\})/) { |_| js_context.eval(Regexp.last_match(2)).to_s }
      else
        value
      end
    end

    private

    def build_js_context(workflow_input_args, action_results)
      result_js = action_results.map {|k, v| "var #{k} = #{v.to_json};" }.join(' ')

      @js_context = ExecJS.compile("#{result_js} var args = #{workflow_input_args.to_json};")
    end
  end
end