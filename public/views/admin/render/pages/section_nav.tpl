<table id="sectionSettings">
	<thead>
		<tr>
			<td colspan="2">
				<h3 class="text-center py-3px">Отображение в меню</h3>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td class="w-35 text-right"><div><span>Сортировка:</span></div></td>
			<td>
				<input type="hidden" name="psid" value="{{psid}}">
				<div class="field w-13rem mt-16px mb-5px">
					<small class="label">0 - не выводить</small>
					<input type="number" min="0" showrows name="navigation" value="{{navigation|default('0')}}" rules="num" autocomplete="off">
				</div>
			</td>
		</tr>
		<tr>
			<td class="w-35 text-right"><div><span>Заголовок в меню:</span></div></td>
			<td>
				<div class="field">
					<input type="text" name="navigation_title" value="{{navigation_title}}" rules="string|length:3,100" autocomplete="off">
				</div>
			</td>
		</tr>
		<tr>
			<td class="w-35 text-right"><div><span>Отобразить секцию:</span></div></td>
			<td>
				{% set rand = rand(0,999) %}
				<div class="checkbox">
					<div class="checkbox__item checkbox__item_ver2 checkbox__item_small">
						<div>
							<input id="check{{rand}}"
							type="checkbox"
							name="showsection"
							{% if showsection %}checked{% endif %}>
							<label for="check{{rand}}"></label>
						</div>
					</div>
				</div>
			</td>
		</tr>
		{#<tr>
			<td class="w-35 text-right"><div><span>Просто настройка:</span></div></td>
			<td>
				<div class="field">
					<input type="text" name="settings[test]" value="{{settings.test}}" rules="string|length:3,100" autocomplete="off">
				</div>
			</td>
		</tr>#}
	</tbody>
</table>

<div class="buttons right">
	<button class="verysmall alt2" sectionsettingssave>Применить</button>
</div>