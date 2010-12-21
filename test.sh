#!/bin/sh

############################################################################
#
# validate_licnse
#
# validate license file
#
# @args: <partner id> <partner key> 
#
############################################################################

validate_license() {
    local PARTNER_ID=$1
    local PARTNER_KEY=$2

    if [ -z "${PARTNER_ID}" ]; then
	REASON="Partner ID is empty"
	return 1
    fi

    if [ -z "${PARTNER_KEY}" ]; then
	REASON="Partner key is empty"
	return 1
    fi

    local KEY_LEN=`echo -n $STUB | wc -c`
    if [ ${KEY_LEN} -ne 128 ]; then
	REASON="License key length is not 128 bytes (${KEY_LEN})"
	return 1
    fi

    return 0
}

############################################################################
#
# store_license
#
# store partner license in db
#
# @args: <terminal stub> <order number> <partner id> <partner key>
#
############################################################################

store_license() {
}

############################################################################
#
# process_license
#
# process license file
#
# @args: <partner license file>
#
############################################################################

process_license() {

    local LICENSE_FILE=$1

    LICENSES=`sed -n '
		# extract partner ID
		/^\[.*\]/, /^signed_key=/ {
		    /^\[.*\]/ {
			s/^\[\(.*\)\]/\1/;h
		    }
		    /^signed_key=/!d
		    /^signed_key=/ {
			s/^signed_key\(.*\)/\1/
			H
			g
			s/^\(.*\)\n\(.*\)$/\1\2/
			p
		    }
		}
		' < "${LICENSE_FILE}"`

    for license in ${LICENSES}; do
	PARTNER_ID=`echo "${license}" | awk -F= '{print $1}'`
	PARTNER_KEY=`echo "${license}" | awk -F= '{print $2}'`

	# log output
	echo "${PARTNER_KEY}" >> "${REQDIR}/${REQUEST_ID}/license-${SERIAL}-${PARTNER_ID}"

	# are data valid?
	validate_license "${PARTNER_ID}" "${PARTNER_KEY}"
	if [ "$?" -ne 0 ]; then
	    echo "ORDER <${ORDER_NO}> FILE <${SERIAL}> TYPE <PARTNER> PARTNER <${PARTNER_ID}> REASON <${REASON}>" >> "${REQDIR}/${REQUEST_ID}/rejected.log"
	    echo "[${PARTNER_ID}]" >> "${REQDIR}/${REQUEST_ID}/bad-license-${SERIAL}-${PARTNER_ID}
	    echo "signed_key=${PARTNER_KEY}" >> "${REQDIR}/${REQUEST_ID}/bad-license-${SERIAL}-${PARTNER_ID}
	    echo >> "${REQDIR}/${REQUEST_ID}/bad-license-${SERIAL}-${PARTNER_ID}
	else

	    # attempt to insert into DB
	    store_license "${license_stub}" "${ORDER_NO}" "${PARTNER_ID}" "${PARTNER_KEY}"
	    if [ "$?" -ne 0 ]; then
		echo "ORDER <${ORDER_NO}> FILE <${SERIAL}> TYPE <PARTNER> PARTNER <${PARTNER_ID}> REASON <${REASON}>" >> "${REQDIR}/${REQUEST_ID}/rejected.log"
		echo "[${PARTNER_ID}]" >> "${REQDIR}/${REQUEST_ID}/failed-license-${SERIAL}-${PARTNER_ID}
		echo "signed_key=${PARTNER_KEY}" >> "${REQDIR}/${REQUEST_ID}/failed-license-${SERIAL}-${PARTNER_ID}
		echo >> "${REQDIR}/${REQUEST_ID}/failed-license-${SERIAL}-${PARTNER_ID}
		return 1
	    else
		echo "ORDER <${ORDER_NO}> FILE <${SERIAL}> TYPE <PARTNER> PARTNER <${PARTNER_ID}>" >> "${REQDIR}/${REQUEST_ID}/imported.log"
	    fi
	fi
    done
}

process_license /etc/vivipos_partners.lic
