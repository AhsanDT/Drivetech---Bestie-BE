json.data do
  json.(@conversations)  do |conversation|
    json.conversation conversation
    json.sender_profile_image conversation.sender.profile_image.attached? ? conversation.sender.profile_image.blob.url : ''
    json.sender conversation.sender
    if conversation.sender.reviews.present?
      @review_rating = 0
      conversation.sender.reviews.each do |review|
        @review_rating  += review.rating
      end
      json.review_average_rating_sender @review_average_rating = @review_rating / conversation.sender.reviews.count
    end
    json.recepient_profile_image conversation.recepient.profile_image.attached? ? conversation.recepient.profile_image.blob.url : ''
    json.recepient conversation.recepient
    if conversation.recepient.reviews.present?
      @review_rating = 0
      conversation.recepient.reviews.each do |review|
        @review_rating  += review.rating
      end
      json.review_average_rating_recipient @review_average_rating = @review_rating / conversation.recepient.reviews.count
    end
    json.messages conversation.messages.last
  end
end
