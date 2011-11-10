class Trend

  def self.area_select(object,current_user)
     if object.to_i==1
        @instances=Host.all :conditions=>{:tenant_id => current_user.tenant_id}
      end

      if object.to_i==2
        @instances=App.all :conditions=>{:tenant_id => current_user.tenant_id}
      end

      if object.to_i==3
        @instances=Site.all :conditions=>{:tenant_id => current_user.tenant_id}
      end

      if object.to_i==4
        @instances=Device.all :conditions=>{:tenant_id => current_user.tenant_id}
      end     

    return @instances
  end

end
