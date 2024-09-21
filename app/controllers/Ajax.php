<?defined('BASEPATH') or exit('Доступ к скрипту запрещен');

class Ajax extends MY_Controller
{

    //private $viewsPath = 'views/site/render/reviews/';

    public function __construct()
    {
        parent::__construct();
        //$this->load->model('reviews_model', 'reviews');
    }

    /**
     * @param
     * @return
     */
    public function search_products()
    {
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
    public function get_all_hashtags()
    {
        $this->load->model('products_model', 'products');

        $response = $this->products->getAllHashtags();

        echo json_encode(['success' => true, 'data' => $response], JSON_UNESCAPED_UNICODE);
    }

    /**
     * @return string[]
     */
    public function get_pollen_data()
    {

        $url = $this->input->get('url');
        $method = $this->input->get('method');
        $params = $this->input->get('params');

        // Формируем URL с GET параметрами
        $queryString = $params ? http_build_query(array_merge(['method' => $method], $params)) : '';
        $urlWithParams = $url . '?' . $queryString;

        // Инициализация сессии CURL
        $ch = curl_init();

        // Установка параметров CURL
        curl_setopt($ch, CURLOPT_URL, $urlWithParams);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, 30);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);

        // Выполнение запроса и получение ответа
        $response = curl_exec($ch);

        // Обработка ошибок CURL
        if (curl_errno($ch)) {
            $error_msg = curl_error($ch);
            curl_close($ch);
            echo json_encode(['success' => false, 'error' => $error_msg], JSON_UNESCAPED_UNICODE);
        }

        // Закрытие сессии CURL
        curl_close($ch);

        // Возвращаем ответ
        echo json_encode(['success' => true, 'data' => $response], JSON_UNESCAPED_UNICODE);
    }

}
