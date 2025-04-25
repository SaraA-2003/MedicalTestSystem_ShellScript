# Shiyar Mohammad - 1210766 - sec: 3
# Sara Allahaleh  - 1211083 - sec: 5


#_________________________________TESTS RESULTS____________________________

Hgb_low=$(grep "Hgb" medicalTest.txt | cut -d";" -f2 | cut -d":" -f2 | cut -d"," -f1 | cut -d">" -f2)
Hgb_high=$(grep "Hgb" medicalTest.txt | cut -d";" -f2 | cut -d":" -f2 | cut -d"," -f2 | cut -d"<" -f2) 

BGT_low=$(grep "BGT" medicalTest.txt | cut -d";" -f2 | cut -d":" -f2 | cut -d"," -f1 | cut -d">" -f2) 
BGT_high=$(grep "BGT" medicalTest.txt | cut -d";" -f2 | cut -d":" -f2 | cut -d"," -f2 | cut -d"<" -f2) 

LDL_res=$(grep "LDL" medicalTest.txt | cut -d";" -f2 | cut -d"<" -f2) 
systole_res=$(grep "systole" medicalTest.txt | cut -d";" -f2 | cut -d"<" -f2) 
diastole_res=$(grep "diastole" medicalTest.txt | cut -d";" -f2 | cut -d"<" -f2) 

#**************************************************************

touch temp.txt #creat file to work as array to store retrieved data


#*************************************************

#_________________________display menu function_______________________________

display_menu(){
printf "\nChoose an operation:\n"
printf "1) Add a new medical test record.\n"
printf "2) Search for a test by patient ID.\n"
printf "3) Search for up normal tests.\n"
printf "4) Average test value.\n"
printf "5) Update an existing test result.\n"
printf "6) Delete an existing record.\n"
printf "7) Exit.\n\n"

}
#*********************************************************

#__________________________function to add new test_________________________________

addRecord(){

#read id
printf "\nEnter patient ID - 7 digits:\n"
read id

while [ true ]
do
	#check the validity for the id
	if  echo "$id" | grep -q '^[0-9]\{7\}$' 
	then
	break

	else

	printf "\n\tInvalid id! it should be (integer- 7 digits):\n"
	read id
fi
done

#read test name
while [ true ]
do 	#dispaly test names
	printf "\nChoose the test name:\n"
	printf "\n1)Hemoglobin (Hgb)\n"
	printf "2)Blood Glucose Test (BGT)\n"
	printf "3)Cholesterol Low-Density Lipoprotein (LDL)\n"
	printf "4)Systolic Blood Pressure (systole)\n"
	printf "5)Diastolc Blood Pressure (diastole)\n\n"

	read testN
#check the validity
case "$testN"
in
    1) testName="Hgb"
	break;;
    2) testName="BGT"
	break;;
    3) testName="LDL"
	break;;
    4) testName="systole"
	break;;
    5) testName="diastole"
	break;;

    *) printf "\n\tInvalid choice. Please choose again..\n"
   ;;
esac
done

#read year
printf "\nEnter the year (YYYY) :\n"
read year

#check the validity of the year
while [ $(( $(echo $year | wc -c) -1)) -ne 4 -o $year -gt 2024 -o $year -le 0 ]
do
	printf "\n\tInvalid year. Try again!\n"
	read year
done

#read month
printf "\nEnter the month 01-12 (MM) :\n"
read month
mValid=$(( $(echo $month | wc -c) -1))
#check the validity
while [ $mValid -ne 2 -o  $month -lt 1 -o $month -gt 12 ]
do
	printf "\n\tInvalid month. Try again!\n"
	read month
	mValid=$(( $(echo $month | wc -c) -1))
done

#read result 
printf "\nEnter the result:\n"
read res

#check the validity for the result
while ! echo "$res" | grep -Eq '^[0-9]+(\.[0-9]+)?$'
do
printf "\nInvalid result! Please try again....\n"
read res
done


#set the unit according to the name
unit=$( grep "$testName" medicalTest.txt | cut -d";" -f3 | cut -d":" -f2 | xargs)

#read the status
while [ true ]
do
	printf "\nChoose the status of the test:\n"
	printf "\n1)Pending\n"
	printf "2)Completed\n"
	printf "3)Reviewed\n"

