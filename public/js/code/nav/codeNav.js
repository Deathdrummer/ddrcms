window.codeNav = [{
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
}];
