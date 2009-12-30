atom_feed do |feed|
  feed.title("realstori.es")
  # broken
  #feed.updated(@stories.first.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ"))

  for story in @stories
    next if story.updated_at.blank?
    feed.entry(story) do |entry|
      # add later..
      entry.title(story.title)
      entry.content(story.description, :type => 'html')
      entry.updated(story.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) # needed to work with Google Reader.
      entry.author do |author|
        author.name(story.user.username)
      end
    end
  end
end

