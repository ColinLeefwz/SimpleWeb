require 'dbi'

# huawei 是 ODBC data source
DBI.connect('dbi:ODBC:huawei', 'CustomSMS', 'SqlMsde@InfoxEie2000') do | dbh |
      dbh.select_all('select * from tbl_SMReceived') do | row |
            p row
               end
              end
