<?

if (!function_exists('getDatesRange')) {
    /**
	 * Получить массив дат в заданном диапазоне
	 * @param Текущая дата
	 * @param Количество записей
	 * @param Тип даты для диапазона (day день, week неделя и т.д.)
	 * @param Направление диапазона (+ возрастание или - убывание)
	 * @param Что вернуть (маска для функции Date()) Например: 'Y-m-d H:i' По-умолчанию UNIX
	 * @return массив
	*/
    function getDatesRange($currentDate = null, $itemsCount = null, $dateType = 'day', $order = '+', $returnMask = false) {
        $currentDate = !is_null($currentDate) ? (!is_numeric($currentDate) ? strtotime($currentDate) : $currentDate) : time();
        $datesRange = [];
        for ($i = 0; $i < $itemsCount; $i++) {
            if ($returnMask) $datesRange[] = date($returnMask, strtotime('+'.$i.$dateType, $currentDate));
            else $datesRange[] = strtotime('+'.$i.$dateType, $currentDate);
        }
        return $datesRange;
    }
}




if (!function_exists('getHoursMinutes')) {
    /**
	 * Получить часы и минуты, исходя из прбавления или отнимания от переданных часов и минут
	 * @param Текущий час
	 * @param Текущие минуты
	 * @param Значение для смещения времени (часы|минуты или просто минуты)
	 * @param если указать раздеоитель - то вернется время в виде строки с этим самым разделителем
	 * @return строка с указанным разделителем или массив [часы, минуты]
	*/
    function getHoursMinutes($currentHours = null, $currentMinutes = null, $offset = 0, $separator = false) {
        if (is_numeric($offset)) {
            $hoursOffset = floor($offset / 60);
            $minutesOffset = $offset % 60;
        } else {
            $offs = explode('|', $offset);
            $offs = ($offs[0] * 60) + $offs[1];
            $hoursOffset = floor($offs / 60);
            $minutesOffset = $offs % 60;
        }
        
        
        $hoursData = range(0, 23);
        $hoursData[] = 0;
        $minutesData = range(0, 59);
        $minutesData[] = 0;
 
        $limitHours = 24;
        $limitMinutes = 60;
        $plusHours = 0;
        
        
        if ($minutesOffset + $currentMinutes <= $limitMinutes) $resMinutes = $minutesData[$minutesOffset + $currentMinutes];
        else {
            $plusHours = floor(($minutesOffset + $currentMinutes) / $limitMinutes);
            $resMinutes = $minutesData[($minutesOffset + $currentMinutes) % $limitMinutes];
        }
        
        
        if ($hoursOffset + $currentHours <= $limitHours) $resHours = $hoursData[$hoursOffset + $currentHours + $plusHours];
        else $resHours = $hoursData[($hoursOffset + $currentHours + $plusHours) % $limitHours];
        
        if ($separator) return substr('0'.$resHours, -2).$separator.substr('0'.$resMinutes, -2);
        return [$resHours, $resMinutes];
    }
}