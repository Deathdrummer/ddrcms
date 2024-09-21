<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Reviews extends MY_Controller {
	
	
	private $viewsPath = 'views/site/render/reviews/';
	
	public function __construct() {
		parent::__construct();
		$this->load->model('reviews_model', 'reviews');
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function index() {
		redirect('index/render', 'location', 301);
	}
	
	
	
	
	
	
	/** Получить все отзывы
	 * @param ID товара
	 * @param стату опубликован или нет. По-умолчанию все
	 * @return array
	*/
	public function all() {
		if (!$this->input->is_ajax_request()) redirect('index/render', 'location', 301);
		$prodId = $this->input->post('product_id');
		$prodName = $this->input->post('product_name');
		
		$data['reviews'] = $this->reviews->all($prodId, 1);
		$data['product_name'] = $prodName;
		
		echo $this->twig->render($this->viewsPath.'list', $data);	
	}
	
	
	
	
	
	
	
	/** Получить форму для создания отзыва
	 * @param 
	 * @return 
	 */
	public function form() {
		$id = $this->input->post('id') ?: false;
		
		if ($id) {
			$data = $this->reviews->get($id);
			echo $this->twig->render($this->viewsPath.'edit_form', $data);
		} else {
			$data['capcha'] = rand(0, 9).rand(0, 9).rand(0, 9).rand(0, 9);
			echo $this->twig->render($this->viewsPath.'form', $data);
		}
	}
	
	
	
	
	
	/** Добавить отзыв
	 * @param 
	 * @return 
	 */
	public function add() {
		$fields = $this->input->post();
		
		
		$capcha = arrTakeItem($fields, 'capcha');
		$capchaOrigin = arrTakeItem($fields, 'capcha_origin');
		
		if ($capcha != $capchaOrigin) exit('-1');
		
		$imagesFiles = reArrayFiles($this->input->files('images')); 
		$filesNames = []; // имена файлов без расширения
		$filesNamesToTable = []; // имена файлов с расширением
		
		if ($imagesFiles) {
			foreach ($imagesFiles as $k => $file) {
				$fileExt = getFileExt($file['name']);
				$fileName = md5($file['name'].$file['size'].time());
				$filesNames[$k] = $fileName;
				$filesNamesToTable[$k] = $fileName.'.'.$fileExt;
			}
		}
		
		
		if ($filesNamesToTable) $fields['images'] = $filesNamesToTable;
		
		if (!$this->reviews->add($fields)) exit('-2');
		
		if ($imagesFiles) {
			foreach ($imagesFiles as $k => $file) {
				$this->_uploadFile([
					'file' => $file,
					'name' => $filesNames[$k],
					'path' => 'reviews',
					'thumb_path' => '__thumbs__',
					'thumb_w' => '160',
					'thumb_h' => '160'
				]);
			}
		}
		
		echo '1';
	}
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function update() {
		$data = $this->input->post();
		$id = arrTakeItem($data, 'id');
		if (!$data) exit('0');
		if (!$this->reviews->update($id, $data)) exit('0');
		echo '1';
	}
	
	
	
	
	
	
	
	
	
	/** Сообщение об успешной отправке отзыва
	 * @param 
	 * @return 
	 */
	public function success() {
		echo $this->twig->render($this->viewsPath.'success');
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function publish() {
		$id = $this->input->post('id');
		if (!$this->reviews->publish($id)) exit('0');
		echo '1';
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function remove() {
		$id = $this->input->post('id');
		if (!$this->reviews->remove($id)) exit('0');
		echo '1';
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function remove_image() {
		$data = $this->input->post();
		extract($data);
		if (!isset($id) || !isset($image)) exit('0');
		
		if (!$this->reviews->removeImage($id, $image)) exit('0');
		echo '1';
	}
	
	
	
	
	
}