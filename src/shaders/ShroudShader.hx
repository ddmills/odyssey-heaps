package shaders;

import hxsl.Types.Sampler2D;

class ShroudShader extends hxsl.Shader
{
	static var SRC =
		{
			var pixelColor:Vec4;
			@param var amount:Float;
			@param var brightness:Float;
			function fragment()
			{
				var color = pixelColor.rgb;
				var lum = vec3(0.299, 0.587, 0.114);
				var gray = vec3(dot(lum, color));
				pixelColor.rgb = mix(color, gray, amount) * brightness;
			}
		};

	public function new(amount:Float, brightness:Float)
	{
		super();
		this.amount = amount;
		this.brightness = brightness;
	}
}
