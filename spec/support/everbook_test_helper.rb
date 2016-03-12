module EverbookTestHelper
  def id_partition id
    case id
    when Integer
      ("%09d".freeze % id).scan(/\d{3}/).join("/".freeze)
    when String
      id.scan(/.{3}/).first(3).join("/".freeze)
    else
      nil
    end
  end

  def jresponse
    JSON.parse(response.body)
  end
  
  def emails_test
    ActionMailer::Base.deliveries
  end
end