read testS
#check the validity
case "$testS"
in
    1) status="pending"
        break;;
    2) status="completed"
        break;;
    3) status="reviewed"
        break;;

    *) printf "\n\tInvalid choice. Please choose again..\n"
   ;;
esac
done

#add the new record to the file
echo "$id: $testName, $year-$month, $res, $unit, $status" >> medicalRecord.txt
printf "\n\t\tTHE RECORD HAS BEEN ADDED SUCCESSFULLY\n"
}

#****************************************************************
#_______________function to retrieve the up normal tests for a patient________________________

up_normal_patient (){

PID="$1"  #first arg
cat /dev/null > temp.txt
#loop on the output of the grep, to determine the test type and the result 
grep "$PID"  medicalRecord.txt | while read line
do
test=$(echo "$line" | cut -d":" -f2 | cut -d"," -f1 | cut -d" " -f2) #the test type
res=$(echo "$line" | cut -d"," -f3 | cut -d" " -f2) #the result of the test
case "$test" in
	"Hgb") if [ "$(echo "$res <= $Hgb_low" | bc -l)" -eq 1  ] || [ "$(echo "$res >= $Hgb_high" | bc -l)" -eq 1  ]
                then 
                        echo "$line" | cut -d":" -f2 | cut -d" " -f2-9 >> temp.txt
                fi;;
	 "BGT") if [ "$(echo "$res <= $BGT_low" | bc -l)" -eq 1  ] || [ "$(echo "$res >= $BGT_high" | bc -l)" -eq 1 ]
                then 
                        echo "$line" | cut -d":" -f2 | cut -d" " -f2-9 >> temp.txt
                fi;;
	 "LDL") if [ "$(echo "$res <= $LDL_res" | bc -l)" -eq 1 ]
                then 
                        echo "$line" | cut -d":" -f2 | cut -d" " -f2-9 >> temp.txt
                fi;;
	"systole") if [ "$(echo "$res <= $systole_res" | bc -l)" -eq 1 ]
                then 
                        echo "$line" | cut -d":" -f2 | cut -d" " -f2-9 >> temp.txt
                fi;;
	"diastole") if [ "$(echo "$res <= $diastole_res" | bc -l)" -eq 1 ]
                then 
                        echo "$line" | cut -d":" -f2 | cut -d" " -f2-9 >> temp.txt
                fi;;
esac
done
if [ -s temp.txt ]
then
cat temp.txt
else
printf "\t\t\tThere is no data\n"
fi
return

}

#****************************************************************
#___________________retrieve patient tests for a given period of time________________________________
patient_tests_period (){

PID="$1" # parameter
cat /dev/null > temp.txt

#----------------------------------------------------- 
#read the first period
printf "\n----Enter the periods from the past to the present----"
printf "\nEnter the first period\n"
#read and check year
printf "\nEnter year (YYYY):\n"
read year1
while [ $(( $(echo "$year1" | wc -c) -1 )) -ne 4 -o $((year1)) -le 0 -o $((year1)) -gt 2024 ]
do
printf "\nInvalid year. Please enter a valid year:\n"
read year1
done

#read and check month 
printf "\nEnter month (MM):\n"
read month1
while [ $(( $(echo "$month1" | wc -c) -1 )) -ne 2 -o $((month1)) -lt 1 -o $((month1)) -gt 12 ]
do
printf "\nInvalid month. Please enter a valid month:\n"
read month1
done

#read second period
printf "\n\nEnter the second period\n"
#read year
printf "\nEnter year (YYYY):\n"
read year2
while [ $(( $(echo "$year2" | wc -c) -1 )) -ne 4 -o $((year2)) -le 0 -o $((year2)) -gt 2024 ]
do
printf "\nInvalid year. Please enter a valid year:\n"
read year2
done

#read and check month 
printf "\nEnter month (MM):\n"
read month2
while [ $(( $(echo "$month2" | wc -c) -1 )) -ne 2 -o $((month2)) -lt 1 -o $((month2)) -gt 12 ]
do
printf "\nInvalid month. Please enter a valid month:\n"
read month2
done
#----------------------------------------------

Sdate1="$year1-$month1"
Sdate2="$year2-$month2"
 

#loop to find the tests based on the PID and the first period
grep "$PID"  medicalRecord.txt | while read line
do
tempY=$(echo "$line" | cut -d"," -f2 | cut -d" " -f2 | cut -d"-" -f1)
tempM=$(echo "$line" | cut -d"," -f2 | cut -d" " -f2 | cut -d"-" -f2)

#if the grep return a year equal to year 1 and year 2 and the month is great or equal to month1 and less or equal to month 2 

if [ $((tempY)) -eq $((year1)) -a $((tempY)) -eq $((year2)) -a $((tempM)) -ge $((month1)) -a $((tempM)) -le $((month2 )) ] 
then 
         echo "$line" | cut -d":" -f2 | cut -d" " -f2-9 >> temp.txt  

#if the grep return a year equal to year1 but it should not equal year2 of the first period and the month is less or equal to the month of the first period 
elif [ $((tempY)) -eq $((year1)) -a $((tempM)) -ge $((month1)) -a $((tempY)) -ne $((year2)) ]
then
	echo "$line" | cut -d":" -f2 | cut -d" " -f2-9 >> temp.txt
	
#if the grep return a year equal to year2 but it should not equal year1 of the second period and the month is less or equal to the month of the second period 
elif [ $((tempY)) -eq $((year2)) -a $((tempM)) -le $((month2)) -a $((tempY)) -ne $((year1)) ]

then
	echo "$line" | cut -d":" -f2 | cut -d" " -f2-9 >> temp.txt
	
#if the grep return a year greater than year1 and less than year2 
elif [ $((tempY)) -gt $((year1)) -a $((tempY)) -lt $((year2)) ]
then
	echo "$line" | cut -d":" -f2 | cut -d" " -f2-9 >> temp.txt 
	
fi

done

return #retuen to sub_menue
}

