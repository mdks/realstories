def truncate_words(text, length, end_string = ' ...')
  returning words = text.split() do
    words = words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end
end

atom_feed do |feed|
  feed.title("realstori.es")
  # broken
  #feed.updated(@stories.first.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ"))

  for story in @stories
    next if story.updated_at.blank?
    feed.entry(story) do |entry|
      # add later..
      entry.title(story.title)
      entry.content(truncate_words(story.pages.first(:order => 'page_number ASC').body, 140), :type => 'html')
      entry.updated(story.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) # needed to work with Google Reader.
      entry.author do |author|
        author.name(story.user.username)
      end
    end
  end
end

