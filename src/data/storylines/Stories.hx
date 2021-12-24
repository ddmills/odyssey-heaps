package data.storylines;

class Stories
{
	public static var TEST_STORY:Story;
	public static var BOOK_STORY:Story;
	public static var SQUID_STORY:Story;

	public static var STORIES:Array<Story>;

	public static function Init()
	{
		var test = hxd.Res.story.test.toJson();
		TEST_STORY = StoryFactory.FromJson(test);

		var book = hxd.Res.story.book.toJson();
		BOOK_STORY = StoryFactory.FromJson(book);

		var squid = hxd.Res.story.squid.toJson();
		SQUID_STORY = StoryFactory.FromJson(squid);

		STORIES = [TEST_STORY, BOOK_STORY, SQUID_STORY];
	}

	public static function GetStory(searchString:String):Story
	{
		return STORIES.find((s) ->
		{
			return s.name.toLowerCase().indexOf(searchString.toLowerCase()) > -1;
		});
	}
}
