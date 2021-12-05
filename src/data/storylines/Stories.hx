package data.storylines;

class Stories
{
	public static var TEST_STORY:Story;

	public static function Init()
	{
		var test = hxd.Res.story.test.toJson();

		TEST_STORY = StoryFactory.FromJson(test);
	}
}
