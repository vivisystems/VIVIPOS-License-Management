<?php

/*
 * generateRequestEmail
 *
 * return values:
 *
 * true: 	response file written successfully
 * false:	failed to generate response file
 */

function sendRequestEmail($vars) {
    $file = '/tmp/license-request.' . getmypid();
    $boundary = '90e6ba6e8a9ad920480499176040';
    $res = $fh = @fopen($file, "w");
    if ($fh) {
	
	$res = $res && fprintf($fh, "From: %s <%s>\n", $vars['name'], $vars['email']);
	$res = $res && fprintf($fh, "To: license-request@vivipos.com.tw\n");
	$res = $res && fprintf($fh, "Reply-To: %s\n", $vars['email']);
	$res = $res && fprintf($fh, "Subject: License Request (via License Helper)\n");
	$res = $res && fprintf($fh, "X-Message-ID: <%s>\n", $vars['msg_id']);
	$res = $res && fprintf($fh, "Content-Type: multipart/mixed; boundary=%s\n\n", $boundary);

	$res = $res && fprintf($fh, "--%s\n", $boundary);
	$res = $res && fprintf($fh, "Content-Type: text/plain; charset=UTF-8\n\n");

	$res = $res && fprintf($fh, "[Customer]\n");
	$res = $res && fprintf($fh, "Name: %s\n", $vars['name']);
	$res = $res && fprintf($fh, "Email: %s\n\n", $vars['email']);

	$res = $res && fprintf($fh, "[Identification]\n");
	$res = $res && fprintf($fh, "Hardware Serial Number: %s\n", $vars['hw_sn']);
	$res = $res && fprintf($fh, "Software Serial Number: %s\n\n", $vars['sw_sn']);

	$res = $res && fprintf($fh, "[Software Details]\n");
	$res = $res && fprintf($fh, "SDK Version : %s\n", $vars['sdk_version']);
	$res = $res && fprintf($fh, "App Version : %s\n", $vars['app_version']);
	$res = $res && fprintf($fh, "OS Version : %s\n", $vars['os_version']);
	$res = $res && fprintf($fh, "License Helper Version: %s\n\n", $vars['license_helper_version']);

	$res = $res && fprintf($fh, "[Comment]\n");
	$res = $res && fprintf($fh, "%s\n\n", $vars['comment']);

	// attachment
	$res = $res && fprintf($fh, "--%s\n", $boundary);
	$res = $res && fprintf($fh, "Content-Type: application/octet-stream; name=\"license_stub.txt\"\n");
	$res = $res && fprintf($fh, "Content-Disposition: attachment; filename=\"license_stub.txt\"\n\n");

	$res = $res && fprintf($fh, "dallas=%s\n", $vars['dallas']);
	$res = $res && fprintf($fh, "system_name=%s\n", $vars['system']);
	$res = $res && fprintf($fh, "vendor_name=%s\n", $vars['vendor']);
	$res = $res && fprintf($fh, "mac_address=%s\n", $vars['mac']);
	$res = $res && fprintf($fh, "license_stub=%s\n", $vars['stub']);
	$res = $res && fprintf($fh, "--%s\n", $boundary);

	$res = fclose($fh) && $res;

	if ($res) {
	    // send email
	    exec('/usr/bin/msmtp -t < ' . $file, $output = array(), &$status);
	    $res = ($status == 0);

	    unlink($file);
	}
    }
    return $res;
}


/*
 * getLicenses
 *
 * return values:
 *
 * array	: rows of matching licenses (SDK & partner)
 * 0		: no matching licenses, and no open requests
 * -1		: no matching licenses, but one or more open requests exist
 * -2		: SQL error
 */

function getLicenses($stub, &$dbh) {

    // retrieve partner licenses
    $queryLicenseSQL = "SELECT p.partner_id, p.name, p.email, l.license_key FROM Licenses l, Partners p WHERE l.terminal_stub='{$stub}' AND l.partner_id = p.partner_id";
    $res = mysql_query($queryLicenseSQL, $dbh);
    $rowCount = 0;

    if (!$res) {
    	// explicitly check for mysql error
	if (mysql_errno($dbh) != 0) {
	    // SQL error
	    return -2;
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
	$licenses = array();

	while ($row = mysql_fetch_row($res)) {
	    $licenses[$row['0']] = array('name'=>$row['1'], 'email'=>$row['2'], 'key'=>$row['3']);
	}

	return $licenses;
    }else {
	// open request exists?
	$requestSQL = "SELECT count(*) from Requests WHERE terminal_stub='{$stub}' AND status=0";
	$res = mysql_query($requestSQL, $dbh);

	if (!$res) {
	    // SQL error
	    return 0;
	}

	$row = mysql_fetch_row($res);
	if (!$row) {
	    // SQL error
	    return 0;
	}

	if ($row['0'] > 0) {
	    // one or more open requests found
	    return -1;
	}

	return 0;
    }
}

?>
