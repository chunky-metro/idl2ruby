module Idl2Ruby
  class Generator
    def self.generate(idl)
      new(idl).generate
    end

    def initialize(idl)
      @idl = idl
    end

    def generate
      [
        generate_program_class,
        generate_type_classes,
        generate_instruction_classes,
        generate_account_classes,
        generate_error_module
      ].join("\n\n")
    end

    private

    def generate_program_class
      ProgramClassGenerator.new(@idl).generate
    end

    def generate_type_classes
      TypeClassGenerator.new(@idl.types).generate
    end

    def generate_instruction_classes
      InstructionClassGenerator.new(@idl.instructions).generate
    end

    def generate_account_classes
      AccountClassGenerator.new(@idl.accounts).generate
    end

    def generate_error_module
      ErrorModuleGenerator.new(@idl.errors).generate
    end
  end

  class ProgramClassGenerator
    def initialize(idl)
      @idl = idl
    end

    def generate
      class_name = @idl.metadata.name.split('_').map(&:capitalize).join
      <<-RUBY
        class #{class_name}Program
          attr_reader :address

          def initialize(address)
            @address = address
          end

          #{generate_instruction_methods}
        end
      RUBY
    end

    private

    def generate_instruction_methods
      @idl.instructions.map do |instruction|
        <<-RUBY
          def #{instruction.name.underscore}(#{generate_method_params(instruction)})
            # Implement instruction logic here
          end
        RUBY
      end.join("\n\n")
    end

    def generate_method_params(instruction)
      params = instruction.args.map { |arg| "#{arg.name}: nil" }
      params << "accounts: {}" unless instruction.accounts.empty?
      params.join(", ")
    end
  end

  class TypeClassGenerator
    def initialize(types)
      @types = types
    end

    def generate
      @types.map do |type|
        case type.ty.kind
        when :struct
          generate_struct_class(type)
        when :enum
          generate_enum_class(type)
        else
          # Handle other types if needed
        end
      end.join("\n\n")
    end

    private

    def generate_struct_class(type)
      <<-RUBY
        class #{type.name}
          #{generate_attr_accessors(type.ty.fields)}

          def initialize(#{generate_initialize_params(type.ty.fields)})
            #{generate_initialize_body(type.ty.fields)}
          end
        end
      RUBY
    end

    def generate_enum_class(type)
      <<-RUBY
        class #{type.name}
          #{generate_enum_variants(type.ty.variants)}

          attr_reader :variant, :value

          def initialize(variant, value = nil)
            @variant = variant
            @value = value
          end
        end
      RUBY
    end

    def generate_attr_accessors(fields)
      fields.map { |field| "attr_accessor :#{field.name.underscore}" }.join("\n")
    end

    def generate_initialize_params(fields)
      fields.map { |field| "#{field.name.underscore}: nil" }.join(", ")
    end

    def generate_initialize_body(fields)
      fields.map { |field| "@#{field.name.underscore} = #{field.name.underscore}" }.join("\n")
    end

    def generate_enum_variants(variants)
      variants.map.with_index do |variant, index|
        "#{variant.name.upcase} = #{index}"
      end.join("\n")
    end
  end

  class InstructionClassGenerator
    def initialize(instructions)
      @instructions = instructions
    end

    def generate
      @instructions.map { |instruction| generate_instruction_class(instruction) }.join("\n\n")
    end

    private

    def generate_instruction_class(instruction)
      <<-RUBY
        class #{instruction.name.camelize}Instruction
          attr_reader :program_id, :accounts, :data

          def initialize(program_id, accounts, args)
            @program_id = program_id
            @accounts = accounts
            @data = serialize_data(args)
          end

          private

          def serialize_data(args)
            # TODO: Implement data serialization logic
            args.to_json
          end
        end
      RUBY
    end
  end

  class AccountClassGenerator
    def initialize(accounts)
      @accounts = accounts
    end

    def generate
      @accounts.map { |account| generate_account_class(account) }.join("\n\n")
    end

    private

    def generate_account_class(account)
      <<-RUBY
        class #{account.name.camelize}Account
          attr_reader :address

          def initialize(address)
            @address = address
          end

          def fetch(connection)
            # TODO: Implement account data fetching logic
            raise NotImplementedError, "Account data fetching not implemented"
          end
        end
      RUBY
    end
  end

  class ErrorModuleGenerator
    def initialize(errors)
      @errors = errors
    end

    def generate
      <<-RUBY
        module ProgramErrors
          #{generate_error_constants}

          def self.from_code(code)
            case code
            #{generate_error_cases}
            else
              StandardError.new("Unknown error code: \#{code}")
            end
          end
        end
      RUBY
    end

    private

    def generate_error_constants
      @errors.map do |error|
        "#{error.name.upcase} = #{error.code}"
      end.join("\n")
    end

    def generate_error_cases
      @errors.map do |error|
        <<-RUBY
          when #{error.code}
            StandardError.new("#{error.name}: #{error.msg}")
        RUBY
      end.join("\n")
    end
  end
end