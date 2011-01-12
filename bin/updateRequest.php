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

function getRequests($importReqID, &$dbh) {

    $requests = array();
    $rowCount = 0;

    $querySQL = "SELECT p.partner_id, p.name, p.email, l.license_key, r.ticket, r.request_id, t.serial_number, l.serial_number
    		   FROM Licenses l, Partners p, Requests r, Terminals t
		  WHERE l.import_request_id = '${importReqID}'
		    AND p.partner_id = l.partner_id
		    AND r.terminal_stub = l.terminal_stub
		    AND r.status = 0
		    AND t.terminal_stub = l.terminal_stub
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
	    $requests[$i++] = array('partner_id'=>$row['0'],
				    'name'=>$row['1'],
				    'email'=>$row['2'],
				    'key'=>$row['3'],
				    'ticket'=>$row['4'],
				    'request_id'=>$row['5'],
				    'hw_sn'=>$row['6'],
				    'sw_sn'=>$row['7']);
	}
    }

    return $requests;
}


/****************************************
 *
 * send email responses and update request status
 *
 ****************************************/

function sendLicenseResponse($importReqID, $responses) {
    foreach($responses as $ticket=>$res) {
	// write response to a tmp file
	$filename = "/tmp/response-" . $ticket;
	$fh = fopen($filename, "w");
	if ($fh) {
	    if (fwrite($fh, $res)) {

		$r = shell_exec("/usr/bin/msmtp -C /home/license/LICENSES/msmtprc-request -t < " . $filename);
		if (!is_bool($r)) {
		    // successfully sent, need to update Request status
		    $updateStatusSQL = "UPDATE Requests SET status = 1
					 WHERE status = 0
					   AND terminal_stub IN (SELECT terminal_stub
								   FROM Licenses
								  WHERE Licenses.import_request_id = '${importReqID}')";
		    $res = mysql_query($updateStatusSQL, $dbh);

		    // remove response file
		    unlink($filename);
		}
	    }
	    fclose($fh);
	}
    }
}


/****************************************
 *
 * generate email responses to deliver newly imported licenses to requester
 *
 * return values:
 *
 *   array	: array of email responses
 *
 ****************************************/

function generateLicenseResponse($requests) {
    $last_ticket = "";
    $responses = array();
    $response = "";
    $boundary = @exec("uuid");

    foreach($requests as $req) {
	$ticket = $req['ticket'];
	$partner_id = $req['partner_id'];
	$name = $req['name'];
	$email = $req['email'];
	$key = $req['key'];
	$request_id = $req['request_id'];
	$hw_sn = $req['hw_sn'];
	$sw_sn = $req['sw_sn'];

	if ($ticket != $last_ticket) {

	    // new ticket, save previous response and generate a new response
	    if ($response != "") {
		$responses[$last_ticket] = $response;
		$response = "";
	    }

	    // generate email headers
	    $response = $response . sprintf("From: VIVIPOS License Service <license-request@vivipos.com.tw>\n");
	    $response = $response . sprintf("To: %s\n", $ticket);
	    $response = $response . sprintf("Subject: Requested VIVIPOS license(s) generated (Request ID: %s)\n", $request_id);
	    $response = $response . sprintf("Content-Type: multipart/mixed; boundary=%s\n\n", $boundary);

	    $response = $response . sprintf("--%s\n", $boundary);
	    $response = $response . sprintf("Content-Type: text/plain; charset=utf-8\n");
	    $response = $response . sprintf("Content-Transfer-Encoding: 7bit\n\n");
	    $response = $response . sprintf("Attached please find the license(s) that you have requested.\n\n");

	    $last_ticket = $ticket;
	}

	if (!empty($sw_sn) & $sw_sn != "") {
	    $file_name = $hw_sn . "-" . $sw_sn;
	}
	else {
	    $file_name = $hw_sn;
	}

	$response = $response . sprintf("--%s\n", $boundary);

	if ($partner_id == 'VIVIPOS SDK') {
	    $response = $response . sprintf("Content-Type: application/octet-stream; name=\"%s.txt\"\n", $file_name);
	    $response = $response . sprintf("Content-Disposition: attachment; filename=\"%s.txt\"\n\n", $file_name);
	    $response = $response . sprintf("%s\n\n", $key);
	}
	else {
	    $response = $response . sprintf("Content-Type: application/octet-stream; name=\"%s.lic\"\n", $file_name);
	    $response = $response . sprintf("Content-Disposition: attachment; filename=\"%s.lic\"\n\n", $file_name);
	    $response = $response . sprintf("[%s]\nname=%s\nemail=%s\nsigned_key=%s\n\n", $partner_id, $name, $email, $key);
	}
    }
    if ($response != "") {
	$response = $response . sprintf("--%s\n", $boundary);
	$responses[$ticket] = $response;
    }
    return $responses;
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
    if (count($requests) > 0) {
	$responses = generateLicenseResponse($requests);

	if (is_array($responses) && count($responses) > 0) {
	    sendLicenseResponse($argv[1], $responses);
	}
    }
}
else {
    echo "SQL error: [" . mysql_error($dbh) . "] (" . $requests . ")";
}

?>
