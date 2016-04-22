require "rails_helper"

RSpec.describe FriendshipNotifications, type: :mailer do
  describe "new_invitation" do
    let(:mail) { FriendshipNotifications.new_invitation }

    it "renders the headers" do
      expect(mail.subject).to eq("New invitation")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
