<tr index="{{index}}">
	<td>
		<div class="field">
			<input type="text" name="attributes[{{index}}][name]" rules="string|length:3,100" >
		</div>
	</td>
	<td>
		<div class="field">
			<input type="text" name="attributes[{{index}}][value]" rules="string|length:3,255" >
		</div>
	</td>
	<td class="center">
		<div class="buttons inline notop">
			<button class="remove small" removeattribute><i class="fa fa-trash"></i></button>
		</div>
	</td>
</tr>