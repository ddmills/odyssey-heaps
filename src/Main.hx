import h2d.Tile;
import h2d.filter.Glow;
import shaders.SineDeformShader;

class Main extends hxd.App
{
	var bmp:h2d.Bitmap;

	static function main()
	{
		hxd.Res.initEmbed();
		new Main();
	}

	override function init()
	{
		var img = hxd.Res.img.spritesheet;
		var sprites = img.toTile();
		var t1 = sprites.sub(8, 0, 8, 8);
		var t2 = sprites.sub(16, 0, 8, 8);
		var t3 = sprites.sub(24, 0, 8, 8);

		var anim = new h2d.Anim([t1, t2, t3], s2d);
		anim.speed = 1;

		// var tf = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
		// var res = hxd.Res.sanic_fnt.toFont();
		var res = hxd.Res.sanic_ttf.build(16);
		var tf = new h2d.Text(res, s2d);
		tf.text = "Odyssey of Erebos";
		tf.color = new h3d.Vector(1, .2, .2);

		var shader = new SineDeformShader();
		shader.speed = 1;
		shader.amplitude = .1;
		shader.frequency = .5;
		shader.texture = img.toTexture();

		tf.filter = new Glow(0x3333ff, .5, .9, .5);

		// tf.addShader(shader);

		// create a Bitmap object, which will display the tile
		// and will be added to our 2D scene (s2d)
		// bmp = new h2d.Bitmap(tile, s2d);
		// modify the display position of the Bitmap sprite
		// bmp.x = s2d.width * 0.5;
		// bmp.y = s2d.height * 0.5;
		// bmp.tile.dx = -4;
		// bmp.tile.dy = -4;
	}

	override function update(dt:Float)
	{
		// increment the display bitmap rotation by 0.1 radians
		// bmp.rotation += 2 * dt;
	}
}
