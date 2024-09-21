<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

require_once(APPPATH."libraries/Tinify/Tinify/Exception.php");
require_once(APPPATH."libraries/Tinify/Tinify/ResultMeta.php");
require_once(APPPATH."libraries/Tinify/Tinify/Result.php");
require_once(APPPATH."libraries/Tinify/Tinify/Source.php");
require_once(APPPATH."libraries/Tinify/Tinify/Client.php");
require_once(APPPATH."libraries/Tinify/Tinify.php");

class Filemanager extends MY_Controller {
	
	private $filesPath = './public/filemanager/';
	private $thumbsDir = '__thumbs__'; // иректория для миниатюр
	private $miniDir = '__mini__'; // директория для уменьшенных изображений
	private $thumbsWidth = 150;
	private $thumbsHeight = 150;
	private $tinyPngApiKey = null;
	
	
	public function __construct() {
		parent::__construct();
		$this->load->helper(['directory', 'string', 'text']);
		
		$this->tinyPngApiKey = $this->settings->getSettings('tinypng_api_key');
		if ($this->tinyPngApiKey) \Tinify\setKey($this->tinyPngApiKey);
	}
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function index() {
		if (!$this->input->is_ajax_request()) redirect();
	}
	
	
	
	
	/**
	 * Получить дерево директорий
	 * @param 
	 * @return 
	 */
	public function dirs_get() {
		$currentDir = $this->input->post('current_dir') ?: false;
		$dirsData = directory_map($this->filesPath, 0);
		$dirsData = clearDirs($dirsData, [$this->thumbsDir, $this->miniDir]);
		echo $this->twig->render('views/admin/render/filemanager/dirs.tpl', ['dirs' => $dirsData, 'currentdir' => $currentDir]);
	}
	
	
	
	/**
	 * Новая директория
	 * @param 
	 * @return 
	 */
	public function dirs_new() {
		$activeDir = $this->input->post('active_dir');
		$dirsData = directory_map($this->filesPath, 0);
		$dirsData = clearDirs($dirsData, [$this->thumbsDir, $this->miniDir]);
		echo $this->twig->render('views/admin/render/filemanager/dirs_new.tpl', ['dirs' => $dirsData, 'active_dir' => $activeDir]);
	}
	
	
	
	
	
	/**
	 * Добавить новую директорию
	 * @param 
	 * @return 
	 */
	public function dirs_add() {
		$data = $this->input->post();
		if (!is_dir($this->filesPath.$this->thumbsDir)) mkdir($this->filesPath.$this->thumbsDir, 0777, true); // Если нет директории thumbs - то создать ее
		if (!is_dir($this->filesPath.$this->miniDir)) mkdir($this->filesPath.$this->miniDir, 0777, true); // Если нет директории mini - то создать ее
		if (in_array(trim($data['title']), [$this->thumbsDir, $this->miniDir])) exit('5'); // Нельзя назвать
		if (trim($data['title']) == '') exit('4'); // Пустое название
		if (preg_match('/[\\\|\/]/ui', trim($data['title']))) exit('3'); // Название содержит недопустимые символы
		
		$dirName = encodeDirsFiles($data['title']);
		$path = $data['path'].'/';
		
		if (is_dir($this->filesPath.$path.$dirName)) exit('2'); // такая директория уже есть
		if (!mkdir($this->filesPath.$path.$dirName, 0777, true)) exit('0');
		if (!mkdir($this->filesPath.$this->thumbsDir.'/'.$path.$dirName, 0777, true)) exit('0');
		if (!mkdir($this->filesPath.$this->miniDir.'/'.$path.$dirName, 0777, true)) exit('0');
		echo 1;
	}
	
	
	
	/**
	 * Редактирование директории
	 * @param 
	 * @return 
	 */
	public function dirs_edit() {
		$data = $this->input->post();
		$dirsData = directory_map($this->filesPath, 0);
		$dirsData = clearDirs($dirsData, [$this->thumbsDir, $this->miniDir]);
		echo $this->twig->render('views/admin/render/filemanager/dirs_edit.tpl', ['dirs' => $dirsData, 'name' => $data['name'], 'path' => $data['path']]);
	}
	
	
	
