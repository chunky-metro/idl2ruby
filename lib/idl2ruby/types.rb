require 'data'

module Idl2Ruby
  module Idl
    Base = Data.define(:address, :metadata, :docs, :instructions, :accounts, :events, :errors, :types, :constants)
    Metadata = Data.define(:name, :version, :spec, :description, :repository, :dependencies, :contact, :deployments)
    Instruction = Data.define(:name, :docs, :discriminator, :accounts, :args, :returns)
    InstructionAccount = Data.define(:name, :docs, :writable, :signer, :optional, :address, :pda, :relations)
    InstructionAccounts = Data.define(:name, :accounts)
    Field = Data.define(:name, :docs, :ty)
    Account = Data.define(:name, :discriminator, :ty)
    Event = Data.define(:name, :discriminator, :fields)
    ErrorCode = Data.define(:code, :name, :msg)
    TypeDef = Data.define(:name, :docs, :serialization, :repr, :generics, :ty)
    Serialization = Data.define(:kind, :custom)
    Repr = Data.define(:kind, :packed, :align)
    Generic = Data.define(:kind, :name, :ty)
    Struct = Data.define(:fields)
    Enum = Data.define(:variants)
    Union = Data.define(:variants)
    Array = Data.define(:element_ty, :size)
    Vector = Data.define(:element_ty)
    Option = Data.define(:element_ty)
    Primitive = Data.define(:kind)
    Custom = Data.define(:name)
    Const = Data.define(:name, :docs, :ty, :value)
    Pda = Data.define(:seeds, :program)
    SeedConst = Data.define(:value)
    SeedArg = Data.define(:path)
    SeedAccount = Data.define(:path, :account)

    class Accounts
      def initialize(accounts)
        @accounts = accounts.map { |account| Account.new(account) }
      end
    end
  end
end