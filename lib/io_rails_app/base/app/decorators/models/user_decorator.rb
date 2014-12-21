User.instance_eval do
  def search_and_order(search)
    if search
      where("username LIKE ?", "%#{search.downcase}%").order(
      admin: :desc, username: :asc
      ).page
    else
      order(admin: :desc, username: :asc).page
    end
  end
  
  def last_signups(count)
    order(created_at: :desc).limit(count).select('id', 'username', 'created_at')
  end
  
  def last_signins(count)
    order(last_sign_in_at: 
    :desc).limit(count).select('id', 'username', 'last_sign_in_at')
  end
  
  def users_count
    where("admin = ?", false).count
  end

end