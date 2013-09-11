class Announcement < Session
  self.inheritance_column = 'content_type'
end
