class PrintLog
  include Mongoid::Document

	field :sid
	field :printer_mark
	field :num, type: Integer, default: 0
end
