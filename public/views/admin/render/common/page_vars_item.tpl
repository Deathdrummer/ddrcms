<tr index="{{index}}">
    <td class="top pt-5px">
        <div class="field">
            <input type="text" name="setting_page_vars[{{page_id}}][{{index}}][variable]" value="{{item.variable}}">
        </div>
    </td>
    <td class="top pt-5px">
        <div class="textarea">
            <textarea name="setting_page_vars[{{page_id}}][{{index}}][value]" rows="5">{{item.value}}</textarea>
        </div>
    </td>
    <td class="center top pt-5px">
        <div class="buttons inline notop">
            <button class="small remove" removevar title="Удалить"><i class="fa fa-trash"></i></button>
        </div>
    </td>
</tr>