#****************************************************************
#___________________retrieve patient tests for a given test status________________________________
patient_tests_status () {
PID="$1" # parameter

cat /dev/null > temp.txt

printf "\nEnter the test status (pending, completed, reviewed):\n"
read status
#check if status is valid
while [ "$status" != "pending" -a "$status" != "completed" -a "$status" != "reviewed" ]
do
printf "\nInvalid test status. Please enter a valid status:\n"
read status
done

empty=$(grep "$PID"  medicalRecord.txt| grep "$status")

#check if the output of the grep is empty 
if [ -z "$empty" ]
then
echo "             There is no data" >> temp.txt 
fi
#if there is data 

#loop to find the test with the given status
grep "$PID"  medicalRecord.txt| grep "$status" | while read line
do

echo "$line" | cut -d":" -f2 | cut -d" " -f2-9 >> temp.txt 

done

return
}


#********************************************************
#_____________function to retrieve the tests for a patient_______________
 
search_patientID () {

    printf "\nEnter the patient ID:\n"
    read PID
    # Check if the patient ID is 7 digit or not

while  [ true ]
do 

	if ! echo "$PID" | grep -q '^[0-9]\{7\}$'
	then
		 printf "\nInvalid ID number. Please enter a 7-digit number:\n"
        	 read PID
		 continue
	fi
	temp=$(grep "$PID"  medicalRecord.txt | wc -l | cut -d" " -f1 )
	if [ $((temp)) -eq 0 ]
	then
		 printf "\nThis ID does not exist. Please reenter the patient ID:\n"
	         read PID
		 continue
	elif [ $((temp)) -gt 0 ]
	then
		break
	fi
done


#operation 
while [ true ]
do 
printf "\nChoose the operation you want to perform:\n"
printf "\n1)Retrieve all patient tests\n"
printf "2)Retrieve all up normal patient tests\n"
printf "3)Retrieve all patient tests in a given specific period\n"
printf "4)Retrieve all patient tests based on test status\n"
printf "5)Exit submenu\n"

printf "\nEnter your choice:\n"
read op
case "$op"
in
        1) printf "\nHere is a list of all tests for patient ( $PID ) :\n\n" 
           grep "$PID" medicalRecord.txt | cut -d":" -f2 | cut -d" " -f2-9;; #return the tests and its detailes
        2) printf "\nHere is a list of all up normal tests for patient ( $PID ):\n"
		up_normal_patient "$PID";;
        3) patient_tests_period "$PID" 
		printf "\nHere is a list of all tests for patient ( $PID ) in period from ( $Sdate1 ) - ( $Sdate2 ):\n\n"
		if [ ! -s temp.txt ]
		then
                   printf "\t\t\tThere is no data" >> temp.txt
		fi
		cat temp.txt;;

        4) patient_tests_status "$PID" 
                printf "\nHere is a list of all tests for patient ( $PID ) with test status ( $status ) :\n\n"
                cat temp.txt;;

	5) return;;
        *) printf "\n\tInvalid choice. Please enter a number between 1 and 5\n\n";;

