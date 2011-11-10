module ActionController
  class Base
    @@tenant_aware_models = nil

    def reset_tenant
      unless @@tenant_aware_models.nil?
        @@tenant_aware_models.each() { |model|
          # 将当前ActionController 中Tenant 设置到指定的Model 中。
          if self.respond_to?(:current_tenant)
            class << model
              # 重命名add_conditions! 方法，主要为能够为每次查询都能增加tenant_id 属性
              alias :add_conditions_without_tenant :add_conditions!
              include TenantAware::ActiveRecord
            end
            model.send(:define_method, :attach_tenant) do
              tenant = self.class.send(:tenant)
              self.tenant_id = tenant.id unless tenant.nil?
            end
            model.send(:before_create, :attach_tenant)
            model.tenant = self.send(:current_tenant)
            model.establish_connection_with_tenant
          end
        }
      end
    end
  
    class << self
      def tenant_aware(*models)
        @@tenant_aware_models = models
      end
    end
  end
end