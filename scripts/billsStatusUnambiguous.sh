#!/bin/bash

# Get the bills from a session of congress and separate them into pass/fail groups
# Pass is defined as (voting) result=pass
# Fail is defined as (voting) result=fail

# Input: congress number, (opt) number of bills
# Output: govtrak.us link of all bills that pass and failed (text file)

if [ $# -lt 1 ]; then
	echo "usage:" $0 " congress_number [number_of_bills]"
	echo
	exit 1
fi

CONGRESS=$1
billsfile="tempcongressdata.txt"
if [ -e $billsfile ]; then rm $billsfile; fi

# get number of bills
a=`wget -q 'https://www.govtrack.us/api/v2/bill?congress='$CONGRESS'&limit=500&offset=0' -O - | grep -m 1 "total_count"`
NUM_BILLS=`echo $a | cut -d' ' -f2`


# optional: user input number of bills
if [ "$#" -gt 1 ]; then
	if [ $(($2%500)) -ne 0 ]; then
		echo "sorry, number of bills input must be a multiple of 500"
		exit 1
	fi

	NUM_BILLS=$2
fi

echo "getting " $NUM_BILLS " bills..."

OFFSET=0

# get all bills
while [ $OFFSET -lt $NUM_BILLS ]; do
	wget -q 'https://www.govtrack.us/api/v2/bill?congress='$CONGRESS'&limit=500&offset='$OFFSET -O - >> $billsfile
	let OFFSET=$OFFSET+500
done

# get "link" field for each bill and bill result
passfile="./pass$CONGRESS.txt"
failfile="./fail$CONGRESS.txt"
if [ -e $passfile ]; then rm $passfile; fi
if [ -e $failfile ]; then rm $failfile; fi

BILL_LINK="\"link\": \"https://www.govtrack.us/congress/bills/"
bill_status="ambiguous"

# bills explicitly pass only if they're enacted or vetoed by the president
PASS_RESULT_1="state=\"ENACTED:SIGNED\""
PASS_RESULT_2="state=\"PROV_KILL:VETO\""
FAIL_RESULT="result=\"fail\""


echo "sorting bills..."

while read line; do
    if [[ $line == *$BILL_LINK* ]]; then
		# write the result of the last bill to file
		# only if it explicitly passed or failed the last time
		if [[ $bill_status == "passed" ]]; then
			echo $link | cat >> $passfile
		elif [[ $bill_status == "failed" ]]; then
			echo $link | cat >> $failfile
		fi

		link=$line
		link=`echo $link | cut -d' ' -f2 | tr -d \" | tr -d ,`
		bill_status="ambiguous"

    elif [[ $line == *"result="* ]]; then
    	#echo $line
    	#sleep 1
		# save last result of this bill to var 'bill_status'
		# for multiple voting records, this records the last one 
		if [[ $line == *"result=\"fail\""* ]]; then
			bill_status="failed"
		else
			bill_status="ambiguous"
		fi
	elif [[ $line == *"state="* ]]; then
		if [[ $line == *$PASS_RESULT_1* ]]; then
			bill_status="passed"
		elif [[ $line == *$PASS_RESULT_2* ]]; then
			bill_status="passed"
		else
			bill_status="ambiguous"
		fi
    fi
done < $billsfile

# remove duplicated from pass file
# duplicates are made when a bill passes multiple times in it's history
cat $passfile | uniq | cat > uniqpass.txt
mv uniqpass.txt $passfile
rm $billsfile

echo "bills are in " $passfile " and " $failfile
