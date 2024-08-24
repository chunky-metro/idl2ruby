require "json"

module Idl2Ruby
  class Parser
    def self.parse(json)
      new(json).parse
    end

    def initialize(json)
      @idl_hash = JSON.parse(json, symbolize_names: true)
    end

    def parse
      Idl.new(
        address: Idl::Address.new(@idl_hash[:address]),
        metadata: Idl::Metadata.new(@idl_hash[:metadata]),
        docs: Idl::Docs.new(@idl_hash[:docs]),
        instructions: Idl::Instructions.new(@idl_hash[:instructions]),
        accounts: Idl::Accounts.new(@idl_hash[:accounts]),
        events: Idl::Events.new(@idl_hash[:events]),
        errors: Idl::Errors.new(@idl_hash[:errors]),
        types: Idl::Types.new(@idl_hash[:types]),
        constants: Idl::Constants.new(@idl_hash[:constants])
      )
    end
  end

end