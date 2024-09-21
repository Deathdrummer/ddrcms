<tr index="{{index}}">
    <td class="center">
        <div class="file single verysmall{% if not item.icon %} empty{% endif %}">
            <label class="file__block" for="file{{index}}" filemanager="images|svg">
                <div class="file__image" fileimage>
                    {% if item.icon %}
                        {% if item.icon|filename(2)|is_img_file %}
                            <img src="{{base_url('public/filemanager/__thumbs__/'~item.icon|freshfile)}}" alt="{{item.icon|filename|decodedirsfiles}}">
                        {% else %}
                            <img src="{{base_url('public/images/filetypes/'~item.icon|filename(2))}}.png" alt="{{item.icon|filename(1)}} | файл {{item.icon|filename(2)}}" title="{{item.icon|filename(1)}} | файл {{item.icon|filename(2)}}">
                        {% endif %}
                    {% else %}
                        <img src="{{base_url('public/images/none_img.png')}}" alt="Нет картинки">
                    {% endif %}
                </div>
                <div class="file__name"><span filename>{% if item.icon %}{{item.icon|filename|decodedirsfiles}}{% endif %}</span></div>
                <div class="file__remove" title="Удалить" fileremove><i class="fa fa-trash"></i></div>
            </label>
            <input
            type="hidden"
            filesrc
            name="setting_soc[{{index}}][icon]"
            value="{{item.icon}}"
            id="file{{index}}" />
        </div>
    </td>
    <td>
        <div class="field">
            <input type="text" name="setting_soc[{{index}}][iconawesome]" value="{{item.iconawesome}}">
        </div>
    </td>
    <td>
        <div class="field">
            <input type="text" name="setting_soc[{{index}}][title]" value="{{item.title}}">
        </div>
    </td>
    <td>
        <div class="field">
            <input type="text" name="setting_soc[{{index}}][link]" value="{{item.link}}">
        </div>
    </td>
    <td>
        <div class="field">
            <input type="number" name="setting_soc[{{index}}][sort]" value="{{item.sort}}">
        </div>
    </td>
    <td class="center">
        <div class="buttons inline notop">
            <button class="small remove" removesoc title="Удалить"><i class="fa fa-trash"></i></button>
        </div>
    </td>
</tr>