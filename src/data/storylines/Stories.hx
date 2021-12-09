package data.storylines;

class Stories
{
	public static var TEST_STORY:Story;
	public static var BOOK_STORY:Story;
	public static var SQUID_STORY:Story;

	public static function Init()
	{
		var test = hxd.Res.story.test.toJson();
		TEST_STORY = StoryFactory.FromJson(test);

		var book = hxd.Res.story.book.toJson();
		BOOK_STORY = StoryFactory.FromJson(book);

		var squid = hxd.Res.story.squid.toJson();
		SQUID_STORY = StoryFactory.FromJson(squid);
	}
}
