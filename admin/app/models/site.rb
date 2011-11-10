class Site < ActiveRecord::Base
  has_many :services, :conditions => { :serviceable_type => 3 }, :foreign_key => 'serviceable_id', :dependent => :destroy
  has_many :disco_services, :conditions => { :serviceable_type => 3 }, :foreign_key => 'serviceable_id', :dependent => :destroy
  has_many :alerts, :conditions => { :source_type => 3 }, :foreign_key => "source_id", :dependent => :destroy
  has_many :alert_notifications, :conditions => { :source_type => 3 }, :foreign_key => "source_id", :dependent => :destroy

  validates_presence_of :name
  validates_format_of       :name,     :with => Authentication.name_regex,  :message => "不能含有\\/<>&", :allow_nil => true
  validates_length_of       :name,     :maximum => 50
  validates_uniqueness_of :name, :scope => [:tenant_id]
  #validates_format_of :url, :with => /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/
  validates_format_of :url, :with => /^(https?):\/\/[-\w]+(\.\w[-\w]*)+$/

  after_create :gen_ctrl
  after_create :generate_services

  def before_create
    uuid = App.find_by_sql("select uuid() uid from dual")[0].uid
    send("uuid=",uuid)
  end

  def before_save
    uri = URI.parse(url)
    self.addr = uri.host
    self.port = uri.port
    self.path = uri.path + (uri.query ? "?#{uri.query}" : "")
  end

  def ctrl_service
    @ctrl_service || (@ctrl_service = Service.first(:conditions => {:serviceable_type => 3, :serviceable_id => self.id, :ctrl_state => 1}))
  end

  def status_name
    status && self.class.status[status] ? self.class.status[status] : 'pending'
  end

  def human_status_name
    I18n.t("status.site.#{status_name}")
  end

  private
  def generate_services
    #ping service
    generate_service 23
    #dns service
    generate_service 25
  end

  def generate_service type
    service = Service.gen(:type_id => type, :tenant_id => self.tenant_id, :serviceable_id => self.id, :agent_id => self.agent_id)
    service.save
  end

  def gen_ctrl
    #http service
    ctrl = Service.gen(:type_id => 24, :tenant_id => self.tenant_id, :serviceable_id => self.id, :ctrl_state => 1, :agent_id => self.agent_id)  
    ctrl.save
  end

  class << self
    def status
      ['up', 'down', 'pending']
    end

    def status_colors
      ["33FF00", "F83838", "ACACAC"]
    end
  end

end
