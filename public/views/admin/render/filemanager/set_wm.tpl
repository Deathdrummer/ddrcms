<table class="fieldset">	
	<tr>
		<td class="w-40"><div><span>Прозрачность (кроме PNG и GIF)</span></div></td>
		<td>
			<div class="field">
				<small class="label">Прозрачность (0-100)</small>
				<input type="number" id="wmOpacityInput" name="opacity" showrows min="0" max="100" step="1" autocomplete="off" value="{{opacity|default('0')}}">
			</div>
		</td>
	</tr>
	<tr>
		<td class="w-40"><div><span>Отступ</span></div></td>
		<td>
			<div class="row">
				<div class="col">
					<div class="field">
						<small class="label">По вертикали (px)</small>
						<input type="number" id="wmOffsetYInput" name="offset_y" showrows step="1" autocomplete="off" value="{{offset_y|default('0')}}">
					</div>
				</div>
				<div class="col">
					<div class="field">
						<small class="label">По горизонтали (px)</small>
						<input type="number" id="wmOffsetXInput" name="offset_x" showrows step="1" autocomplete="off" value="{{offset_x|default('0')}}">
					</div>
				</div>
			</div>
		</td>
	</tr>
	<tr>
		<td class="w-40"><div><span>Положение</span></div></td>
		<td>
			<div class="row">
				<div class="col">
					<p class="fz-12px mb-2px">По вертикали</p>
					<div class="select">
						<select name="position_y" id="wmPositionYInput">
							<option value="top"{% if position_y == 'top' %} selected{% endif %}>Сверху</option>
							<option value="middle"{% if position_y == 'middle' %} selected{% endif %}>Посередине</option>
							<option value="bottom"{% if position_y == 'bottom' %} selected{% endif %}>Снизу</option>
						</select>
					</div>
				</div>
				<div class="col">
					<p class="fz-12px mb-2px">По горизонтали</p>
					<div class="select">
						<select name="position_x" id="wmPositionXInput">
							<option value="left"{% if position_x == 'left' %} selected{% endif %}>Слева</option>
							<option value="center"{% if position_x == 'center' %} selected{% endif %}>По центру</option>
							<option value="right"{% if position_x == 'right' %} selected{% endif %}>Справа</option>
						</select>
					</div>
				</div>
			</div>
		</td>
	</tr>
	<tr>
		<td class="w-40"><div><span>Применить водяной знак</span></div></td>
		<td>
			<div class="row">
				<div class="col">
					<div class="checkbox">
						<div class="checkbox__item checkbox__item_ver1">
							<div>
								<input id="wmSetMiniCheckbox"
									type="checkbox"
									name="set_mini" 
									 {% if set_mini %}checked{% endif %}
									/>
								<label for="wmSetMiniCheckbox"></label>
							</div>
							<label for="wmSetMiniCheckbox">Маленькая картинка</label>
						</div>
					</div>
				</div>
				<div class="col">
					<div class="checkbox">
						<div class="checkbox__item checkbox__item_ver1">
							<div>
								<input id="wmSetOrigCheckbox"
									type="checkbox"
									name="set_orig" 
									 {% if set_orig %}checked{% endif %}
									/>
								<label for="wmSetOrigCheckbox"></label>
							</div>
							<label for="wmSetOrigCheckbox">Большая картинка</label>
						</div>
					</div>
				</div>
			</div>
					
		</td>
	</tr>
	<tr>
		<td class="w-40"><div><span>Статус</span></div></td>
		<td>
			<div class="checkbox">
				<div class="checkbox__item checkbox__item_ver1">
					<div>
						<input id="wmEnableCheckbox"
							type="checkbox"
							name="enable" 
							 {% if enable %}checked{% endif %}
							/>
						<label for="wmEnableCheckbox"></label>
					</div>
					<label for="wmEnableCheckbox">Включено</label>
				</div>
			</div>
		</td>
	</tr>
</table>