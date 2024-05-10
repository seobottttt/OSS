error handling

if [ "$#" -ne 3 ]; then
  echo "usage: $0 file1 file2 file3"
  exit 1
fi

# print whoami
echo "----OSS 1 - project 1 ----"
echo "| studentID : 12181720   |"
echo "| name : Bohyeon Seo     |"
echo "-------------------------"

# print menu and logic of choice case

while true; do
    echo ""
    echo ""
    echo "[MENU]"
    echo "1. Get the data of Heung-Min Son's Current Club, Appearances, Goals, Assists in players.csv"
    echo "2. Get the team data to enter a league position in teams.csv"
    echo "3. Get the Top-3 Attendance matches in matches.csv"
    echo "4. Get the team's league position and team's top scorer in teams.csv & players.csv"
    echo "5. Get the modiffied format of date_GMT in matches.csv"
    echo "6. Get the data of the winning team by the largest difference on home stadium in teams.csv & matches.csv"
    echo "7. Exit"
    echo "Enter your CHOICE (1~7) : "
    read CHOICE
    case $CHOICE in
        1)
            echo "Do you want to get the Heung-Min Son's data? (y/n) :"
            read answer
            if [ "$answer" = "y" ]; then
                awk -F, '$1=="Heung-Min Son" {printf "Team:%s, Appearance:%s, Goal:%s, Assist:%s\n", $4, $6, $7, $8}' players.csv
            fi
            ;;
	2)
       	    echo "What do you want to get the team data of league_position[1~20] :"
            read position
	    ## wrong input handling
            while ! [[ "$position" =~ ^[1-9]$|^1[0-9]$|^20$ ]]; do
           	 echo "Please enter a valid position (1-20):"
           	 read position
            done

       	    awk -v pos="$position" -F, '
       	    {
           	 if ($6==pos) {
               		 win_rate = $2 / ($2 + $3 + $4);
               		 printf "%d %s %.6f\n", pos, $1, win_rate;
           	 }
       	    }' teams.csv
       	    ;;
	3)
       	    echo "Do you want to know Top-3 attendance data and average attendance? (y/n) :"
       	    read ans
       	    if [ "$ans" = "y" ]; then
           	 echo "***Top-3 Attendance Match***"
	   	 sort -t, -k2 -nr matches.csv | head -3 | while IFS=, read -r col1 col2 col3 col4 col5 col6 col7
	       do	
		 echo ""
		 echo "$col3 vs $col4 ($col1)"
    		 echo "$col2 $col7"
  	       done
	    fi
	    ;;
	4)
	    echo "Do you want to get each team's ranking and the highest-scoring player? (y/n) :"
	    read ans
	    if [ "$ans" = "y" ]; then
		echo ""	    	
		sort -t, -k6,6n teams.csv |tail -n +2| while IFS=, read -r col1 col2 col3 col4 col5 col6 col7
 	        do
   		 echo "$col6 $col1"
   		 grep "$col1" players.csv | sort -t, -k7,7nr | awk -F, 'NR==1 {print $1, $7}'
  		 echo ""
		done
	    fi
	    ;;
	5)
	    echo "Do you want to modify the format of date? (y/n) :"
	    read ans
	    if [ "$ans" = "y" ]; then
	    	awk -F, '{print $1}' matches.csv|tail -n +2 | sed -r 's/(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) ([0-9]{1,2}) ([0-9]{4}) - ([0-9]{1,2}:[0-9]{2})(am|pm)/\3\/\1\/\2 \4\5/' | sed -e '
  s/Jan/01/; s/Feb/02/; s/Mar/03/; s/Apr/04/;
  s/May/05/; s/Jun/06/; s/Jul/07/; s/Aug/08/;
  s/Sep/09/; s/Oct/10/; s/Nov/11/; s/Dec/12/;
' | head -n 10
	    fi
	    ;;
       
        7)
            echo "Bye!"
            exit 0
            ;;
        *)
            echo "Please enter a valid option (1-7)"
            ;;
    esac
done
