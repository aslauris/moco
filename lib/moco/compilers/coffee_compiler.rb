require 'uri'

module MoCo

  class CoffeeCompiler < JsCompiler

    require_library 'runjs'
    require_library 'coffee_script/source', 'coffee-script-source', '>= 1.6.2'
    register 'coffee'

    include SourceMap

    def self.source_map_key
      :sourceMap
    end

    def self.context
      @context ||= RunJS.context(File.read(CoffeeScript::Source.bundled_path))
    end

    def compiled_text
      compiled_text, @source_map_text = compile_coffee(options)
      compiled_text
    end

    def options
      options = super
      options[:filename] = source_file
      source_map_options(options)
    end

  private

    def context
      self.class.context
    end

    def compile_coffee(options)
      fn = 'CoffeeScript.compile'
      js = context.apply(fn, 'CoffeeScript', source_text, options)
      if options[:sourceMap]
        source_map = js['v3SourceMap']
        js         = js['js'] + source_map_comment
      end
      [js, source_map]
    rescue RunJS::JavaScriptError => e
      raise e, pretty_error_message(e)
    end

    def source_map_comment
      file = URI.escape(File.basename(source_map_file))
      "\n/*\n//@ sourceMappingURL=#{file}\n*/\n"
    end

    def pretty_error_message(error)
      location = error['location']
      return error.message unless location

      line = location['first_line']
      column = location['first_column']
      code = source_text.split(/\n/)[line]

      start = column
      if line == (location['last_line'] || line)
        stop = location['last_column'] || column
        stop += 1
      else
        stop = code.length
      end

      message = error['message']
      message = "#{source_file}:#{line + 1}:#{column + 1}: #{message}"
      code[start...stop] = AnsiEscape.bold_red(code[start...stop])
      mark = (' ' * start) + AnsiEscape.bold_red('^' * (stop - start))

      [message, code, mark].join("\n")
    end

    def source_map_options(options)
      return options unless options[:sourceMap]
      { :generatedFile => File.basename(compiled_file),
        :sourceFiles => [FileUtil.relative_path(source_map_file, source_file)]
      }.merge(options)
    end

  end

end
