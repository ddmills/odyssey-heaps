package domain.screens.components;

import data.TextResource;
import domain.screens.components.Dialog.DialogOptions;
import domain.ui.Button;

typedef SimpleDialogOptions =
{
	> DialogOptions,
	text:String,
	button:ButtonOptions
}

class SimpleDialog extends Dialog
{
	public var text:h2d.Text;
	public var button:Button;

	public function new(opts:SimpleDialogOptions)
	{
		super(opts);

		text = TextResource.MakeText();
		text.text = opts.text;
		text.x = 40;
		text.y = 32 + 16 + 20;
		text.maxWidth = width - 80;

		button = new Button();
		button.text = opts.button.text;
		button.onClick = opts.button.onClick;
		button.type = opts.button.type;

		addChild(text);
		addChild(button);

		button.x = width / 2 - button.width / 2;
		button.y = height - button.height - 40;
	}
}