esac

done

return #return to main menue

}

#**********************************************************

#___________________searching for up normal test_________________

search_upnormal(){
#create a counter file
echo "0" > count.txt
while [ true ]
do
#display the names of the tests
printf "\nChoose the test name to search for up normal result:\n"
printf "\n1)Hemoglobin (Hgb)\n"
printf "2)Blood Glucose Test (BGT)\n"
printf "3)Cholesterol Low-Density Lipoprotein (LDL)\n"
printf "4)Systolic Blood Pressure (systole)\n"
printf "5)Diastolc Blood Pressure (diastole)\n"
printf "6)Exit this choice\n\n"
read testCh


case "$testCh"
in
    1) testchoice="Hgb"
	if [ $(grep "$testchoice" medicalRecord.txt | wc -l ) -gt 0 ]
	then 
      printf "\nHere is the list:\n"
      grep "$testchoice" medicalRecord.txt | while read line
	do
	#take the result of the test
	 Tres=$( echo "$line" | cut -d"," -f3)
	#check if it is abnormal
	 if (( $(echo "$Tres <= $Hgb_low" | bc -l) || $(echo "$Tres >= $Hgb_high" | bc -l) ))
           then
		echo "$line"
		icount=$( cat count.txt)
	     #increment the counter
	       icount=$(($icount + 1))
	       echo "$icount" > count.txt
	    fi
         done
	
	else
	   printf "\n There is no record for $testchoice.\n"
	   
fi
	;;

    2) testchoice="BGT"
	if [ $(grep "$testchoice" medicalRecord.txt | wc -l ) -gt 0 ]
	then
	printf "\nHere is the list:\n"
      grep "$testchoice" medicalRecord.txt | while read line
        do
         Tres=$( echo "$line" | cut -d"," -f3)
         if (( $(echo "$Tres <= $BGT_low" | bc -l) || $(echo "$Tres >= $BGT_high" | bc -l) )) 
           then
                echo "$line"
	        icount=$( cat count.txt)
               icount=$(($icount + 1))
               echo "$icount" > count.txt

            fi
         done

	else
		printf "\n There is no record for $testchoice.\n"
	
fi
	;;
    3) testchoice="LDL"
	if [ $(grep "$testchoice" medicalRecord.txt | wc -l) -gt 0 ]
	then
      printf "\nHere is the list:\n"
      grep "$testchoice" medicalRecord.txt | while read line
        do
         Tres=$( echo "$line" | cut -d"," -f3)
         if (( $(echo "$Tres >= $LDL_res" | bc -l) ))
            then
                echo "$line"
                icount=$( cat count.txt)
               icount=$(($icount + 1))
               echo "$icount" > count.txt

              fi
         done

	else
		printf "\n There is no record for $testchoice.\n"
fi
     ;;

    4) testchoice="systole"
	if [ $(grep "$testchoice" medicalRecord.txt | wc -l) -gt 0 ]
	then
	printf "\nHere is the list:\n"
      grep "$testchoice" medicalRecord.txt | while read line
        do
         Tres=$( echo "$line" | cut -d"," -f3)
         if (( $(echo "$Tres >= $systole_res" | bc -l) )) 
           then

                echo "$line"
                icount=$( cat count.txt)
               icount=$(($icount + 1))
               echo "$icount" > count.txt

            fi
         done

	else
		printf "\n There is no record for $testchoice.\n"
fi
	;;
    5) testchoice="diastole"
	if [ $(grep "$testchoice" medicalRecord.txt | wc -l ) -gt 0 ]
	then 
	printf "\nHere is the list:\n"
      grep "$testchoice" medicalRecord.txt | while read line
        do
         Tres=$( echo "$line" | cut -d"," -f3)
         if (( $(echo "$Tres >= $diastole_res" | bc -l) ))
           then

                echo "$line"
	        icount=$( cat count.txt)
               icount=$(($icount + 1))
               echo "$icount" > count.txt

            fi
         done

	else
		printf "\n There is no record for $testchoice\n"

