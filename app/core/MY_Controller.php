<?defined('BASEPATH') or exit('Доступ к скрипту запрещен');

class MY_Controller extends CI_Controller {

    protected $monthes = [1 => 'января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];
    protected $monthesShort = [1 => 'янв', 'фев', 'мар', 'апр', 'мая', 'июн', 'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'];
    protected $week = [1 => 'Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'];
    protected $weekShort = [1 => 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    protected $minutes;
    protected $dataAccess;
    protected $imgFileExt = ['png', 'jpg', 'jpeg', 'gif', 'bmp', 'ico'];
    protected $allowedTypes = ['png', 'jpg', 'jpeg', 'jpe', 'gif', 'ico', 'bmp', 'svg', 'psd', 'rar', 'zip', 'mp4', 'mov', 'avi', 'mpeg', 'txt', 'rtf', 'djvu', 'pdf', 'doc', 'docx', 'xls', 'xlsx', 'mp3', 'wma', 'wmv', 'sql', 'gltf', 'glb', 'bin', 'css', 'js'];
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

        $this->twig->addFilter('d', function ($date, $isShort = false) {
            if ($isShort) {
                return date('j', $date) . ' ' . $this->monthesShort[date('n', $date)] . ' ' . date('y', $date) . ' г.';
            }

            return date('j', $date) . ' ' . $this->monthes[date('n', $date)] . ' ' . date('Y', $date) . ' г.';
        });

        $this->twig->addFilter('t', function ($time) {
            return date('H:i', $time);
        });
		
		$this->twig->addFilter('week', function ($date) {
            $weekDay = date('N', $date);
            return $this->week[$weekDay];
        });
		
        $this->twig->addFilter('arr_first_item', function ($array) {
            if (!is_array($array)) {
                return null;
            }
            return reset($array);
        });

        

        $this->twig->addFilter('merge', function ($arr, $key, $value = null) {
            if (is_null($value)) return array_merge($arr, $key);
            return array_merge($arr, [$key => $value]);
        });

        $this->twig->addFilter('floor', function ($str) {
            return floor($str);
        });

        $this->twig->addFilter('add_zero', function ($str) {
            return substr('0' . $str, -2);
        });

        $this->twig->addFilter('chunk', function ($arr, $size, $preserveKeys = false) {
            return array_chunk($arr, $size, $preserveKeys);
        });
		
		$this->twig->addFilter('arrtocols', function ($arr, $cols, $preserveKeys = false) {
            $size = ceil(count($arr) / $cols);
            return array_chunk($arr, $size, $preserveKeys);
        });
		
        $this->twig->addFilter('randfromlist', function ($list, $count = false) {
            if (!$list || !is_array($list) || !$count) {
                return false;
            }

            shuffle($list);
            if (count($list) <= $count) {
                return $list;
            }

            $countItems = count($list);
            $rand = rand(0, ($countItems - ($count + 1)));
            $result = array_slice($list, $rand, $count, true) ?: [];
            return $result;
        });

        

        $this->twig->addFilter('arrstrtswith', function ($arr, $symbal, $arrItem = false) {
            if (!is_array($arr)) {
                return null;
            }

            return array_filter($arr, function ($item) use ($arrItem, $symbal) {
                if ($arrItem) {
                    return strpos($item[$arrItem], $symbal) === 0;
                }

                return strpos($item, $symbal) === 0;
            });
        });

        $this->twig->addFilter('arrnotstrtswith', function ($arr, $symbal, $arrItem = false) {
            if (!is_array($arr)) {
                return null;
            }

            return array_filter($arr, function ($item) use ($arrItem, $symbal) {
                if ($arrItem) {
                    return strpos($item[$arrItem], $symbal) !== 0;
                }

                return strpos($item, $symbal) !== 0;
            });
        });

        $this->twig->addFilter('filename', function ($path, $return = 0) {
            if (!$path) {
                return false;
            }

            $fileName = explode('/', str_replace('\\', '/', $path));
            $fileName = array_pop($fileName);
            if ($return == 0) {
                return $fileName;
            }

            $fileName = explode('.', $fileName);
            if (count($fileName) > 1) {
                $e = array_pop($fileName);
                $n = implode('.', $fileName);
                return $return == 1 ? $n : ($return == 2 ? $e : $n . '.' . $e);
            } else {
                return $fileName[0];
            }
        });

        $this->twig->addFilter('ext', function ($path = false, $ext = '') {
            if (!$path) {
                return false;
            }

            $fileName = explode('/', $path);
            $fileName = array_pop($fileName);
            $fileName = explode('.', $fileName);
            if (count($fileName) > 1) {
                $e = array_pop($fileName);
                $n = implode('.', $fileName);
                if ($e == $ext) {
                    return $n . '.' . $ext;
                }

                return $n . $e . '.' . $ext;
            } else {
                return $fileName[0] . '.' . $ext;
            }
        });

        $this->twig->addFilter('is_img_file', function ($ext) {
            return in_array($ext, $this->imgFileExt);
        });

        $this->twig->addFilter('is_file', function ($filename, $nofile = '') {
            $filePath = str_replace(base_url(), '', $filename);
            $filePath = explode('?', $filePath);
            return is_file($filePath[0]) ? $filename : $nofile;
        });

        $this->twig->addFilter('no_file', function ($filename, $nofile = '') {
            $filePath = str_replace(base_url(), '', $filename);
            $filePath = explode('?', $filePath);
            return is_file($filePath[0]) ? $filename : $nofile;
        });

        $this->twig->addFilter('trimstring', function ($string, $length = 10, $end = '...') {
            return mb_strimwidth($string, 0, $length, $end);
        });

        $this->twig->addFilter('addtag', function ($str, $find, $tag = 'span') {
            return str_replace($find, '<' . $tag . '>' . $find . '</' . $tag . '>', $str);
        });

        $this->twig->addFilter('phonecode', function ($str, $tag = 'span') {
            $countNums = strpos($str, ' ') - (strpos($str, '+') !== false ? 1 : 0);
            return preg_replace('/(\+?\d{' . $countNums . '} \(\d{3}\))(.+)/iu', '<' . $tag . '>$1</' . $tag . '>$2', $str);
        });

        $this->twig->addFilter('freshfile', function ($str) {
            return $str . '?' . time();
        });

        $this->twig->addFilter('sortby', function ($arr = false, $field = false, $order = 'asc') {
            if (!$arr || !$field) {
                return false;
            }

            return arrSortByField($arr, $field, $order);
        });

        $this->twig->addFilter('sortbykey', function ($arr = [], $dir = 'asc') {
            if (!$arr) {
                return [];
            }

            if ($dir == 'asc') {
                ksort($arr);
            }

            if ($dir == 'desc') {
                krsort($arr);
            }

            return $arr;
        });

        // Перегруппировать массив по заданным полям
        $this->twig->addFilter('regroup', function ($arr = false, ...$fields) {
            if (!$arr || !$field) {
                return false;
            }

            $newData = []; $str = '';
            foreach ($fields as $field) {
                $str .= "[\$item['" . $field . "']]";
            }

            foreach ($arr as $item) {
                eval("return \$newData$str" . "[] = \$item;");
            }
            return $newData ?: false;
        });

        $this->twig->addFilter('hasinarr', function ($arr = false, $field = false, $value = false) {
            if (!$arr || !$field || !$value) {
                return false;
            }

            $index = arrGetIndexFromField($arr, $field, $value);
            return $index;
        });

        $this->twig->addFilter('decodedirsfiles', function ($str) {
            if (!$str) {
                return false;
            }

            $map = config_item('map');
            $search = array_values($map);
            $replace = array_keys($map);
            return str_replace($search, $replace, $str);
        });

        $this->twig->addFilter('nlreplace', function ($string = false, $replace = false) {
            if (!$string || !$replace) {
                return false;
            }

            $splitTag = explode('><', $replace);
            if (!isset($splitTag[0]) || !isset($splitTag[1])) {
                return $string;
            }

            $startTag = $splitTag[0] . '>';
            $endTag = '<' . $splitTag[1];
            if (!$splitStr = array_filter(preg_split("/\r\n|\r|\n/", $string))) {
                return $string;
            }

            $finalStr = '';
            foreach ($splitStr as $item) {
                $finalStr .= $startTag . $item . $endTag;
            }

            return $finalStr;
        });

        /**
         * Распарсить markdown код
         * @param строка
         * @param многострочное поле, обрамленное тегами p
         * @return
         */
        $this->twig->addFilter('parsedown', function ($str, $multiline = false) {
            if (!$str) {
                return false;
            }

            $this->load->library('parsedown');
            $this->parsedown->setMarkupEscaped(false);
            if ($multiline) {
                $text = $this->parsedown->text($str);
            } else {
                $text = $this->parsedown->line($str);
            }

            return $text;
        });

        /**
         * Получить ID видео Youtube
         * @param ссылка на видео
         * @return
         */
        $this->twig->addFilter('youtubevideoid', function ($url = false) {
            if (!$url) {
                return false;
            }

            $urlArr = explode('/', $url);
            $splitUrl = array_pop($urlArr);

            if (preg_match('/=|\?/', $splitUrl) == false) {
                return $splitUrl;
            }

            if (preg_match('/watch\?v=/', $splitUrl)) {
                $vId = explode('=', $splitUrl);

                if (preg_match('/&/', $vId[1])) {
                    $vId = explode('&', $vId[1]);
                    return $vId[0];
                }

                return $vId[1];
            }

            if (preg_match('/\?list=/', $splitUrl)) {
                $vId = explode('?', $splitUrl);
                return $vId[0];
            }
        });

        /*
        Рекурсивно вывести список с неограниченным вложением подразделов
        Пример: {{categories|recursive('[title]', 'children')}}
        - categories - массив данных
        - '{title}' = элемент массива в {}, например: <p>{title}</p> <img src="{image}" />
        - поле в массиве, содержащее дочерний подмассив
        - тэг контейнера уровня "ul"
        - количество уровней, которые выводить
         */
        $this->twig->addFilter('recursive', function ($data, $item = false, $childField = false, $wrapTag = '<ul></ul>', $levelLimit = false) {
            preg_match_all('/\<.+\>/iU', $wrapTag, $wrapTags);
            $wtgs = $wrapTags[0];
            if (!isset($wtgs[1])) {
                $wtgs[1] = preg_replace('/(\w+)[^>]+/i', '/$1', $wtgs[0]);
            }

            echo str_replace('>', ' level="1">', $wtgs[0]);
            _recur($data, $item, $childField, $wtgs, $levelLimit);
            echo $wtgs[1];
        });
		
		//------------------------------------------------ к фильтру recursive
        function _recur($iter, $i, $chFd, $wtgs, $lim) {
            static $level = 0;
            static $list = '';

            if ($iter) {
                foreach ($iter as $k => $row) {
                    ++$level;
                    $list = preg_replace_callback('/\{(\w+)\}/ui', function ($m) use ($row) {
                        if (!isset($m[1]) || !isset($row[$m[1]])) {
                            return false;
                        }

                        return $row[$m[1]];
                    }, $i);

                    echo $list;
                    if (isset($row[$chFd]) && (!$lim || $level < $lim)) {
                        echo str_replace('>', ' level="' . ($level + 1) . '">', $wtgs[0]);
                        _recur($row[$chFd], $i, $chFd, $wtgs, $lim, $level);
                        echo $wtgs[1];
                    }
                    $level = 0;
                }

            }
            return $list;
        }
		
		

        $this->twig->addFilter('randomaddinarray', function ($arr = false, $item = false) {
            if (!$arr) {
                return false;
            }

            $randomPosition = rand(0, count($arr));
            array_splice($arr, $randomPosition, 0, $item);
            return $arr;
        });

        $this->twig->addFilter('arrgetbyfield', function ($arr = false, $field = false, $value = false) {
            if (!$arr || !$field || !$value) {
                return false;
            }

            $index = arrGetIndexFromField($arr, $field, $value);

            return $arr[$index];
        });

        $this->twig->addFilter('arrcombine', function ($array1 = null, $array2 = null, $count = null) {
            $result = [];
            $array1Count = count($array1 ?? []);
            if (!$array2 || !is_array($array2)) {
                return $array1;
            }
            
            $array2 = array_values($array2);
            // Add elements from the first array
            if ($array1Count) {
                for ($i = 0; $i < min($count, $array1Count); $i++) {
                    $result[] = $array1[$i];
                }
            }

            // If not enough elements in the first array, add from the second array
            for ($i = 0; $i < $count - $array1Count; $i++) {
                if (isset($array2[$i])) {
                    $result[] = $array2[$i];
                } else {
                    break; // Exit loop if second array has fewer elements than needed
                }
            }
            return $result;
        });
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
