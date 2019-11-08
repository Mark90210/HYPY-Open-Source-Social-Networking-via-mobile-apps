class Messenger
    require 'twilio-ruby'

    @@account_sid = ENV['TWILIO_SID']
    @@auth_token = ENV['TWILIO_TOKEN']
    @@from_number = ENV['TWILIO_NUMBER']

    def initialize to_number
      @to_number = to_number
    end

    def message= message
      @message = message
    end

    def send
      client.messages.create(
        from: @@from_number,
        to: ['+', @to_number].join,
        body: @message
      )
    end

    def self.valid? phone
      lookup_client = Twilio::REST::LookupsClient.new @@account_sid, @@auth_token
      begin
        response = lookup_client.phone_numbers.get(phone)
        response.phone_number
        return true
      rescue=> e
        if e.code == 20404
          return false
        else
          raise e
        end
      end        
    end

    def self.normalize_phone_number phone
      if phone.length == 10
        return ['1', phone].join
      elsif phone.length == 11
        return phone
      else
        return phone#nil
      end
    end

    private
      def client
        return @client if @client

        @client = Twilio::REST::Client.new @@account_sid, @@auth_token
      end

end