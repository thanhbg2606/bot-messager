require 'facebook/messenger'
include Facebook::Messenger
binding.pry
Facebook::Messenger::Subscriptions.subscribe(access_token: ENV['ACCESS_TOKEN'], subscribed_fields: ['messages'])
Bot.on :message do |message|
  request_message = message.text
  uid = message.sender['id']
  User.find_or_create_by(uid: uid)
  unless request_message.nil?
    chat_service = ChatService.new(uid)
    chat_service.execute(request_message)
    FacebookMessengerService.deliver(uid, chat_service.response_message)
  end
end
