#!/bin/bash

DIR="/tmp/qsf"
LOG="/tmp/qsf.log"

HOST="localhost"
PORT="3214"

if [ -f ~/.qsfrc ]; then
	source ~/.qsfrc
else
	echo "Auto-creating ~/.qsfrc with default values"
	echo "HOST=\"${HOST}\"" > ~/.qsfrc
	echo "PORT=\"${PORT}\"" >> ~/.qsfrc
fi

rm -rf "${DIR}"
mkdir -p "${DIR}"

echo "----- Links:"
echo ""
for i in "$@"; do
	ln -s "$i" "${DIR}"
	STRIPPED=$(echo "$i" | sed 's|/$||g' | sed 's|^.*/||g')
	ENCODED="${STRIPPED// /%20}"
	echo "http://${HOST}:${PORT}/${ENCODED}"
done
echo ""
echo "----- Server log:"

rm -f "${LOG}"
touch "${LOG}"
tail -f "${LOG}" &  # will not die, be careful
mongoose -listening_port "${PORT}" -document_root "${DIR}" -access_log_file "${LOG}"
