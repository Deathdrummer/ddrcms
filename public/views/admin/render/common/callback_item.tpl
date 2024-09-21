<tr index="{{index}}">
    <td>
        <div class="field">
            <input type="text" name="setting_callback[{{index}}][id]" value="{{item.id}}">
        </div>
    </td>
    <td>
        <div class="field">
            <input type="text" name="setting_callback[{{index}}][success]" value="{{item.success}}">
        </div>
    </td>
    <td>
        <div class="field">
            <input type="text" name="setting_callback[{{index}}][subject]" value="{{item.subject}}">
        </div>
    </td>
    <td>
        <div class="field">
            <input type="text" name="setting_callback[{{index}}][title]" value="{{item.title}}">
        </div>
    </td>
    <td></td>
    <td class="center">
        <div class="buttons inline notop">
            <button class="small remove" removecb title="Удалить"><i class="fa fa-trash"></i></button>
        </div>
    </td>
</tr>