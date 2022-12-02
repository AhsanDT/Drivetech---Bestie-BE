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
        var message ='<div class="img">'+"<img src='/assets/icon-chat.svg'>"+'</div>'+
        '<div class="txt">'+
          '<h6 class="mb-0">Bestie Support</h6>'+
          '<p class="">'+data.created_at_date+' '+'|'+' '+ data.created_at_time +'</p>'+
        '</div>';
        $(".msg_contain").append(
          '<div class="msg">'+
          '<div class="detail">'+message+
          '</div>'+
          '<p class="msg_body">'+ data.body +'</p>'+(data.image !== null ? '<div class="img_url">'+
              '<div class="atchmt_img">'+
                "<img src="+data.image+">"+
              '</div>'+
            '</div>' : '')+
          '</div>'
        );
      }
      else
      {
        $(".msg_contain").append(
          '<div class="msg">'+
            '<div class="detail">'+
              '<div class="img">'+
                (data.user_profile !== null ? "<img src="+data.user_profile+">" : '<img src="/assets/dummy.png">')+
              '</div>'+
              '<div class="txt">'+
                '<h6 class="mb-0">'+data.ticket_number+'</h6>'+
                '<p class="">'+data.created_at_date+' '+'|'+' '+ data.created_at_time +'</p>'+
              '</div>'+
            '</div>'+
            '<p class="msg_body">'+ data.body +'</p>'+(data.image !== null ? '<div class="img_url">'+
              '<div class="atchmt_img">'+
                "<img src="+data.image+">"+
              '</div>'+
            '</div>' : '')+
          '</div>'
        );
      }
    }
  }
  });
});
