<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Sendemail {
	
	private $CI;
	private $email;
	private $smtp;
	
	
	/**
	 * Инициализация библиотеки
	 * @param 
	 * @return 
	*/
	private function init() {
		$this->CI =& get_instance();
		$this->CI->load->model('settings_model', 'settings');
		$settings = $this->CI->settings->getSettings(['email', 'smtp']);
		$this->email = isset($settings['email']) ? $settings['email'] : false;
		$this->smtp = isset($settings['smtp']) ? $settings['smtp'] : false;
		
		if (!$this->email) {
			toLog('Sendemail ошибка, не подтянулись данные из настроек!');
			return false;
		}
	}
	
	
	/**
	 * Отправить письмо
	 * @param массив данных: 
	 * 		from - от кого (по-умолчанию берея из настроек)
	 * 		from_name - от кого [имя] (по-умолчанию берея из настроек)
	 * 		to - адресат (по-умолчанию берется из настроек)
	 * 		subject - тема пьма
	 * 		template - шаблон (только название без полного пути. Поиск будет в public/views/site/email/ если не найдет - то в public/views/admin/email/)
	 * 		title - заголовок в письме
	 * @return stat
	*/
	public function send($d = null) {
		if (is_null($d)) return 0;
		
		$files = $d['files'] ?? null;
		
		$this->init();
		
		if (count(array_filter($this->smtp)) != 0 && count(array_filter($this->smtp)) != 5) {
			toLog('Настройки SMTP заданы неверно!');
			return -5;
		}
		
		
		$isSMTP = count(array_filter($this->smtp)) == 5;
		
		
		if (!isset($d['template']) || !$d['template']) {
			toLog('Не хватает поля template!');
			return -2;
		} 
		
		$from = isset($d['from']) ? $d['from'] : (isset($this->email['from']) ? $this->email['from'] : 'admin@admin.ru');
		$fromName = isset($d['from_name']) ? $d['from_name'] : (isset($this->email['from_name']) ? $this->email['from_name'] : 'Неизвестный отправитель');
		$to = isset($d['to']) ? $d['to'] : (isset($this->email['to']) ? $this->email['to'] : false);
		$subject = isset($d['subject']) ? $d['subject'] : (isset($this->email['subject']) ? $this->email['subject'] : 'Письмо без темы');
		$template = is_file('public/views/site/email/'.$d['template']) ? 'views/site/email/'.$d['template'] : (is_file('public/views/admin/email/'.$d['template']) ? 'views/admin/email/'.$d['template'] : false);
		$d['title'] = isset($d['title']) ? $d['title'] : (isset($d['subject']) ? $d['subject'] : (isset($this->email['subject']) ? $this->email['subject'] : ''));
		
		if (!$template) {
			toLog('Такого шаблона для отправки письма не существует!');
			return -2;
		} 
		
		if (!$to) {
			toLog('Не хватает поля to!');
			return -2;
		} 
		
		$this->CI->load->library('email');
		if (isHosting() && $isSMTP) {
			if ($isSMTP) {
				$this->CI->email->initialize([
					'mailtype' 		=> 'html',
					'protocol' 		=> 'smtp',
					'priority' 		=> 1,
					'smtp_host' 	=> $this->smtp['host'],
					'smtp_user' 	=> $this->smtp['user'],
					'smtp_pass' 	=> $this->smtp['pass'],
					'smtp_port' 	=> $this->smtp['port'],
					'smtp_crypto' 	=> $this->smtp['crypto']
				]);
			} else {
				$this->CI->email->initialize([
					'mailtype' 		=> 'html',
					'protocol' 		=> 'mail',
					'priority' 		=> 1
				]);
			}
				
		} else {
			$this->CI->email->initialize([
				'mailtype'	=> 'html',
				'protocol'	=> 'mail',
				'priority'	=> 1
			]);
		}
		
		// удаляем ненужные поля
		if (isset($d['from'])) unset($d['from']);
		if (isset($d['from_name'])) unset($d['from_name']);
		if (isset($d['to'])) unset($d['to']);
		if (isset($d['template'])) unset($d['template']);
		
		$this->CI->email->from($from, $fromName);
		$this->CI->email->to($to);
		$this->CI->email->subject($subject);
		
		if ($files) {
			foreach ($files as $field => $file) {
				$this->CI->email->attach($file['tmp_name'], 'inline', $file['name']/* , $file['type'] */);
			}
		}
		
		//$path = 'C:/Users/deathdrumer/Desktop/download.jpg';
		//$this->CI->email->attach($path);
		
		$this->CI->email->message($this->CI->twig->render($template, $d));
		
		if (!$this->CI->email->send()) {
			toLog($this->CI->email->print_debugger());
			return -3;
		}
		
		return 1;
	}
	
	
}