fi
	;;
    6) return;;
    *) printf "\nInvalid choice. Please choose again..\n"
   ;;
esac
done

#check if there is a record then check the counter
 if [ $(grep "$testchoice" medicalRecord.txt | wc -l) -gt 0 ]
	then
	#check if all test results are normal
	finalcount=$( cat count.txt)

	if [ $finalcount -eq 0 ]
            then
           printf "\n ALL RESULTS FOR ($testchoice) IS NORMAL\n"
         fi
fi
         
}

#**********************************************************
#______________________________Average test results___________________

avg_res(){

Hgb_count=$(grep "Hgb" medicalRecord.txt | wc -l)
BGT_count=$(grep "BGT" medicalRecord.txt | wc -l)
LDL_count=$(grep "LDL" medicalRecord.txt | wc -l)
systole_count=$(grep "systole" medicalRecord.txt | wc -l)
diastole_count=$(grep "diastole" medicalRecord.txt | wc -l)

Hgb_sum=0
BGT_sum=0
LDL_sum=0
systole_sum=0
diastole_sum=0
 
while read line
do
name=$(echo "$line" | cut -d":" -f2 | cut -d"," -f1 | cut -d" " -f2)
res=$(echo "$line" | cut -d":" -f2 | cut -d"," -f3)
if [ "$name" = "Hgb" ]
then
	Hgb_sum=$(echo "$Hgb_sum + $res" | bc)
elif [ "$name" = "BGT" ]
then
	BGT_sum=$(echo "$BGT_sum + $res" | bc)
elif [ "$name" = "LDL" ]
then
        LDL_sum=$(echo "$LDL_sum + $res" | bc)
elif [ "$name" = "systole" ]
then
        systole_sum=$(echo "$systole_sum + $res" | bc)
elif [ "$name" = "diastole" ]
then
        diastole_sum=$(echo "$diastole_sum + $res" | bc)
fi
done < medicalRecord.txt

if [ "$(echo "$Hgb_count == 0" | bc)" -eq 1 ] || [ "$(echo "$Hgb_sum == 0" | bc)" -eq 1 ]
then
	Hgb_avg=0
else
 
	Hgb_avg=$(echo "scale=2; $Hgb_sum / $Hgb_count" | bc)
fi
if [ "$(echo "$BGT_count == 0" | bc)" -eq 1 ] || [ "$(echo "$BGT_sum == 0" | bc)" -eq 1 ]
then 
	BGT_avg=0
else
	BGT_avg=$(echo "scale=2; $BGT_sum / $BGT_count" | bc)
fi
if [ "$(echo "$LDL_count == 0" | bc)" -eq 1 ] || [ "$(echo "$LDL_sum == 0" | bc)" -eq 1 ] 
then
	LDL_avg=0
else
	LDL_avg=$(echo "scale=2; $LDL_sum / $LDL_count" | bc)
fi
if [ "$(echo "$systole_count == 0" | bc)" -eq 1 ] || [ "$(echo "$systole_sum == 0" | bc)" -eq 1 ] 
then
	systole_avg=0
else
	systole_avg=$(echo "scale=2; $systole_sum / $systole_count" | bc)
fi
if [ "$(echo "$diastole_count == 0" | bc)" -eq 1 ] || [ "$(echo "$diastole_sum == 0" | bc)" -eq 1 ] 
then
	diastole_avg=0
else
	diastole_avg=$(echo "scale=2; $diastole_sum / $diastole_count" | bc)
fi
printf "\nTHE AVERAGE TEST RESULTS ARE:\n"
echo "1) Hemoglobin(Hgb): $Hgb_avg g/dL"
echo "2) Blood Glucose Test(BGT): $BGT_avg mg/dL"
echo "3) Cholesterol Low-Density Lipoprotein(LDL): $LDL_avg mg/dL"
echo "4) Systolic Blood Pressure(systole): $systole_avg mm Hg"
echo "5) Diastolic Blood Pressure(diastole): $diastole_avg mm Hg"
}

