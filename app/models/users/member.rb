class Member < User
  def delete(object)
    object.destroy
  end
end
