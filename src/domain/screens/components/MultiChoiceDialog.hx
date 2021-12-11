package domain.screens.components;

import data.TextResource;
import domain.screens.components.Dialog.DialogOptions;
import domain.ui.Button;

typedef MultiChoiceDialogOptions =
{
	> DialogOptions,
	text:String,
	buttons:Array<ButtonOptions>
}

class MultiChoiceDialog extends Dialog
{
	public var text:h2d.Text;
	public var buttons:Array<Button>;

	public function new(opts:MultiChoiceDialogOptions)
	{
		super(opts);

		text = TextResource.MakeText();
		text.text = opts.text;
		addChild(text);

		var i = 0;
		buttons = opts.buttons.map((btnOpt) ->
		{
			var button = new Button();
			button.text = btnOpt.text;
			button.onClick = btnOpt.onClick;
			button.type = btnOpt.type;
			button.x = width / 2 - button.width / 2;
			button.y = height - ((button.height + 8) * (opts.buttons.length - i)) - 40;

			addChild(button);

			i++;
			return button;
		});

		text.x = 40;
		text.y = 40;
		text.maxWidth = width - 80;
	}
}
