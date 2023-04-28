# Including these modules in a class will allow you to define attributes that will
# return the value of the instance variable if it exists, or will try to get the value
# from the object (referral, organisation, referrer).
#
# E.g. attr_referral :name, :email will define methods #name and #email that will
# return the value of @name and @email if defined, or try to get the value from
# referral.name and referral.email otherwise.

module CustomAttrs
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def attr_referral(*args)
      attr_object(:referral, *args)
    end

    def attr_organisation(*args)
      attr_object(:organisation, *args)
    end

    def attr_referrer(*args)
      attr_object(:referrer, *args)
    end

    def attr_object(obj, *args)
      args.each do |attr_name|
        inst_variable_name = "@#{attr_name}".to_sym
        define_method(attr_name) do
          var = instance_variable_get(inst_variable_name)

          return var unless var.nil?

          attr_value = try(obj).try(attr_name)
          instance_variable_set(inst_variable_name, attr_value)
          attr_value
        end
      end
    end
  end
end
