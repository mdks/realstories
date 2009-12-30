def shorten (string, count = 140)
	if string.length >= count
		shortened = string[0, count]
		splitted = shortened.split(/\s/)
		words = splitted.length
		splitted[0, words-1].join(" ") + ' ...'
	else
		string
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
      entry.content(shorten(story.pages.first(:order => 'page_number ASC').body), :type => 'html')
      entry.updated(story.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) # needed to work with Google Reader.
      entry.author do |author|
        author.name(story.user.username)
      end
    end
  end
end