	/**
	 * Обновить директорию
	 * @param 
	 * @return 
	 */
	public function dirs_update() {
		$data = $this->input->post();
		
		/*if ($data['oldpath'] != $data['path']) {
			copy($this->filesPath.$data['oldpath'].'/*', $this->filesPath.$data['path']);
		}*/
		
		$pathWithoutName = explode('/', $data['oldpath']);
		unset($pathWithoutName[count($pathWithoutName) - 1]);
		$pathWithoutName = implode('/', $pathWithoutName).'/';
		
		if (preg_match('/[\\\|\/]/ui', trim($data['name']))) exit('3'); // Название содержит недопустимые символы
		
		$oldName = encodeDirsFiles($data['oldname']);
		$newName = encodeDirsFiles($data['name']);
		
		if ($oldName != $newName) {
			
			if (!rename($this->filesPath.$pathWithoutName.$oldName, $this->filesPath.$pathWithoutName.$newName)) exit('0');
			if (!rename($this->filesPath.$this->thumbsDir.'/'.$pathWithoutName.$oldName, $this->filesPath.$this->thumbsDir.'/'.$pathWithoutName.$newName)) exit('0');
			if (!rename($this->filesPath.$this->miniDir.'/'.$pathWithoutName.$oldName, $this->filesPath.$this->miniDir.'/'.$pathWithoutName.$newName)) exit('0');
		}
		echo json_encode($newName);
	}
	
	
	
	/**
	 * Удалить директорию
	 * @param 
	 * @return 
	 */
	public function dirs_remove() {
		$path = $this->filesPath.$this->input->post('path');
		$thumbsPath = $this->filesPath.$this->thumbsDir.'/'.$this->input->post('path');
		$miniPath = $this->filesPath.$this->miniDir.'/'.$this->input->post('path');
		
		function removeDirectory($dir) {
			if ($objs = glob($dir.'/'."*")) {
			   foreach($objs as $obj) {
			     is_dir($obj) ? removeDirectory($obj) : unlink($obj);
			   }
			}
			return rmdir($dir);
		}
		
		if (removeDirectory($path) && removeDirectory($thumbsPath) && removeDirectory($miniPath)) exit('1');
		echo 0;
	}
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------------------------------------------------------------
	
	
	
	
	
	
	
	
	
	/**
	 * Получить список файлов
	 * @param 
	 * @return 
	 */
	public function files_get() {
		if (!$directory = $this->input->post('directory')) return false;
		$toClient = $this->input->post('client');
		$fileTypes = $this->input->post('filetypes') ? explode('|', $this->input->post('filetypes')) : false;
		$dirFiles = directory_map($this->filesPath.$directory, 1);
		
		$filesData = [];
		if ($dirFiles) {
			foreach ($dirFiles as $file) {
				if (strpos($file, '\\') || strpos($file, '/') || strpos($file, '/')) continue;
				$fData = explode('.', $file);
				$e = array_pop($fData);
				$n = implode('.', $fData);
				if ($fileTypes && !in_array($e, $fileTypes)) continue;
				
				$filesData[] = [
					'src'	=> $directory.'/'.$file,
					'name'	=> decodeDirsFiles($n).'.'.$e,
					'sort'	=> is_numeric(decodeDirsFiles($n)) ? (float)decodeDirsFiles($n) : decodeDirsFiles($n),
				];
			}
		}
		
		$filesData = arrSortByField($filesData, 'sort', 'asc');
		
		echo $this->twig->render('views/admin/render/filemanager/files.tpl', ['files' => $filesData, 'to_client' => $toClient]);
	}
	

	
	
	/**
	 * Переместить файлы
	 * @param 
	 * @return 
	 */
	public function files_replace() {
		$replace = $this->input->post('replace') ?: false;
		if ($replace) {
			$data = $this->input->post();
			
			$errors = [];
			if ($filesData = json_decode($data['files'], true)) {
				foreach ($filesData as $file) {
					$fileName = explode('/', $file);
					$fileName = $fileName[count($fileName)-1];
					
					if (!copy($this->filesPath.$file, $this->filesPath.$data['path'].'/'.$fileName)) {
					    $errors['copy'][] = $file;
					} else {
						if (!unlink($this->filesPath.$file)) {
							$errors['remove'][] = $file;
						}
					}
					
					if (!copy($this->filesPath.$this->thumbsDir.'/'.$file, $this->filesPath.$this->thumbsDir.'/'.$data['path'].'/'.$fileName)) {
					    $errors['copy_thumb'][] = $file;
					} else {
						if (!unlink($this->filesPath.$this->thumbsDir.'/'.$file)) {
							$errors['remove_thumb'][] = $file;
						}
					}
					
					if (!copy($this->filesPath.$this->miniDir.'/'.$file, $this->filesPath.$this->miniDir.'/'.$data['path'].'/'.$fileName)) {
					    $errors['copy_mini'][] = $file;
					} else {
						if (!unlink($this->filesPath.$this->miniDir.'/'.$file)) {
							$errors['remove_mini'][] = $file;
						}
					}
				}
			}
			
			if ($errors) echo json_encode($errors);
			else echo 1;
		} else {
			$currentDir = $this->input->post('currentdir');
			$dirsData = directory_map($this->filesPath, 0);
			$dirsData = clearDirs($dirsData, [$this->thumbsDir, $this->miniDir]);
			echo $this->twig->render('views/admin/render/filemanager/files_replace.tpl', ['dirs' => $dirsData, 'currentdir' => $currentDir]);
		}
	}
	
	
	
	
	
