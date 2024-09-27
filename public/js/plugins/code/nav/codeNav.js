window.codeNav = [{
	id: "add-ddrFormSubmit",
	label: "Добавить отправку формы",
	precondition: null,
	keybindingContext: null,
	contextMenuGroupId: "ddr_navigation",
	contextMenuOrder: 3.5,
	run: async function (editor) {
	    const selection = editor.getSelection();
	    const isTextSelected = !selection.isEmpty();
	    const insertText = 'onsubmit="ddrFormSubmit(\'перед отправкой\', \'коллбэк\')"';
	    editor.executeEdits("my-source", [
	        {
	            range: isTextSelected ? selection : new monaco.Range(
	                selection.startLineNumber,
	                selection.startColumn,
	                selection.startLineNumber,
	                selection.startColumn
	            ),
	            text: insertText,
	            forceMoveMarkers: true
	        }
	    ]);
	    if (!isTextSelected) {
	        editor.setPosition({
	            lineNumber: selection.startLineNumber,
	            column: selection.startColumn + insertText.length
	        });
	    } else {
	        editor.setPosition({
	            lineNumber: selection.endLineNumber,
	            column: selection.startColumn + insertText.length
	        });
	    }
	}
}, {
	id: "add-render-sections",
	label: "Отрисовка секций",
	precondition: null,
	keybindingContext: null,
	contextMenuGroupId: "ddr_navigation",
	contextMenuOrder: 3.5,
	run: async function (editor) {
	    const selection = editor.getSelection();
	    const isTextSelected = !selection.isEmpty();
	    const insertText = '\{\{renderSections(sections)\}\}';
	    editor.executeEdits("my-source", [
	        {
	            range: isTextSelected ? selection : new monaco.Range(
	                selection.startLineNumber,
	                selection.startColumn,
	                selection.startLineNumber,
	                selection.startColumn
	            ),
	            text: insertText,
	            forceMoveMarkers: true
	        }
	    ]);
	    if (!isTextSelected) {
	        editor.setPosition({
	            lineNumber: selection.startLineNumber,
	            column: selection.startColumn + insertText.length
	        });
	    } else {
	        editor.setPosition({
	            lineNumber: selection.endLineNumber,
	            column: selection.startColumn + insertText.length
	        });
	    }
	}
}, {
	id: "wrap-selection-assets",
    label: "Добавить assets",
    precondition: null,
    contextMenuGroupId: "ddr_navigation",
    contextMenuOrder: 3.5,
    run: function (editor) {
        const selection = editor.getSelection();
        const selectedText = editor.getModel().getValueInRange(selection);
        const wrappedText = '\{\{assets(\'' + selectedText + '\')\}\}';
        editor.executeEdits("my-source", [
            {
                range: selection,
                text: wrappedText,
                forceMoveMarkers: true
            }
        ]);
        editor.setPosition({
            lineNumber: selection.endLineNumber,
            column: selection.startColumn + wrappedText.length
        });
    }
}, {
	id: "wrap-selection-filemanager",
    label: "Добавить filemanager",
    precondition: null,
    contextMenuGroupId: "ddr_navigation",
    contextMenuOrder: 3.5,
    run: function (editor) {
        const selection = editor.getSelection();
        const selectedText = editor.getModel().getValueInRange(selection);
        const wrappedText = '\{\{filemanager(\'' + selectedText + '\')\}\}';
        editor.executeEdits("my-source", [
            {
                range: selection,
                text: wrappedText,
                forceMoveMarkers: true
            }
        ]);
        editor.setPosition({
            lineNumber: selection.endLineNumber,
            column: selection.startColumn + wrappedText.length
        });
    }
}, {
	id: "add-mod",
	label: "Добавить строку мода",
	precondition: null,
	keybindingContext: null,
	contextMenuGroupId: "ddr_navigation",
	contextMenuOrder: 3.5,
	run: async function (editor) {
		$.post('/admin/get_mods', function (mods) {
			let modStr = '';
			mods.forEach((mod) => {
				modStr += mod+': \'\', ';
			});
			
			modStr = modStr.replace(/, $/, '');
			
			const selection = editor.getSelection();
		    const isTextSelected = !selection.isEmpty();
		    const insertText = '\{\{mod({'+modStr+'})\}\}';
		    editor.executeEdits("my-source", [
		        {
		            range: isTextSelected ? selection : new monaco.Range(
		                selection.startLineNumber,
		                selection.startColumn,
		                selection.startLineNumber,
		                selection.startColumn
		            ),
		            text: insertText,
		            forceMoveMarkers: true
		        }
		    ]);
		    if (!isTextSelected) {
		        editor.setPosition({
		            lineNumber: selection.startLineNumber,
		            column: selection.startColumn + insertText.length
		        });
		    } else {
		        editor.setPosition({
		            lineNumber: selection.endLineNumber,
		            column: selection.startColumn + insertText.length
		        });
		    }
		}, 'json');    
	}
}, {
	id: "add-mod",
	label: "Добавить переключение мода",
	precondition: null,
	keybindingContext: null,
	contextMenuGroupId: "ddr_navigation",
	contextMenuOrder: 3.5,
	run: async function (editor) {
		$.post('/admin/get_mods', function (mods) {
			let modStr = '';
			mods.forEach((mod) => {
				modStr += mod+': \'\', ';
			});
			
			modStr = modStr.replace(/, $/, '');
			
			const selection = editor.getSelection();
		    const isTextSelected = !selection.isEmpty();
		    const insertText = `{% for mod in modsList()%}\n\t<p{% if mod.active%} class="active"{% endif %} onclick="changeMod('{{mod.db}}', {{mod.active}})">{{mod.db}}</p>\n{% endfor %}`;
		    editor.executeEdits("my-source", [
		        {
		            range: isTextSelected ? selection : new monaco.Range(
		                selection.startLineNumber,
		                selection.startColumn,
		                selection.startLineNumber,
		                selection.startColumn
		            ),
		            text: insertText,
		            forceMoveMarkers: true
		        }
		    ]);
		    if (!isTextSelected) {
		        editor.setPosition({
		            lineNumber: selection.startLineNumber,
		            column: selection.startColumn + insertText.length
		        });
		    } else {
		        editor.setPosition({
		            lineNumber: selection.endLineNumber,
		            column: selection.startColumn + insertText.length
		        });
		    }
		}, 'json');    
	}
}];
