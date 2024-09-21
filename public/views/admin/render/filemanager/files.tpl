{% if files %}
	{% for file in files %}
		<div class="{% if to_client %}clientfilemanager__file{% else %}filmanager__file{% endif %}" dirfile="{{file.src}}" namefile="{{file.name}}" extfile="{{file.ext}}">
			<div class="image noselect">
				{% if file.name|filename(2)|is_img_file %}
					<img src="{{base_url('public/filemanager/__thumbs__/'~file.src|freshfile)}}" alt="{{file.name|filename(1)}} | файл {{file.name|filename(2)}}" title="{{file.name|filename(1)}} | файл {{file.name|filename(2)}}">
				{% else %}
					<img src="{{base_url('public/images/filetypes/'~file.src|filename(2))}}.png" alt="{{file.name|filename(1)}} | файл {{file.name|filename(2)}}" title="{{file.name|filename(1)}} | файл {{file.name|filename(2)}}">
				{% endif %}
			</div>
			<span>{{file.name}}</span>
		</div>
	{% endfor %}
{% endif %}	