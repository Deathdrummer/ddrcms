<h3 class="text-center mb-6px">Задать переменные для каталога</h3>
<table id="catalogsVarsFormTable">
	<thead>
		<tr>
			<td class="w-30">Переменная</td>
			<td>Значение</td>
			<td class="w-40px"></td>
		</tr>
	</thead>
	<tbody id="catalogsVarsForm">
		{% if vars %}
			{% set varndex = 0 %}
			{% for v, val in vars %}
				<tr>
					<td class="top">
						<div class="field mt-6px">
							<input type="text" name="vars[{{varndex}}][field]" value="{{v}}" autocomplete="off" placeholder="Введите название переменной">
						</div>
					</td>
					<td>
						<div class="textarea">
							<textarea name="vars[{{varndex}}][value]" rows="3" autocomplete="off" placeholder="Введите значение">{{val}}</textarea>
						</div>
					</td>
					<td class="center top">
						<div class="buttons inline notop mt-8px">
							<button class="verysmall remove" catalogvardelete><i class="fa fa-trash"></i></button>
						</div>
					</td>
				</tr>
				{% set varndex = varndex + 1 %}
			{% endfor %}
		{% else %}
			<tr class="empty"><td colspan="3"><p class="empty">Нет данных</p></td></tr>
		{% endif %}
	</tbody>
	<tfoot>
		<tr>
			<td colspan="3">
				<div class="buttons right">
					<button class="verysmall alt" id="catalogVarsAddRowBtn">Добавить</button>
				</div>
			</td>
		</tr>
	</tfoot>
</table>	
	

<div class="buttons">
	<button class="verysmall" catalogssetvarssave index="{{index}}">Применить</button>
</div>