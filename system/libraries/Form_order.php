<?

class CI_Form_order {
	
	
	protected $CI;

    public function __construct() {
		$this->CI =& get_instance();
    }
    
    
    
    
    
    
    public function validate($postData = false) {
    	if (!$postData) return false;
    	
		function length($parts) {
			return "/^.{".$parts."}$/uim";
		};

		$rules = [
			'checkbox'	=> "/^(true|on)|(false|off)$/",
			'string'	=> "/^[^<>~@#$%&\n\t]+$/ui",
			'text'		=> "/^[0-9A-Za-zА-Яа-яёЁ?() !.,:;-–—'\"\n\t]+$/uim",
			'skype'		=> "/^[^{}<>]+$/ui",
			'email'		=> "/^[0-9a-zA-Z_.-]+@[a-z0-9_.-]+.[a-z]{2,10}$/",
			'phone'		=> "/^\+\d{1,3} \(\d{3}\) \d{3}(-|\s)?\d{2}-\d{2}$/",
			'number'	=> "/^\d+$/"
		];

		// правило:условие|свой текст ошибки||правило2:условие2|свой текст ошибки 2||правило3|свой текст ошибки 3


		$errors = [];
		foreach ($postData as $name => $items) {
			if (! isset($items['rules']) || $items['rules'] == 'false') continue;
			
			$rulesArr = explode('||', $items['rules']);
			$indexOfempty = array_search('empty', $rulesArr); 
			if ($indexOfempty) {
				unset($rulesArr[$indexOfempty]);
				array_unshift($rulesArr, 'empty');
			}
			
			foreach ($rulesArr as $item) {
				if ($item == 'empty' && $items['value'] == '') break;
				
				$itemPart = explode('|', $item);
				$rule = $itemPart[0];
				$errorText = isset($itemPart[1]) ? $itemPart[1] : false;
				if (preg_match("/:/", $rule)) {
					$rulePart = explode(':', $rule);
					if (function_exists($rulePart[0])) {
						if (! preg_match(call_user_func($rulePart[0], $rulePart[1]), $items['value'])) {
							$errors[$name][] = $errorText;
						}
					}
				} elseif (isset($rules[$rule]) && ! preg_match($rules[$rule], $items['value'])) {
					$errors[$name][] = $errorText;
				}
			}
		}
		
		if (empty($errors)) {
			$this->sendEmail($postData);
			return '';
		}
		return $errors;
	}
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}


