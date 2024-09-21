<table class="fieldset">	
	<tr>
		<td class="w-30"><div><span>Большая</span></div></td>
		<td>
			<div class="row">
				<div class="col">
					<div class="field">
						<small class="label">Ширина (px)</small>
						<input type="number" id="bigWidth" showrows min="0" step="100" autocomplete="off" value="{{big_width|default('0')}}">
					</div>
				</div>
				<div class="col">
					<div class="field">
						<small class="label">Высота (px)</small>
						<input type="number" id="bigHeight" showrows min="0" step="100" autocomplete="off" value="{{big_height|default('0')}}">
					</div>
				</div>
			</div>
		</td>
	</tr>
	<tr>
		<td class="w-30"><div><span>Маленькая</span></div></td>
		<td>
			<div class="row">
				<div class="col">
					<div class="field">
						<small class="label">Ширина (px)</small>
						<input type="number" id="smallWidth" showrows min="0" step="100" autocomplete="off" value="{{small_width|default('0')}}">
					</div>
				</div>
				<div class="col">
					<div class="field">
						<small class="label">Высота (px)</small>
						<input type="number" id="smallHeight" showrows min="0" step="100" autocomplete="off" value="{{small_height|default('0')}}">
					</div>
				</div>
			</div>	
		</td>
	</tr>
	<tr>
		<td class="w-30"><div><span>Вариант изменения размера</span></div></td>
		<td>
			<div class="radio">
				<div class="radio__item radio__item_var1">
					<div>
						<input id="resizeVariant1"
						type="radio"
						name="resize_variant" 
						{% if not resize_variant or resize_variant == 'hard' %}checked{% endif %}
						value="hard">
						<label for="resizeVariant1"></label>
					</div>
					<label for="resizeVariant1">Жестко</label>
				</div>
				<div class="radio__item radio__item_var1">
					<div>
						<input id="resizeVariant2"
						type="radio"
						name="resize_variant" 
						{% if resize_variant == 'less' %}checked{% endif %}
						value="less">
						<label for="resizeVariant2"></label>
					</div>
					<label for="resizeVariant2">На уменьшение</label>
				</div>
			</div>
		</td>
	</tr>
</table>