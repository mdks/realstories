atom_feed do |feed|
  feed.title("realstori.es")
  #feed.updated(@stories.first.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ"))
 
  for story in @stories
    next if story.updated_at.blank?
    feed.entry(story) do |entry|
      #entry.title(story.headline)
      entry.content(story.body, :type => 'html')
 #     entry.updated(story.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) # needed to work with Google Reader.
 #     entry.author do |author|
 #       author.name(story.author)
 #     end
    end
  end
end