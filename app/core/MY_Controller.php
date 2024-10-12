<?defined('BASEPATH') or exit('Доступ к скрипту запрещен');

class MY_Controller extends CI_Controller {

    protected $monthes = [1 => 'января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];
    protected $monthesShort = [1 => 'янв', 'фев', 'мар', 'апр', 'мая', 'июн', 'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'];
    protected $week = [1 => 'Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'];
    protected $weekShort = [1 => 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    protected $minutes;
    protected $dataAccess;
    protected $imgFileExt = ['png', 'jpg', 'jpeg', 'gif', 'bmp', 'ico', 'webp', 'apng'];
    protected $allowedTypes = ['png', 'jpg', 'jpeg', 'jpe', 'gif', 'ico', 'bmp', 'svg', 'psd', 'rar', 'zip', 'mp4', 'mov', 'avi', 'mpeg', 'txt', 'rtf', 'djvu', 'pdf', 'doc', 'docx', 'xls', 'xlsx', 'mp3', 'wma', 'wmv', 'sql', 'gltf', 'glb', 'bin', 'css', 'js', 'woff', 'woff2', 'ttf', 'eot', 'otf', 'map', 'json'];
    protected $controllerName;

    public function __construct() {
        set_time_limit(180);
        parent::__construct();
		
        $this->minutes = range(0, 55, 5);
        $this->controllerName = strtolower(reset($this->uri->rsegments));
        
        $this->twig->addGlobal('cms', 'views/site/layout/cms.tpl');
        $this->twig->addGlobal('site_scripts', 'views/site/layout/scripts.tpl');
        $this->twig->addGlobal('macro', 'views/admin/macro.html.twig');
        $this->twig->addGlobal('assets', 'public/filemanager/assets/');
        $this->twig->addGlobal('files', 'public/filemanager/');
        $this->twig->addGlobal('filemanager', 'public/filemanager/');
        $this->twig->addGlobal('images', 'public/images/');
        

        //--------------------------------------------------------------------------- Twig фильтры
        require_once APPPATH.'libraries/twig_filters.php';
    }




    /**
     * Отрендерить секции
     * @param массив [секция => параметры]
     * @return массив  [секция => рендер]
     */
    protected function renderSections($sections = false, $settings = [], $catalogItem = false) {
        $renderData = [];
        if (!$sections) {
            return $renderData;
        }

        ksort($sections);

        if ($sections) {
            foreach ($sections as $s) {
                $sectionFile = substr($s['filename'], -4, 4) == '.tpl' ? $s['filename'] : $s['filename'] . '.tpl';
                $sectionName = (substr($s['filename'], -4, 4) == '.tpl' ? substr($s['filename'], 0, -4) : $s['filename']);
                $issetSection = is_file('public/views/' . $this->controllerName . '/sections/' . $sectionFile);
                $sectionData = isset($settings[$s['settings']['settings_preffix']]) ? $settings[$s['settings']['settings_preffix']] : [];
                $catalog = isset($s['settings']['catalog']) ? $this->_getCatalogData($s['settings']['catalog']) : false;
                $html = $issetSection ? $this->twig->render('views/' . $this->controllerName . '/sections/' . $sectionFile, array_merge($settings, $s['settings'], $sectionData, ['catalog' => $catalog], ['catalog_item' => isset($s['settings']['catalog_item']) ? $catalogItem[$s['settings']['catalog_item']] : false])) : null;
                $renderData[] = [
                    'section' => $sectionName,
                    'html' => $html,
                    'preffix' => $s['settings']['settings_preffix'],
                    'catalog' => isset($s['settings']['catalog']) ? $s['settings']['catalog'] : false,
                ];
            }
        }

        return $renderData;
    }
    
    
    
    
    
    

    /**
     * Вывод данных для отображения
     * @param - page: подключить страницу из директории pages
     * @param - header: подключить шапку
     * @param - footer: подключить футер
     * @param - nav: подключить навигационное меню
     * @param - scrolltop: отобразить кнопку прокрутки страницы вверх, вписать ID иконки из спрайта
     * @param - тип отображения данных (вернуть данные или рендерить)
     * @return array или display
     */
    protected function display($ops = [], $settings = []) {
        if (!isset($ops['page']) || !$ops['page']) {
            return [];
        }

        $options = array_replace([
            'svg_sprite' => getSprite(SPRITEPATH),
            'controller' => $this->controllerName,
            'page' => false,
            'site_title' => false,
            'header' => false,
            'footer' => false,
            'nav' => false,
            'scrolltop' => isset($settings['scrolltop']) ? $settings['scrolltop'] : '#arrow',
        ], $ops);

        $page = substr($options['page'], -4, 4) == '.tpl' ? $options['page'] : $options['page'] . '.tpl';
        if (!is_file('public/views/' . $this->controllerName . '/pages/' . $page)) {
            $options['page'] = 'error';
        }

        $this->twig->display('views/' . $this->controllerName . '/index', array_merge($settings, $options) ?: []);
    }
    
    
    
    
    

    /**
     * Загрузить файл
     * @param file - массив файла
     * @param name - имя файла используются подстановки {name} {time} {y} {m} {d} Если ничего не передавать - то имя остается оригинальным
     * @param path - куда сохранить public/images/{путь}
     * @param thumb_w thumb_h -
     * @param thumb_path - путь для thumbs
     * @param resize_w resize_h

     * @return file data
     */
    protected function _uploadFile($settings = false) {
        if (!$settings) {
            toLog('_uploadFile -> нет настроек!');
            return false;
        }
		
        extract($settings);

        if (!$file || !$path) {
            return false;
        }

        $fullPath = substr($path, -1) == '/' ? $path : $path.'/';
        if (!is_dir($fullPath)) {
            mkdir($fullPath);
        }

        $this->load->library(['upload', 'image_lib']);

        if (is_null($name)) {
            $fileName = $file['name'];
        } else {
            $fn = explode('.', $file['name']);
            $ext = strtolower(array_pop($fn));

            $fileName = preg_replace_callback('/\{(\w+)\}/ui', function ($m) use ($fn) {
                if (!isset($m[1])) {
                    return false;
                }

                $data = [
                    'name' => isset($fn[0]) ? strtolower($fn[0]) : '',
                    'time' => time(),
                    'y' => date('Y'),
                    'm' => date('m'),
                    'd' => date('d'),
                ];
                return isset($data[$m[1]]) ? $data[$m[1]] : false;
            }, $name);
        }

        $this->upload->initialize([
            'file_name' => $fileName . '.' . $ext,
            'upload_path' => $fullPath,
            'allowed_types' => $this->allowedTypes,
            'overwrite' => true,
            'quality' => '100%',
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
                    imagepng($image, $uploadData['file_path'] . $uploadData['raw_name'] . '.png');
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
                if (isset($thumb_w) || isset($thumb_h)) {
                    $thumbsPath = isset($thumb_path) ? rtrim($thumb_path, '/') : 'thumbs/';
                    $cfg['image_library'] = 'gd2';
                    $cfg['maintain_ratio'] = true;
                    $cfg['master_dim'] = 'auto'; //auto, width, height
                    $cfg['source_image'] = $uploadData['full_path'];
                    $cfg['new_image'] = $fullPath . $thumbsPath . '/' . $uploadData['file_name'];
                    if (!is_dir($fullPath . $thumbsPath . '/')) {
                        mkdir($fullPath . $thumbsPath . '/');
                    }

                    $cfg['width'] = isset($thumb_w) ? $thumb_w : 150;
                    $cfg['height'] = isset($thumb_h) ? $thumb_h : 150;

                    $this->image_lib->initialize($cfg);
                    if (!$this->image_lib->resize()) {
                        toLog($this->image_lib->display_errors());
                    }

                }

                if (isset($resize_w) || isset($resize_h)) {
                    // Обрезать картинку
                    $this->image_lib->clear();
                    $cfgr['image_library'] = 'gd2';
                    $cfgr['maintain_ratio'] = true;
                    $cfgr['master_dim'] = 'auto'; //auto, width, height
                    $cfgr['source_image'] = $uploadData['full_path'];
                    if (isset($resize_w) && $uploadData['image_width'] > $resize_w) {
                        $cfgr['width'] = $resize_w;
                    }

                    if (isset($resize_h) && $uploadData['image_height'] > $resize_h) {
                        $cfgr['height'] = $resize_h;
                    }

                    $this->image_lib->initialize($cfgr);
                    if (!$this->image_lib->resize()) {
                        toLog($this->image_lib->display_errors());
                    }

                }
            }
            return $uploadData;
        }

        $err = $this->upload->display_errors();
        return $err;
    }
    
    
    
    
    

    protected function _removeFile($fileName = null, $path = null, $thumbsPath = false) {
        if (!$fileName || !$path) {
            return false;
        }

        $fullPath = substr($path, -1) == '/' ? 'public/images/' . $path : 'public/images/' . $path . '/';

        $thumbsPath = $thumbsPath ? $fullPath . rtrim($thumbsPath, '/') . '/' : $fullPath . 'thumbs/';

        if (is_file($thumbsPath . $fileName)) {
            unlink($thumbsPath . $fileName);
        }

        if (is_file($fullPath . $fileName)) {
            unlink($fullPath . $fileName);
        }

        return true;
    }
    
    
    
    
    protected function _isCliRequest() {
        return (isset($_SERVER['HTTP_USER_AGENT']) && preg_match('/Wget\//', $_SERVER['HTTP_USER_AGENT']));
    }

}
