class ContactsInviter

  def initialize current_user, contacts = nil
    raise 'User is required' if contacts.nil?
    raise 'Contacts(array) is required' if contacts.nil?

    @current_user = current_user
    @contacts = contacts
  end


  def send
    @contacts.each do|contact|
      email = contact[:email]
      name = contact[:name]

      puts "Contact found: name => #{name}, email => #{email}"

      if self.not_a_user? email
        @current_user.delay.invite_new_user! email
      end
    end
  end





  protected

  def not_a_user? email
    !User.where(:email => email).exists?
  end


end
