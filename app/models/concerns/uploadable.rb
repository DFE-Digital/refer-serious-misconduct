module Uploadable
  extend ActiveSupport::Concern

  included { has_many :uploads, as: :uploadable }

  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def has_one_uploaded(attr_name)
      define_method("#{attr_name}_upload") { uploads.find_by(section: attr_name) }

      define_method("#{attr_name}_attachment") { send("#{attr_name}_upload").try(:attachment) }
    end
  end
end
