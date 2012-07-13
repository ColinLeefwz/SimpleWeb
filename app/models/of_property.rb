class OfProperty < ActiveRecord::Base
  include Openfire
  self.table_name = "ofProperty"
  self.primary_key = "name"
  
  def self.create_or_update(name,value)
    p = OfProperty.find_by_name name
    if p
      p.propValue = value
    else
      p = OfProperty.new
      p.name = name
      p.propValue = value
    end
    p.save!
  end
  
  def self.user_integrate(host, db_name)
    OfProperty.create_or_update  "xmpp.client.roster.active", false
    OfProperty.create_or_update  "admin.authorizedJIDs","1@#{host}"
    OfProperty.create_or_update  "hybridAuthProvider.primaryProvider.className","org.jivesoftware.openfire.auth.JDBCAuthProvider"
    OfProperty.create_or_update  "hybridAuthProvider.secondaryProvider.className","org.jivesoftware.openfire.auth.DefaultAuthProvider"
    OfProperty.create_or_update  "hybridUserProvider.primaryProvider.className","org.jivesoftware.openfire.user.JDBCUserProvider"
    OfProperty.create_or_update  "hybridUserProvider.secondaryProvider.className","org.jivesoftware.openfire.user.DefaultUserProvider"
    OfProperty.create_or_update  "jdbcAuthProvider.passwordSQL","select password from view_users where username=?"
    OfProperty.create_or_update  "jdbcAuthProvider.passwordType","plain"
    OfProperty.create_or_update  "jdbcProvider.connectionString","jdbc:mysql://localhost:3306/#{db_name}"
    OfProperty.create_or_update  "jdbcProvider.driver","com.mysql.jdbc.Driver"
    OfProperty.create_or_update  "jdbcUserProvider.allUsersSQL","select * from view_users;"
    OfProperty.create_or_update  "jdbcUserProvider.loadUserSQL","select name,type from view_users where username = ?"
    OfProperty.create_or_update  "jdbcUserProvider.userCountSQL","select count(*) from view_users"
    OfProperty.create_or_update  "provider.admin.className","org.jivesoftware.openfire.admin.DefaultAdminProvider"
    OfProperty.create_or_update  "provider.auth.className","org.jivesoftware.openfire.auth.JDBCAuthProvider"
    OfProperty.create_or_update  "provider.group.className","org.jivesoftware.openfire.group.DefaultGroupProvider"
    OfProperty.create_or_update  "provider.lockout.className","org.jivesoftware.openfire.lockout.DefaultLockOutProvider"
    OfProperty.create_or_update  "provider.securityAudit.className","org.jivesoftware.openfire.security.DefaultSecurityAuditProvider"
    OfProperty.create_or_update  "provider.user.className","org.jivesoftware.openfire.user.JDBCUserProvider"
    OfProperty.create_or_update  "provider.vcard.className","org.jivesoftware.openfire.vcard.DefaultVCardProvider"
  end
  
  def self.user_integrate_dev
    OfProperty.user_integrate "ylt.local", "test"
  end
  
  def self.user_integrate_production
    OfProperty.user_integrate "dface.cn", "lianlian?user=lianlian&password=???"
  end 
  
end
