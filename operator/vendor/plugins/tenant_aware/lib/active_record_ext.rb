module TenantAware
  module ActiveRecord    
    @@tenant = nil
    mattr_accessor :tenant
    
    def establish_connection_with_tenant
      unless @@tenant.nil?
        establish_connection({
            "adapter" => "mysql",
            "encoding" => "utf8",
            "host" => @@tenant.db_host,
            "database" => @@tenant.db_name,
            "port" => @@tenant.port,
            "username" => @@tenant.username,
            "password" => Base64.decode64(@@tenant.password)
          })
      end
    end
    
    def add_conditions!(sql, conditions, scope = :auto)
      unless @@tenant.nil?
        if(conditions.nil? || conditions.empty?)
          conditions = ["#{quoted_table_name}.tenant_id = ?", @@tenant.id]
        elsif(conditions.is_a?(Array))
          conditions = conditions.compact
          and_operator = conditions[0].blank? ? "" : " AND "
          conditions[0] = "(#{conditions[0]})" + and_operator + "#{quoted_table_name}.tenant_id = ?"
          conditions << @@tenant.id
        elsif(conditions.is_a?(Hash))
          conditions[:tenant_id] = @@tenant.id
        end
      end
      add_conditions_without_tenant(sql, conditions, scope)
    end

  end
end