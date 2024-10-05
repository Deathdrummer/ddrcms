<?defined('BASEPATH') or exit('Доступ к скрипту запрещен');

class Ajax extends MY_Controller {

    //private $viewsPath = 'views/site/render/reviews/';

    public function __construct() {
        parent::__construct();
        //$this->load->model('reviews_model', 'reviews');
    }

    /**
     * @param
     * @return
     */
    public function search_products() {
        $field = $this->input->get('field');
        $value = $this->input->get('value');
        $returnFields = $this->input->get('returnFields');

        $this->load->model('products_model', 'products');

        $response = $this->products->search($field, $value, $returnFields);

        echo json_encode(['success' => true, 'data' => $response], JSON_UNESCAPED_UNICODE);
    }

    /**
     * @param
     * @return
     */
    public function get_all_hashtags() {
        $this->load->model('products_model', 'products');

        $response = $this->products->getAllHashtags();

        echo json_encode(['success' => true, 'data' => $response], JSON_UNESCAPED_UNICODE);
    }

    
	
	
	
	
	
	/**
	* 
	* @param 
	* @return 
	*/
	public function get_section() {
		$postData = $this->input->get();
		$sectionUId = arrTakeItem($postData, 'uid');
		$responseType = arrTakeItem($postData, 'responseType');
		
		$this->load->model('sections_model', 'sections');
		if (!$sectionMeta = $this->sections->getPageSection($sectionUId)) exit('-1');
		
		$sectionData = $this->settings->getSectionSettings($sectionMeta['page_id'], $sectionMeta['filename'], $sectionMeta['page_section_id']);
		
		if ($responseType == 'json') echo json_encode(array_merge($sectionData, $postData), JSON_UNESCAPED_UNICODE);
		else echo $this->twig->render('views/site/sections/'.$sectionMeta['filename'], array_merge($sectionData, $postData));
	}
	

}