	/**
	 * Установить ширину и высоту, которая задается сразу при загрузке
	 * @param 
	 * @return 
	 */
	public function set_width_height() {
		$pData = $this->input->post();
		echo $this->twig->render('views/admin/render/filemanager/set_width_height.tpl', $pData);
	}
	
	
	
	/**
	 * Настройки водяного знака
	 * @param 
	 * @return 
	 */
	public function set_wm() {
		$pData = $this->input->post();
		echo $this->twig->render('views/admin/render/filemanager/set_wm.tpl', $pData);
	}
	
	
	
	
	
	
	/**
	 * Загрузить файл(ы)
	 * @param 
	 * @return 
	 */
	public function files_upload() {
		$path = $this->input->post('filemanager_path');
		$reSize = $this->input->post('size') ?: false;
		$reSizeVariant = $this->input->post('size_variant') ?: 'hard';
		$wmSettings = $this->input->post('wm') ?: null;
		$files = $this->input->files('filemanager_files');
		if (!$files) exit('2');
		$files = $this->_reArrayFiles($files);
		$this->load->library(['upload', 'image_lib']);
		
		
        $errors = [];
        foreach ($files as $k => $file) {
			$fileName = explode('.', $file['name']);
			$e = strtolower(array_pop($fileName));
			$n = implode('.', $fileName);
			//$name = encodeDirsFiles($n);
			$name = $n;
        	
        	$this->upload->initialize([
        		'file_name' 	=> $name.'.'.$e,
        		'upload_path' 	=> 'public/filemanager/'.$path,
        		'allowed_types'	=> $this->allowedTypes,
        		'overwrite'		=> true,
        		//'max_filename_increment' => 300,
				'quality'		=> '100%',
        	]);
        	

        	$this->upload->set_allowed_types($this->allowedTypes);
        	
        	if ($this->upload->do_upload(false, $file)) {
        		$uploadData = $this->upload->data();
        		
        		//------------------------------------- Если файл - WEBP
	    		if ($uploadData['file_type'] == 'image/webp') {
	    			if ($uploadData['full_path']) {
						$image = imagecreatefromwebp($uploadData['full_path']);
						imagealphablending($image, true);
						imagesavealpha($image, true);
						$width = imagesx($image);
						$height = imagesy($image);
						$background = imagecolorallocatealpha($image, 255, 255, 255, 127);
						imagefilledrectangle($image, 0, 0, $width, $height, $background);
						imagecopyresampled($image, $image, 0, 0, 0, 0, $width, $height, $width, $height);
						imagepng($image, $uploadData['file_path'].$uploadData['raw_name'].'.png');
						imagedestroy($image);
						unlink($uploadData['full_path']);
						
						$uploadData['file_name'] = changeFileExt($uploadData['file_name'], 'png');
						$uploadData['full_path'] = changeFileExt($uploadData['full_path'], 'png');
						$uploadData['orig_name'] = changeFileExt($uploadData['orig_name'], 'png');
						$uploadData['client_name'] = changeFileExt($uploadData['client_name'], 'png');
						
						$uploadData['file_ext'] = '.png';
						$uploadData['file_type'] = 'image/png';
						$uploadData['is_image'] = 1;
					}
	    		}
        		
        		if ($uploadData['is_image'] == 1) { // если загруженный файл - изображение
					# TinyPng compressing
					if ($this->tinyPngApiKey && in_array($uploadData['image_type'], ['jpeg', 'jpg', 'png'])) {
						$uploadedFilePath = 'public/filemanager/'.$path.'/'.$uploadData['file_name'];
						$source = \Tinify\fromFile($uploadedFilePath);
						$source->toFile($uploadedFilePath);
					}
				
				
	        		$cfg['image_library'] = 'gd2';
					$cfg['source_image'] = $uploadData['full_path'];
		        	$cfg['maintain_ratio'] = true;
		        	$cfg['master_dim'] = 'auto'; //auto, width, height
					$cfg['new_image'] = 'public/filemanager/'.$this->thumbsDir.'/'.$path.'/'.$uploadData['file_name'];
					if (!is_dir('public/filemanager/'.$this->thumbsDir.'/'.$path.'/')) mkdir('public/filemanager/'.$this->thumbsDir.'/'.$path.'/', 0777, true);
					$cfg['width'] = $this->thumbsWidth;
					$cfg['height'] = $this->thumbsHeight;
					
					
					$this->image_lib->initialize($cfg);
					if (!$this->image_lib->resize()) toLog($this->image_lib->display_errors());
					
					
					foreach ($reSize as $sizeType => $size) {
						$cfgr = [];
						$this->image_lib->clear();
						
						$cfgr['image_library'] = 'gd2';
			        	$cfgr['maintain_ratio'] = true;
			        	$cfgr['master_dim'] = 'auto'; //auto, width, height
						$cfgr['source_image'] = $uploadData['full_path'];
						if ($sizeType == 'small') {
							if (!is_dir('public/filemanager/'.$this->miniDir.'/'.$path.'/')) mkdir('public/filemanager/'.$this->miniDir.'/'.$path.'/', 0777, true);
							$cfgr['new_image'] = 'public/filemanager/'.$this->miniDir.'/'.$path.'/'.$uploadData['file_name'];
						}
						
						if ($reSizeVariant == 'hard') { // Жестко задается размер картинки
							if ($size['width']) $cfgr['width'] = $size['width'];
							if ($size['height']) $cfgr['height'] = $size['height'];
						} elseif ($reSizeVariant == 'less') { // размер картинки задается, только если фактический размер больше заданного
							if ($size['width'] && $size['width'] < $uploadData['image_width']) $cfgr['width'] = $size['width'];
							if ($size['height'] && $size['height'] < $uploadData['image_height']) $cfgr['height'] = $size['height'];
						}
						
						$this->image_lib->initialize($cfgr);
						if (!$this->image_lib->resize()) toLog($this->image_lib->display_errors());
					}
					
					
					
					// Watermark
					if ($wmSettings['enable']) {
						$wmFilePath = $this->settings->getSettings('watermark');
						if (is_file('public/filemanager/'.$wmFilePath)) {
							
							$setWM = [];
							if ($wmSettings['set_orig']) $setWM[] = '';
							if ($wmSettings['set_mini']) $setWM[] = $this->miniDir.'/';
							
							foreach ($setWM as $dir) {
								$wmCfg = [];
								$this->image_lib->clear();
								# $wmSettings массив настроек для водяного знака
								$wmCfg['source_image'] = 'public/filemanager/'.$dir.$path.'/'.$uploadData['file_name'];
								$wmCfg['wm_type'] = 'overlay';
								$wmCfg['wm_overlay_path'] = 'public/filemanager/'.$wmFilePath;
								$wmCfg['wm_opacity'] = $wmSettings['opacity'] ?: 50; # Прозрачность (кроме PNG и GIF)
								$wmCfg['quality'] = '90%';
								$wmCfg['wm_padding'] = 0;
								$wmCfg['wm_vrt_alignment'] = $wmSettings['position_y'] ?: 'bottom'; # положение по вертикали
								$wmCfg['wm_hor_alignment'] = $wmSettings['position_x'] ?: 'right'; # положение по оризонтали
								$wmCfg['wm_hor_offset'] = $wmSettings['offset_x'] ?: 0; # смещение по горизонтали
								$wmCfg['wm_vrt_offset'] = $wmSettings['offset_y'] ?: 0; # смещение по вертикали
								//$wmCfg['wm_x_transp'] = 100; # смещение по вертикали
								//$wmCfg['wm_y_transp'] = 100; # смещение по вертикали
								
								$this->image_lib->initialize($wmCfg);
								$this->image_lib->watermark();
							}
						}
						
					}
        		}
        		
        	} else {
        		$errors[$k]['error'] = $this->upload->display_errors();
				$errors[$k]['file'] = $file;
        	}
        }
        
        
        if ($errors) exit(json_encode($errors));
        echo 1;
	}
	
	
	
	
	/**
	 * Перестроить массив $_FILES
	 * @param 
	 * @return 
	 */
	private function _reArrayFiles(&$filePost) {
	    $filesArr = [];
	    $fileCount = count($filePost['name']);
	    $fileKeys = array_keys($filePost);
	    
	    for ($i = 0; $i < $fileCount; $i++) {
	        foreach ($fileKeys as $key) {
	            $filesArr[$i][$key] = is_array($filePost[$key][$i]) ? $filePost[$key][$i][0] : $filePost[$key][$i];
	        }
	    }
	    
	    return $filesArr;
	}
		
	
	
	/**
	 * Удалить файлы
	 * @param 
	 * @return 
	 */
	public function files_delete() {
		if (!$files = $this->input->post('files')) exit('0');
		foreach ($files as $file) {
			$mainFile = $this->filesPath.$file;
			$thumbFile = $this->filesPath.$this->thumbsDir.'/'.$file;
			$miniFile = $this->filesPath.$this->miniDir.'/'.$file;
			
			if (file_exists($thumbFile) && isAccessFile($thumbFile)) unlink($thumbFile);
			if (file_exists($miniFile) && isAccessFile($miniFile)) unlink($miniFile);
			if (!file_exists($mainFile) || !isAccessFile($mainFile)) exit('0');
			if (!unlink($mainFile)) exit('1');
		}
		echo 2;
	}
	
	
	
	
	
	
	
	
}