#*********************************************************
update_result () {

cat /dev/null > temp.txt

printf "\nEnter the patient ID:\n"
read PID
#check if the id is exist and valid
while  [ true ]
do 

        if ! echo "$PID" | grep -q '^[0-9]\{7\}$'
        then
                 printf  "\nInvalid ID number. Please enter a 7-digit number:\n"
                 read PID
                 continue
        fi
        temp=$(grep "$PID"  medicalRecord.txt | wc -l | cut -d" " -f1 )
        if [ $((temp)) -eq 0 ]
        then
                 printf "\nThis ID does not exist. Please reenter the patient ID:\n"
                 read PID
                 continue
        elif [ $((temp)) -gt 0 ]
        then
                break
        fi
done
echo "\n"
i=0
grep "$PID"  medicalRecord.txt | while read line
do
res=$( echo "$line" | cut -d":" -f2 | cut -d" " -f2-9)
i=$((i + 1))
echo "$i)$res"
done


printf "\nEnetr the line you want to modify its test result:\n"
read op
i=0


grep "$PID"  medicalRecord.txt | while read line
do
i=$((i + 1))
if [ $((op)) -eq $((i)) ]
then
echo "$line" >> temp.txt 
fi
done

result=$(grep "$PID" temp.txt |cut -d":" -f2 | cut -d" " -f4 | cut -d"," -f1)
printf "\nEnter the new result of the choosen medical test:\n"
read new_result

while ! echo "$new_result" | grep -Eq '^[0-9]+(\.[0-9]+)?$'
do
	printf "\nInvalid result. Please try again...\n"
	read new_result
done
#record elements
test=$(grep "$PID" temp.txt | cut -d"," -f1 | cut -d":" -f2 | cut -d" " -f2)
date=$(grep "$PID" temp.txt| cut -d"," -f2 | cut -d" " -f2)
unite=$(grep "$PID" temp.txt| cut -d"," -f4 | cut -d" " -f2-3)
status=$(grep "$PID" temp.txt| cut -d"," -f5 | cut -d" " -f2)
old_line=$(grep "$PID" temp.txt)
new_line="$PID: $test, $date, $new_result, $unite, $status" #make the new record


old_lineE=$(printf '%s\n' "$old_line" | sed 's/[\/&]/\\&/g') #escape special char
new_lineE=$(printf '%s\n' "$new_line" | sed 's/[\/&]/\\&/g')

sed -i "s/$old_lineE/$new_lineE/g" medicalRecord.txt #substitute the old record with the new one
printf "\n----RECORD HAS BEEN UPDATED!----\n"

}


#--------------------------------------------------------------------------------------------------------------------

delete_record () {

cat /dev/null > temp.txt

printf "\nEnter the patient ID:\n"
read PID
#check if the id is exist and valid
while  [ true ]
do 

         if ! echo "$PID" | grep -q '^[0-9]\{7\}$'
        then
                 echo -n  "\nInvalid ID number. Please enter a 7-digit number:\n"
                 read PID
                 continue
        fi
        temp=$(grep "$PID"  medicalRecord.txt | wc -l | cut -d" " -f1 )
        if [ $((temp)) -eq 0 ]
        then
                 echo -n  "\nThis ID does not exist. Please reenter the patient ID:\n"
                 read PID
                 continue
        elif [ $((temp)) -gt 0 ]
        then
                break
        fi
done

echo "\n"
i=0
grep "$PID"  medicalRecord.txt | while read line
do
res=$( echo "$line" | cut -d":" -f2 | cut -d" " -f2-9)
i=$((i + 1))
echo "$i)$res"
done

printf "\nEnetr the line you want to modify its test result:\n"
read op
i=0

grep "$PID"  medicalRecord.txt | while read line
do
i=$((i + 1))
if [ $((op)) -eq $((i)) ]
then
echo "$line" >> temp.txt  
fi
done

record=$(grep "$PID" temp.txt)
recordD=$(printf '%s\n' "$record" | sed 's/[\/&]/\\&/g') #escape special char

sed -i "/$recordD/d" medicalRecord.txt #delete the record from the file
printf "\n----RECORD HAS BEEN DELETED!----\n"


}


#**********************************************************
#__________________main loop_____________________________
printf "\n\t\t Medical Test Management System \n\n"
while [ true ]
do

	display_menu

	echo "Please enter your choice:"
	read choice
case "$choice"
in
    1) addRecord;;
    2) search_patientID;;
    3) search_upnormal;;
    4) avg_res;;
    5) update_result;;
    6) delete_record;;
    7) printf "\t\tTHANK YOU!!!!\n"
     break;;

    *) printf "\n\tInvalid choice. Please enter a number between 1 and 6\n"
   ;;
esac

done
