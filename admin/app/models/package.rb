class Package < ActiveRecord::Base
  has_many :tenants,:dependent => :destroy
  validates_presence_of :name
  validates_presence_of :category
  validates_presence_of :max_services
  validates_numericality_of :max_services,:greater_than_or_equal_to=>0
  validates_presence_of :max_hosts
  validates_numericality_of :max_hosts,:greater_than_or_equal_to=>0
  validates_presence_of :min_check_interval
  validates_numericality_of :min_check_interval,:greater_than_or_equal_to=>0
  validates_presence_of :charge
  validates_numericality_of :charge,:greater_than_or_equal_to=>0
  validates_presence_of :multi_regional
  validates_presence_of :report
  validates_presence_of :data_retention
  validates_presence_of :year_charge
  validates_numericality_of :year_charge,:greater_than_or_equal_to=>0
  validates_format_of  :name,     :with => Authentication.name_regex,  :message => "不能含有\\/<>&"

  def title
    category == 0 ? name : "#{human_category_name}(#{name})"
  end

  def category_name
    category && self.class.category[category] ? self.class.category[category] : 'free'
  end

  def human_category_name
    I18n.t("package_category.#{category_name}")
  end

  def css_name
    ["yellow", "blue", "green"][category]
  end

  class << self

    def category
      ['free', 'standard', 'enterprise']
    end

  end

end
