<?php
/**
 * CONFIG
 *
 * Require site config.
 */
require_once('../../config/config.php');
require_once('../../config/constants.php');
require_once('./functions.php');
require_once('./license_functions.php');

/* 
 * VARIABLES
 *
 *  Initialize, set up and clean variables.
 */

// Required variables that we need to run the script.
$required_vars = array(
    'name',
    'email',
    'stub',
    'hw_sn',
    'sw_sn',
    'sdk_version',
    'app_version',
    'os_version',
    'license_helper_version'
);

// Optional variables
$optional_vars = array(
    'dallas',
    'mac',
    'system',
    'vendor',
    'comment'
);

// Debug flag.
$debug = isset($_GET['debug']) ? true : false;

// Test flag.
$test = isset($_GET['test']) ? true : false;

// Output
$output = "";

// Array for hold error messafges
$errors = array();

// Iterate through required variables, and escape/assign them as necessary.
foreach ($required_vars as $var) {
    if (empty($_GET[$var])) {
        $errors[] = 'Required variable ['.$var.'] not set.'; // set debug error
    }
}

/**
 * DATABASE
 *
 * Connect to and select proper database.  By default the update script uses SHADOW.
 *
 * In order for testing to work, we can add a query variable specifying that the incoming request is for testing only.
 */

// Are we trying to run a test?  If so, use the test db.
if ($test) {
    $dbh = @mysql_connect(TEST_DB_HOST.':'.TEST_DB_PORT,TEST_DB_USER,TEST_DB_PASS);

    if (!is_resource($dbh)) {
        $errors[] = 'MySQL connection to TEST DB failed.';
    } elseif (!@mysql_select_db(TEST_DB_NAME, $dbh)) {
        $errors[] = 'Could not select TEST database '.TEST_DB_NAME.'.';
    }

// If we're trying to detect installed add-ons, we need write access
} else {
    $dbh = @mysql_connect(DB_HOST.':'.DB_PORT,DB_USER,DB_PASS);

    if (!is_resource($dbh)) {
        $errors[] = 'MySQL connection to DB failed.';
    } elseif (!@mysql_select_db(LICENSE_DB_NAME, $dbh)) {
        $errors[] = 'Could not select database '.LICENSE_DB_NAME.'.';
    }

}


// uncomment to suspend license request
//$errors[] = "License request is temporarily unavailable; please try again later";

/*
 *  QUERIES
 *
 *  Our variables are there and we're connected to the database.
 *  Now we can format our data for SQL then attempt to retrieve update information.
 */
if (empty($errors)) {

    // Iterate through required variables, and escape/assign them as necessary.
    foreach (array_merge($required_vars, $optional_vars) as $var) {
	$sql[$var] = mysql_real_escape_string($_GET[$var]);
    }

    $ip = $_SERVER['REMOTE_ADDR'];
    $req = $_SERVER['SCRIPT_NAME'];

    $Licenses = getLicenses($sql["stub"], $dbh);

    if(is_array($Licenses)) {

	// license already exists
	$output = -3;

    }
    else  {

	switch($Licenses) {

	    case 0:
		// no matching licenses, and no open requests

		// send license request email
		if (sendRequestEmail($_GET)) {

		    // insert Request
		    $insertSQL = "INSERT into Requests(request_id, ip_address, customer_name, email, annotations,
						       terminal_stub, dallas_key, system_name, vendor_name, mac_address,
						       sdk_version, app_version, os_version, lic_helper_version,
						       hw_serial_number, sw_serial_number,
						       status, created_on, created_by)
					    values(NULL,
						   '{$ip}',
						   '{$sql["name"]}',
						   '{$sql["email"]}',
						   '{$sql["comment"]}',
						   '{$sql["stub"]}',
						   '{$sql["dallas"]}',
						   '{$sql["system"]}',
						   '{$sql["vendor"]}',
						   '{$sql["mac"]}',
						   '{$sql["sdk_version"]}',
						   '{$sql["app_version"]}',
						   '{$sql["os_version"]}',
						   '{$sql["license_helper_version"]}',
						   '{$sql["hw_sn"]}',
						   '{$sql["hw_sn"]}',
						   0,
						   NOW(),
						   '{$req}')";

		    $res = mysql_query($insertSQL, $dbh);

		    // ignore SQL error here since request is already sent
		    $output = 0;
		}
		else {
		    $output = -2;
		}
		break;

	    case -1:
		// no matching licenses, but one or more open requests
		$output = -1;
		break;

	    case -2:
		// SQL error
		$output = -2;
		break;

	}
    }

}

// if errors , response error messages.
if (!empty($errors)) {
    $output = implode("\n", $errors);
}

/**
 * OUTPUT
 *
 * Generate our XML output.  We are assuming that we did not have to echo debug information.
 *
 * We will encode using UTF-8 for all update metadata, and display an empty XML document if there were no updates found.
 */

header('Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0, private');
header('Pragma: no-cache');
header('Content-type: text/plain');

echo $output;

exit;


?>
