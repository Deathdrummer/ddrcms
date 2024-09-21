<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

$query_builder = TRUE;
$active_group = 'default';
$db['default'] = [
	'dsn'			=> '',
	'hostname' 		=> 'localhost',
	'username' 		=> config_item('db_user'),
	'password' 		=> config_item('db_pass'),
	'database' 		=> config_item('db_name'),
	'dbdriver' 		=> 'mysqli',
	'dbprefix' 		=> '',
	'pconnect' 		=> FALSE,
	'db_debug' 		=> (ENVIRONMENT !== 'production'),
	'cache_on' 		=> FALSE,
	'cachedir' 		=> '',
	'char_set' 		=> 'utf8',
	'dbcollat' 		=> 'utf8_general_ci',
	'swap_pre' 		=> '',
	'encrypt' 		=> FALSE,
	'compress' 		=> FALSE,
	'stricton' 		=> FALSE,
	'failover' 		=> [],
	'save_queries' 	=> TRUE
];




if (file_exists(MODIFICATIONS_FILE) && $fileData = json_decode((file_get_contents(MODIFICATIONS_FILE) ?: ''), true)) {
	foreach ($fileData as $k => $mod) {
		$db[$mod['db']] = [
			'dsn'			=> '',
			'hostname' 		=> 'localhost',
			'username' 		=> config_item('db_user'),
			'password' 		=> config_item('db_pass'),
			'database' 		=> $mod['db'],
			'dbdriver' 		=> 'mysqli',
			'dbprefix' 		=> '',
			'pconnect' 		=> FALSE,
			'db_debug' 		=> (ENVIRONMENT !== 'production'),
			'cache_on' 		=> FALSE,
			'cachedir' 		=> '',
			'char_set' 		=> 'utf8',
			'dbcollat' 		=> 'utf8_general_ci',
			'swap_pre' 		=> '',
			'encrypt' 		=> FALSE,
			'compress' 		=> FALSE,
			'stricton' 		=> FALSE,
			'failover' 		=> $db['default'],
			'save_queries' 	=> TRUE
		];
	}
}