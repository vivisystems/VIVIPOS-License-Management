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
    'dallas',
    'mac',
    'stub',
    'version'
);

// Optional variables that we like to capture
$optional_vars = array(
    'system',
    'vendor',
    'sdk_version',
    'app_version',
    'os_version',
    'license_helper_version'
);

$sdkLicense = "" ;
$partnerLicenses = "";

// Debug flag.
$debug = isset($_GET['debug']) ? true : false;

// Test flag.
$test = isset($_GET['test']) ? true : false;

// Array to hold errors for debugging.
$errors = array();

// Iterate through required variables, and escape/assign them as necessary.
foreach ($required_vars as $var) {
    if (empty($_GET[$var])) {
        $errors[] = 'Required variable '.$var.' not set.'; // set debug error
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


// uncomment to suspend license download
//$errors[] = "License download is temporarily unavailable; please try again later";

/*
 *  QUERIES
 *
 *  Our variables are there and we're connected to the database.
 *  Now we can format our data for SQL then attempt to retrieve update information.
 */
if (empty($errors)) {

// Iterate through required and optional variables, and escape/assign them as necessary.
    foreach (array_merge($required_vars, $optional_vars) as $var) {
        $sql[$var] = mysql_real_escape_string($_GET[$var]);
    }

    // Check License helper version to determine available data
    if (empty($_GET['license_helper_version'])) {
	$sdk_version = $sql['version'];
	$app_version = '';
	$os_version = '';
	$license_helper_version = '1.2';
    }
    else {
	$sdk_version = $sql['sdk_version'];
	$app_version = $sql['app_version'];
	$os_version = $sql['os_version'];
	$license_helper_version = $sql['license_helper_version'];
    }


    $ip = $_SERVER['REMOTE_ADDR'];
    $req = $_SERVER['REQUEST_URI'];

    // strip dallas identify and checksum
    if(strlen($sql["dallas"]) == 16) {
        $sql["dallas"] = substr($sql["dallas"], 2, 12);
    }

    $Licenses = getLicenses($sql['stub'], $dbh);

    if(is_array($Licenses)) {

	$mesg = "";
	foreach($Licenses as $partner=>$value) {
	    $mesg = $mesg . "Partner [" . $partner . "] Name [" . $value['name'] . "] email [" . $value['email'] . "] key [" . $value['key'] . "]\n";
	}

	//$errors[] = $mesg;

	// Look for SDK license (partner ID VIVIPOS SDK)
	if (!empty($Licenses['VIVIPOS SDK'])) {

	    // license(s) found,insert download record(s)

	    foreach($Licenses as $partner=>$value) {
		$insertSQL = "INSERT into Downloads(terminal_stub, partner_id, ip_address, sdk_version, app_version, os_version, license_helper_version, download_request_id, created, created_by)
				     values('{$sql["stub"]}', '{$partner}', '{$ip}', '{$sql["sdk_version"]}', '{$sql["app_version"]}', '{$sql["os_version"]}', '{$sql["license_helper_version"]}',
				     NULL, NOW(), '{$req}')";

		$res2 = mysql_query($insertSQL, $dbh);

		if ($partner == 'VIVIPOS SDK') {
		    $sdkLicense = $value['key'];
		}
		else {
		    $partnerLicenses = sprintf("%s%s\t%s\t%s\t%s\n", $partnerLicenses, $partner, $value['name'], $value['email'], $value['key']);
		}

	    }
	}
	else {
	    $errors[] = "This machine has not been licensed for VIVIPOS SDK yet";
	}

    }else {
	if($Licenses == 0) {
	    if (empty($license_helper_version) || ($license_helper_version <= 1.2)) {
		$errors[] = "This machine has not been licensed";
	    }
	}
	else if($Licenses == -1) {
	    $errors[] = "A license request for this machine is pending. Please contact your sales rep for assistance";
	}
	else {
	    $errors[] = "License download is temporarily unavailable due to technical issues. Please try again later ({$Licenses})";
	}
    }

}

// if errors , response error messages.
if (!empty($errors)) {
    $sdkLicense = implode("\n", $errors);
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

// if license helper version exists, then helper can accept partner licenses
if (!empty($license_helper_version) && ($license_helper_version > 1.2)) {

    if (strlen($partnerLicenses) > 0) {
	echo $sql['stub'] . "\n";
	echo $sdkLicense . "\n";
	echo $partnerLicenses;
    }
    else if ($Licenses == 0) {
	echo $sql['stub'] . "\n";
    }
    else {
	echo $sdkLicense;
    }
}
else {
    echo $sdkLicense;
}

exit;


?>
