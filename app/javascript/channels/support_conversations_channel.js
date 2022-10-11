import consumer from "./consumer"
$(document).on('turbolinks:load', function(){
const chat_id = $("#chatmessagebox").attr('data-id');
console.log(chat_id);
consumer.subscriptions.create({channel: "SupportConversationsChannel", id: "support_conversations_" + chat_id},  {
  connected() {
    console.log("Channel Connected!!! To SupportConversationsChannel");
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log(data.body);
    if(data.body.support_conversation_id == chat_id)
    {
      data = data.body;
    if (data.recipient_id == data.user_id) {

      $(".msg_contain").append('<div class="msg">'+
          '<p class="msg">' + data.body + '</p>'+
          '<div class="img_url">'+
            (data.image !== null ? "<img src="+data.image+">" : '')+
          '</div>'+
        '</div>'
        );
    }}
   }
  });
});
