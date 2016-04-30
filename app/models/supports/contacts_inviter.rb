class ContactsInviter

  def initialize contacts = nil
    raise 'Contacts(array) is required' if contacts.nil?

    @contacts = contacts
  end


  def send
    @contacts.each do|contact|
      email = contact[:email]
      name = contact[:name]

      puts "Contact found: name => #{name}, email => #{email}"

      if self.not_a_user? email
        User.invite! :email => email, :first_name => name
        sleep(0.4)
      end
    end
  end





  protected

  def not_a_user? email
    !User.where(:email => email).exists?
  end


end
