module UsersHelper
    
  #returns Gravatar for given user
  def gravatar_for(user, options = {size: 80}) # or can just use argument keyword down below without options
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
