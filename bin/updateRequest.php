<?php
/**
 * CONFIG
 *
 * Require site config.
 */
require_once('/var/www/update/addons/app/config/config.php');
require_once('/var/www/update/addons/app/config/constants.php');

/****************************************
 *
 * print usage
 *
 ****************************************/

function usage($script) {
    fprintf(STDERR, "usage: %s <import request id>\n", $script);
}

/****************************************
 *
 * retrieve requests fulfilled by the import
 *
 * return values:
 *
 *   array	: array of licenses (may be empty)
 *   false	: SQL error
 *
 ****************************************/

function getRequests($reqID, &$dbh) {

    $requests = array();
    $rowCount = 0;

    $querySQL = "SELECT p.partner_id, p.name, p.email, l.license_key, r.ticket
    		   FROM Licenses l, Partners p, Requests r
		  WHERE l.import_request_id = '${reqID}'
		    AND p.partner_id = l.partner_id
		    AND r.terminal_stub = l.terminal_stub
		    AND r.status = 0
		ORDER BY r.ticket";
    $res = mysql_query($querySQL, $dbh);

    if (!$res) {
	if (mysql_errno($dbh) != 0) {
	    // SQL error
	    return -1;
	}
    }
    else {
	$rowCount = mysql_num_rows($res);
	if (!$rowCount) {
	    if (mysql_errno($dbh) != 0) {
		// SQL error
		return -2;
	    }
	}
    }

    if ($rowCount > 0) {
	$i = 0;
	while ($row = mysql_fetch_row($res)) {
	    $requests[$i++] = array('partner_id'=>$row['0'], 'name'=>$row['1'], 'email'=>$row['2'], 'key'=>$row['3'], 'ticket'=>$row['4']);
	}
    }

    return $requests;
}


/****************************************
 *
 * main
 *
 ****************************************/

if ($argc != 2) {
    usage($argv[0]);
    exit(1);
}

/**
 * DATABASE
 *
 * Connect to and select proper database.  By default the update script uses SHADOW.
 *
 */

$dbh = @mysql_connect(DB_HOST.':'.DB_PORT,DB_USER,DB_PASS);

if (!is_resource($dbh)) {
    $errors[] = 'MySQL connection to DB failed.';
} elseif (!@mysql_select_db(LICENSE_DB_NAME, $dbh)) {
    $errors[] = 'Could not select database '.LICENSE_DB_NAME.'.';
}

$requests = getRequests($argv[1], $dbh);

if (is_array($requests)) {
    // iterate over requests, generate license file(s) for each request, and email back to support system
}
else {
    echo "SQL error: [" . mysql_error($dbh) . "] (" . $requests . ")";
}

?>
