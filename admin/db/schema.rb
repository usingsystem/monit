# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100712085806) do

  create_table "accounts", :force => true do |t|
    t.integer  "tenant_id"
    t.integer  "package_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "agents", :force => true do |t|
    t.string   "username",   :limit => 50
    t.string   "password",   :limit => 40
    t.string   "name",       :limit => 50
    t.integer  "tenant_id"
    t.integer  "host_id"
    t.string   "presence",   :limit => 40,  :default => "unavailable"
    t.string   "summary",    :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "agents", ["username"], :name => "username"

  create_table "alert_notifications", :force => true do |t|
    t.integer  "method"
    t.integer  "user_id"
    t.integer  "alert_id"
    t.string   "alert_name",                  :limit => 100
    t.integer  "alert_severity"
    t.integer  "alert_status"
    t.integer  "alert_last_status"
    t.string   "alert_summary"
    t.integer  "service_id"
    t.integer  "source_id"
    t.integer  "source_type"
    t.integer  "tenant_id"
    t.integer  "status",                                     :default => 0
    t.datetime "last_notification"
    t.integer  "current_notification_number",                :default => 0
    t.datetime "occured_at"
    t.datetime "changed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "alerts", :force => true do |t|
    t.string   "name",        :limit => 50
    t.integer  "service_id"
    t.integer  "source_id"
    t.integer  "source_type"
    t.integer  "tenant_id"
    t.integer  "severity",                   :default => 0
    t.integer  "status",                     :default => 0
    t.integer  "status_type"
    t.integer  "last_status",                :default => 0
    t.integer  "ctrl_state",  :limit => 1
    t.string   "summary",     :limit => 200
    t.integer  "occur_count"
    t.datetime "last_check"
    t.datetime "next_check"
    t.datetime "occured_at"
    t.datetime "changed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "alerts", ["service_id"], :name => "i_alerts_service_id"

  create_table "app_types", :force => true do |t|
    t.string   "name",       :limit => 100
    t.integer  "parent_id"
    t.integer  "level"
    t.integer  "creator"
    t.string   "remark",     :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "apps", :force => true do |t|
    t.string   "name",                        :limit => 50
    t.string   "tag",                         :limit => 50
    t.string   "uuid",                        :limit => 50,  :default => "uuid()"
    t.integer  "host_id"
    t.integer  "tenant_id"
    t.integer  "agent_id"
    t.integer  "type_id"
    t.integer  "port"
    t.string   "login_name",                  :limit => 50
    t.string   "sid",                         :limit => 50
    t.string   "password",                    :limit => 50
    t.string   "status_url",                  :limit => 50
    t.integer  "discovery_state",                            :default => 0
    t.datetime "last_check"
    t.datetime "next_check"
    t.integer  "duration"
    t.integer  "status",                                     :default => 2
    t.string   "summary",                     :limit => 200
    t.datetime "last_update"
    t.datetime "last_time_up"
    t.datetime "last_time_down"
    t.datetime "last_time_pending"
    t.datetime "last_time_unknown"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_notification"
    t.integer  "current_notification_number",                :default => 0
    t.integer  "notifications_enabled",       :limit => 1,   :default => 1
    t.integer  "first_notification_delay",                   :default => 300
    t.integer  "notification_interval",                      :default => 7200
    t.integer  "notification_times",                         :default => 1
    t.integer  "notify_on_recovery",          :limit => 1,   :default => 1
    t.integer  "notify_on_down",              :limit => 1,   :default => 1
  end

  create_table "bills", :force => true do |t|
    t.integer  "tenant_id"
    t.integer  "operator_id"
    t.decimal  "amount",      :precision => 9, :scale => 2
    t.decimal  "balance",     :precision => 9, :scale => 2
    t.string   "summary"
    t.datetime "begin_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "type_id",                                   :default => 0
  end

  create_table "business", :force => true do |t|
    t.string   "name",               :limit => 50
    t.integer  "tenant_id"
    t.integer  "parent_id"
    t.string   "remark",             :limit => 100
    t.datetime "last_check"
    t.datetime "next_check"
    t.integer  "duration"
    t.integer  "avail_status"
    t.string   "summary",            :limit => 200
    t.datetime "last_time_ok"
    t.datetime "last_time_warning"
    t.datetime "last_time_critical"
    t.datetime "last_time_unknown"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid",               :limit => 50
  end

  create_table "business_services", :id => false, :force => true do |t|
    t.integer "business_id"
    t.integer "service_id"
  end

  create_table "checked_status", :id => false, :force => true do |t|
    t.integer  "service_id"
    t.string   "uuid",             :limit => 50
    t.integer  "status"
    t.string   "summary",          :limit => 200
    t.integer  "last_check",       :limit => 8,   :null => false
    t.integer  "next_check",       :limit => 8,   :null => false
    t.integer  "status_type"
    t.integer  "duration"
    t.integer  "latency"
    t.integer  "current_attempts"
    t.integer  "oper_tag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checked_status", ["service_id"], :name => "i_checked_status_service_id", :unique => true
  add_index "checked_status", ["uuid"], :name => "i_checked_status_uuid"

  create_table "device_types", :force => true do |t|
    t.string   "name",       :limit => 50
    t.integer  "parent_id"
    t.integer  "level"
    t.integer  "creator"
    t.string   "remark",     :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "devices", :force => true do |t|
    t.string   "name",                        :limit => 50
    t.string   "tag",                         :limit => 50
    t.string   "model",                       :limit => 50
    t.string   "mac",                         :limit => 20
    t.string   "os_desc",                     :limit => 50
    t.string   "addr",                        :limit => 50,                    :null => false
    t.string   "uuid",                        :limit => 50
    t.integer  "tenant_id"
    t.integer  "agent_id"
    t.integer  "is_support_snmp"
    t.integer  "type_id"
    t.integer  "port"
    t.string   "snmp_ver",                    :limit => 20
    t.string   "community",                   :limit => 20
    t.integer  "discovery_state",                            :default => 0
    t.datetime "last_check"
    t.datetime "next_check"
    t.integer  "duration"
    t.integer  "status",                                     :default => 2,    :null => false
    t.string   "summary",                     :limit => 200
    t.datetime "last_time_up"
    t.datetime "last_time_down"
    t.datetime "last_time_pending"
    t.datetime "last_time_unknown"
    t.datetime "last_time_unreachable"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_notification"
    t.integer  "current_notification_number",                :default => 0
    t.integer  "notifications_enabled",       :limit => 1,   :default => 1
    t.integer  "first_notification_delay",                   :default => 300
    t.integer  "notification_interval",                      :default => 7200
    t.integer  "notification_times",                         :default => 1
    t.integer  "notify_on_recovery",          :limit => 1,   :default => 1
    t.integer  "notify_on_down",              :limit => 1,   :default => 1
    t.integer  "notify_on_unreachable",       :limit => 1,   :default => 1
  end

  create_table "disco_services", :force => true do |t|
    t.string   "name",             :limit => 50
    t.integer  "serviceable_type"
    t.integer  "serviceable_id"
    t.integer  "tenant_id"
    t.integer  "agent_id"
    t.integer  "type_id"
    t.string   "params",           :limit => 200
    t.string   "command",          :limit => 100
    t.string   "summary",          :limit => 200
    t.string   "desc",             :limit => 200
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "disco_services", ["serviceable_type", "serviceable_id", "command", "params"], :name => "service_command_params", :unique => true

  create_table "disco_types", :force => true do |t|
    t.string   "name",         :limit => 100
    t.integer  "object_class",                :default => 1
    t.integer  "object_type"
    t.integer  "method"
    t.string   "command",      :limit => 100
    t.string   "args"
    t.integer  "service_type"
    t.integer  "external",                    :default => 1
    t.string   "remark",       :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "host_types", :force => true do |t|
    t.string   "name",       :limit => 50
    t.integer  "parent_id"
    t.integer  "level"
    t.integer  "creator"
    t.string   "remark",     :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hosts", :force => true do |t|
    t.string   "name",                        :limit => 50
    t.string   "tag",                         :limit => 50
    t.string   "model",                       :limit => 50
    t.string   "mac",                         :limit => 20
    t.string   "os_desc",                     :limit => 50
    t.string   "addr",                        :limit => 50,                    :null => false
    t.string   "uuid",                        :limit => 50
    t.integer  "tenant_id"
    t.integer  "agent_id"
    t.integer  "is_support_remote"
    t.integer  "is_support_snmp"
    t.integer  "is_support_ssh"
    t.integer  "type_id"
    t.integer  "port"
    t.string   "snmp_ver",                    :limit => 20
    t.string   "community",                   :limit => 20
    t.integer  "discovery_state",                            :default => 0
    t.datetime "last_check"
    t.datetime "next_check"
    t.integer  "duration"
    t.integer  "status",                                     :default => 2
    t.string   "summary",                     :limit => 200
    t.datetime "last_time_up"
    t.datetime "last_time_down"
    t.datetime "last_time_pending"
    t.datetime "last_time_unknown"
    t.datetime "last_time_unreachable"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_notification"
    t.integer  "current_notification_number",                :default => 0
    t.integer  "notifications_enabled",       :limit => 1,   :default => 1
    t.integer  "first_notification_delay",                   :default => 300
    t.integer  "notification_interval",                      :default => 7200
    t.integer  "notification_times",                         :default => 1
    t.integer  "notify_on_recovery",          :limit => 1,   :default => 1
    t.integer  "notify_on_down",              :limit => 1,   :default => 1
    t.integer  "notify_on_unreachable",       :limit => 1,   :default => 0
  end

  create_table "idea_comments", :force => true do |t|
    t.integer  "idea_id"
    t.integer  "user_id"
    t.binary   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "idea_types", :force => true do |t|
    t.string   "name",       :limit => 100
    t.string   "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "idea_votes", :force => true do |t|
    t.integer  "idea_id"
    t.integer  "user_id"
    t.integer  "num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ideas", :force => true do |t|
    t.integer  "type_id"
    t.integer  "user_id"
    t.string   "title",      :limit => 500
    t.binary   "content"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invite_codes", :force => true do |t|
    t.string   "code"
    t.integer  "user_id"
    t.string   "user_name"
    t.integer  "status",     :limit => 1, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locales", :force => true do |t|
    t.string   "country",    :limit => 20
    t.string   "language",   :limit => 20
    t.string   "res",        :limit => 100
    t.string   "string",     :limit => 300
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logm_operations", :force => true do |t|
    t.string   "sessions",    :limit => 50
    t.integer  "user_id"
    t.string   "user_name",   :limit => 100
    t.string   "action",      :limit => 100
    t.string   "result",      :limit => 100
    t.string   "details",     :limit => 100
    t.string   "module_name", :limit => 10
    t.string   "terminal_ip", :limit => 20
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "logm_securities", :force => true do |t|
    t.string   "session",         :limit => 50
    t.integer  "user"
    t.string   "user_name"
    t.string   "terminal_ip"
    t.string   "host_name"
    t.string   "security_cause"
    t.string   "details"
    t.string   "affected_user"
    t.string   "security_action"
    t.string   "result"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.integer  "method"
    t.string   "address"
    t.integer  "user_id"
    t.string   "contact"
    t.integer  "type_id"
    t.integer  "tenant_id"
    t.integer  "status",                    :default => 0
    t.string   "title",      :limit => 100
    t.string   "summary"
    t.binary   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "object_changed", :force => true do |t|
    t.integer  "agent_id"
    t.integer  "object_class"
    t.integer  "object_id"
    t.string   "uuid",            :limit => 50
    t.integer  "oper_type"
    t.integer  "discovery_state"
    t.string   "addr",            :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "operators", :force => true do |t|
    t.string   "host",                                                                                       :null => false
    t.string   "title",                                                                                      :null => false
    t.string   "logo_url"
    t.string   "biglogo_url"
    t.text     "footer"
    t.text     "descr"
    t.string   "telphone"
    t.string   "contact"
    t.string   "email"
    t.string   "remember_token",            :limit => 40
    t.string   "crypted_password"
    t.string   "salt"
    t.date     "activated_at"
    t.string   "activation_code"
    t.string   "company",                   :limit => 100
    t.boolean  "is_support_bank",                                                         :default => false
    t.string   "bank",                      :limit => 100
    t.string   "bank_account_name",         :limit => 100
    t.string   "bank_account",              :limit => 50
    t.string   "bank_tax_number",           :limit => 50
    t.string   "bank_payment_number",       :limit => 50
    t.boolean  "is_support_alipay",                                                       :default => false
    t.string   "alipay_email"
    t.string   "alipay_partner"
    t.string   "alipay_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "remember_token_expires_at"
    t.text     "page_contact"
    t.text     "page_about"
    t.decimal  "amount",                                   :precision => 10, :scale => 1
  end

  add_index "operators", ["host"], :name => "index_operators_on_host"

  create_table "orders", :force => true do |t|
    t.integer  "tenant_id",                                                                            :null => false
    t.integer  "package_id"
    t.integer  "month_num"
    t.string   "out_trade_no",         :limit => 50
    t.decimal  "total_fee",                           :precision => 9, :scale => 2
    t.string   "body"
    t.string   "subject",              :limit => 500
    t.integer  "status",                                                            :default => 0
    t.boolean  "is_paid",                                                           :default => false
    t.integer  "pay_mode"
    t.datetime "paid_at"
    t.text     "paid_desc"
    t.string   "trade_no",             :limit => 50
    t.boolean  "is_support_alipay"
    t.text     "alipay_notify_params"
    t.text     "alipay_return_params"
    t.text     "alipay_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "packages", :force => true do |t|
    t.integer  "operator_id"
    t.integer  "category"
    t.string   "name"
    t.integer  "charge"
    t.integer  "year_charge"
    t.integer  "year_discount",      :default => 0
    t.integer  "year_discount_rate"
    t.integer  "max_hosts"
    t.integer  "max_services"
    t.integer  "min_check_interval", :default => 300
    t.string   "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "preferences", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "owner_id",   :null => false
    t.string   "owner_type", :null => false
    t.integer  "group_id"
    t.string   "group_type"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "preferences", ["owner_id", "owner_type", "name", "group_id", "group_type"], :name => "index_preferences_on_owner_and_name_and_preference", :unique => true

  create_table "roster_version", :primary_key => "username", :force => true do |t|
    t.text "version", :null => false
  end

  create_table "rostergroups", :id => false, :force => true do |t|
    t.string "username", :limit => 250, :null => false
    t.string "jid",      :limit => 250, :null => false
    t.text   "grp",                     :null => false
  end

  add_index "rostergroups", ["username", "jid"], :name => "pk_rosterg_user_jid"

  create_table "rosterusers", :force => true do |t|
    t.string    "username",     :limit => 250, :null => false
    t.string    "jid",          :limit => 250, :null => false
    t.text      "nick",                        :null => false
    t.string    "subscription", :limit => 1,   :null => false
    t.string    "ask",          :limit => 1,   :null => false
    t.text      "askmessage",                  :null => false
    t.string    "server",       :limit => 1,   :null => false
    t.text      "subscribe",                   :null => false
    t.text      "type"
    t.timestamp "created_at",                  :null => false
  end

  add_index "rosterusers", ["jid"], :name => "i_rosteru_jid"
  add_index "rosterusers", ["username", "jid"], :name => "i_rosteru_user_jid", :unique => true
  add_index "rosterusers", ["username"], :name => "i_rosteru_username"

  create_table "service_metrics", :force => true do |t|
    t.integer  "type_id"
    t.string   "name",        :limit => 50
    t.string   "metric_type", :limit => 50
    t.string   "unit",        :limit => 20
    t.string   "calc",        :limit => 50
    t.string   "desc",        :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "group",       :limit => 50
  end

  create_table "service_params", :force => true do |t|
    t.integer  "type_id"
    t.string   "name",          :limit => 100
    t.string   "alias",         :limit => 100
    t.string   "default_value", :limit => 100
    t.integer  "param_type"
    t.string   "unit",          :limit => 20
    t.integer  "required",                     :default => 0
    t.string   "desc",          :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_types", :force => true do |t|
    t.string   "name",               :limit => 100
    t.string   "default_name",       :limit => 100
    t.string   "alias",              :limit => 100
    t.integer  "check_type"
    t.integer  "disco_type",                        :default => 0
    t.string   "command",            :limit => 100
    t.integer  "multi_services",                    :default => 0
    t.integer  "ctrl_state",                        :default => 0
    t.integer  "external",                          :default => 1
    t.integer  "check_interval"
    t.integer  "metric_id"
    t.integer  "serviceable_type"
    t.integer  "serviceable_id"
    t.string   "threshold_warning",  :limit => 200
    t.string   "threshold_critical", :limit => 200
    t.integer  "disco_auto",                        :default => 0
    t.integer  "creator"
    t.string   "remark",             :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", :force => true do |t|
    t.string   "name",                        :limit => 50
    t.string   "uuid",                        :limit => 50
    t.integer  "serviceable_type"
    t.integer  "serviceable_id"
    t.integer  "ctrl_state",                                  :default => 0
    t.integer  "external",                                    :default => 1
    t.integer  "tenant_id"
    t.integer  "agent_id"
    t.integer  "type_id"
    t.string   "command",                     :limit => 100
    t.string   "params",                      :limit => 200
    t.integer  "check_interval"
    t.string   "desc",                        :limit => 200
    t.integer  "is_collect",                                  :default => 1
    t.datetime "last_check"
    t.datetime "next_check"
    t.integer  "max_attempts",                                :default => 3
    t.integer  "attempt_interval",                            :default => 30
    t.integer  "current_attempts"
    t.integer  "latency"
    t.integer  "duration"
    t.integer  "status",                                      :default => 4
    t.integer  "status_type",                                 :default => 2
    t.string   "summary",                     :limit => 1000
    t.text     "metric_data"
    t.datetime "last_time_ok"
    t.datetime "last_time_warning"
    t.datetime "last_time_critical"
    t.datetime "last_time_unknown"
    t.string   "threshold_critical",          :limit => 200
    t.string   "threshold_warning",           :limit => 200
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_notification"
    t.integer  "current_notification_number",                 :default => 0
    t.integer  "notifications_enabled",       :limit => 1,    :default => 1
    t.integer  "first_notification_delay",                    :default => 300
    t.integer  "notification_interval",                       :default => 7200
    t.integer  "notification_times",                          :default => 1
    t.integer  "notify_on_recovery",          :limit => 1,    :default => 1
    t.integer  "notify_on_warning",           :limit => 1,    :default => 0
    t.integer  "notify_on_unknown",           :limit => 1,    :default => 0
    t.integer  "notify_on_critical",          :limit => 1,    :default => 1
    t.integer  "flap_detection_enabled",      :limit => 1,    :default => 1
    t.integer  "is_flapping",                 :limit => 1,    :default => 0
    t.integer  "flap_low_threshold",                          :default => 20
    t.integer  "flap_high_threshold",                         :default => 30
    t.integer  "flap_percent_state_change",                   :default => 0
  end

  add_index "services", ["serviceable_type", "serviceable_id", "command", "params"], :name => "i_service_command"

  create_table "sites", :force => true do |t|
    t.string   "name",                        :limit => 50
    t.string   "url"
    t.string   "addr"
    t.integer  "port",                                       :default => 80
    t.string   "path",                        :limit => 200
    t.string   "uuid",                        :limit => 50,  :default => "uuid()"
    t.integer  "agent_id"
    t.integer  "tenant_id"
    t.integer  "discovery_state",                            :default => 0
    t.datetime "last_check"
    t.datetime "next_check"
    t.integer  "duration"
    t.integer  "status",                                     :default => 2
    t.string   "summary",                     :limit => 200
    t.datetime "last_update"
    t.datetime "last_time_up"
    t.datetime "last_time_down"
    t.datetime "last_time_pending"
    t.datetime "last_time_unknown"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_notification"
    t.integer  "current_notification_number",                :default => 0
    t.integer  "notifications_enabled",       :limit => 1,   :default => 1
    t.integer  "first_notification_delay",                   :default => 300
    t.integer  "notification_interval",                      :default => 7200
    t.integer  "notification_times",                         :default => 1
    t.integer  "notify_on_recovery",          :limit => 1,   :default => 1
    t.integer  "notify_on_down",              :limit => 1,   :default => 1
  end

  create_table "tenants", :force => true do |t|
    t.string   "name",                      :limit => 50
    t.string   "company",                   :limit => 50
    t.string   "email",                     :limit => 50
    t.string   "mobile",                    :limit => 20
    t.datetime "expired_at"
    t.string   "db_host",                   :limit => 40
    t.string   "db_name",                   :limit => 40
    t.integer  "port"
    t.string   "username",                  :limit => 40
    t.string   "password",                  :limit => 40
    t.datetime "pay_date"
    t.datetime "avail_date"
    t.string   "remark",                    :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "operator_id"
    t.integer  "package_id"
    t.integer  "package_category"
    t.integer  "amount",                    :limit => 10,  :precision => 10, :scale => 0
    t.boolean  "status"
    t.integer  "balance",                   :limit => 10,  :precision => 10, :scale => 0, :default => 0
    t.integer  "month_num"
    t.boolean  "is_pay_account",                                                          :default => false
    t.date     "begin_at"
    t.date     "end_at"
    t.integer  "current_month",                                                           :default => 0
    t.date     "current_paid_at"
    t.date     "next_paid_at"
    t.date     "remember_token_expires_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 50
    t.string   "username",                  :limit => 50
    t.string   "work_number",               :limit => 50
    t.string   "name",                      :limit => 50
    t.date     "birthday"
    t.string   "remember_token",            :limit => 40
    t.string   "crypted_password",          :limit => 40
    t.string   "password",                  :limit => 40
    t.string   "old_password",              :limit => 50
    t.datetime "remember_token_expires_at"
    t.string   "salt",                      :limit => 40
    t.integer  "role_id"
    t.integer  "tenant_id"
    t.string   "company",                   :limit => 50
    t.string   "department",                :limit => 50
    t.string   "job",                       :limit => 50
    t.string   "phone",                     :limit => 50
    t.string   "mobile",                    :limit => 50
    t.string   "email",                     :limit => 50
    t.string   "description",               :limit => 50
    t.integer  "creator"
    t.integer  "state",                                   :default => 1
    t.string   "activation_code",           :limit => 40
    t.string   "reset_password_code",       :limit => 40
    t.datetime "activated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "view_items", :force => true do |t|
    t.integer  "view_id"
    t.string   "name",               :limit => 100
    t.string   "alias",              :limit => 100
    t.string   "data_type",          :limit => 10,  :default => "int"
    t.string   "data_unit",          :limit => 20
    t.string   "data_format"
    t.string   "data_format_params"
    t.string   "width",              :limit => 10
    t.string   "height",             :limit => 10
    t.string   "fill",               :limit => 10
    t.string   "color",              :limit => 15
    t.string   "hover_color",        :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "views", :force => true do |t|
    t.string   "name",           :limit => 50
    t.string   "visible_type",   :limit => 20
    t.integer  "visible_id"
    t.string   "data_params"
    t.string   "template",       :limit => 50
    t.integer  "dimensionality",               :default => 3
    t.integer  "enable",         :limit => 1,  :default => 1
    t.string   "width",          :limit => 10
    t.string   "height",         :limit => 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
