#!/bin/bash
createMainList(){
	clear
	echo "Enter login name"
	read login_name
	date
	echo "Welcome "$login_name" at our Database created by"
	echo "eng/ Ahmed reda bastwesy && eng/ Abdelrhman magdy"
	mkdir $login_name
	echo " -----------------------------------"
	echo "| please choose from following list |"
	echo " -----------------------------------"
	while [ 1 ]
	do
	echo
	echo -e "1) Create Database"
	echo -e "2) List Database"
	echo -e "3) Connect Database"
	echo -e "4) Drop Database"
	echo -e "5) EXIT"
	echo -en " Enter option: "
	read -n 1 option
	echo
	case $option in 
	1) echo "Enter name of Database you want to create"
		read DB_name
		if [ -d "./$login_name/$DB_name" ]
		then
			echo  $DB_name "is exist"
		else 
		mkdir ./$login_name/$DB_name
		fi
	;;
	2) 
		echo "<<<<<<<< database list >>>>>>>>>>>"
		ls $login_name | tr "" "\n"
	;;
	3) echo "Enter name of Database you want to use"
		read name_DB
		if [ -d "./$login_name/$name_DB" ]
		then
		     cd ./$login_name/$name_DB
			clear
		     echo "connect to" $name_DB
	         echo " -----------------------------------"
       		 echo "| please choose from following list |"
       		 echo " -----------------------------------"
			while [ 1 ]
			do
			tablemenu
			case $choice in
			1) clear
				 createTable 
			;;
			2) clear
		                echo "<<<<<<<<<<<<< Table list >>>>>>>>>>>>>"
				ls | tr "" "\n"
			;;
			3) clear
				droptable
			;;
			4) clear
				insert
			;;
			5) clear
				 select_table
			;;
			6) clear
				 Delete
			;;
			7) clear
				 update
			;;
			8) clear
				 break
			;;
			*) $choice not found
			esac
			done
			cd ../../
		else
		    echo $name_DB "not exist"
		fi

	;;
	4) echo "Ente name of Database you want to drop"
		read  Dbname
		if [ -d "./$login_name/$Dbname" ]
		then
		    rm -r ./$login_name/$Dbname
		    echo
		    echo "<<<<<<<<<<<<< database list >>>>>>>>>>>>>"
		    ls $login_name | tr "" "\n"
		else
		     echo $Dbname not exist
		fi
	;;
	5) exit
	;;
	6) $option not found
	esac
	done
}


#--------------------------------------------------------------------------
#-----------------------list for tables------------------------------------
tablemenu(){
	echo
        echo -e "1) Create table "
	echo -e "2) List table "
	echo -e "3) Drop table "
	echo -e "4) insert into table "
	echo -e "5) select from table "
	echo -e "6) Delete from table "
	echo -e "7) update table "
	echo -e "8) EXIT "
	echo -en " enter option = "
	read -n 1 choice
	echo
}
createTable(){
	echo " enter name of table you want to create "
	read table_name
	if [ -d "$table_name" ]
	then
		echo $table_name is exist
	else
		mkdir $table_name
		cd $table_name
	        let count=1
		touch .col_datatype
		echo "Enter number of column"
		read num
		for (( c=0; c<$num; c++ ))
		do
		echo
		echo "enter name of column"
		read col_name
		echo $col_name >> colName
		echo
		echo "select data type of column"
		echo -e "1) int "
		echo -e "2) varchar(50) "
		echo -e "3) text "
		echo -e "4) EXIT "
		echo -en "your option = "
		read -n 1 option2
		echo
		case $option2 in
		 1)     if (grep -w primarykey .col_datatype > nothing)
			then
				echo 
			else
			 chkPK
                	 case $answer in
                	 1) echo $table_name" -> "$col_name ":" "int" ":" "primarykey" >> .col_datatype 
                	 ;;
                	 2) echo $table_name" -> "$col_name ":" "int" >> .col_datatype 
                	 ;;
                	 *) echo $answer not found
               		esac
			fi 
		 ;;
                 2)
       		    echo $table_name" -> "$col_name ":" "varchar(50)" >> .col_datatype 
                 ;;
                 3)
                    echo $table_name" -> "$col_name ":" "text" >> .col_datatype 
                 ;;
		 4) break
		 ;;
		 *) echo $option2 not found
		esac
		done
		awk 'BEGIN { ORS = " | " } { print }' colName >> table_data
		cd ../
	fi
}

droptable(){
	echo "enter name of table you want to drop"
	read drop_table
	if [ -d "$drop_table" ]
	then
		rm -r $drop_table
		echo "<<<<<<<<<<<<< Table list >>>>>>>>>>>>>"
		ls | tr "" "\n"
	else
		echo $drop_table not exist
	fi
}

chkPK(){
	echo
	echo "select if  column has primary key or not"
              echo -e "1) primary key "
              echo -e "2) not primary key "
              echo -en "enter option = "
              read -n 1 answer
        echo

}
insert(){
	echo " enter table name "
	read tr_name
	if [ -d "$tr_name" ]
	then
	cd $tr_name
	head -1 table_data 
	for (( i=1 ;i<`awk -F'|' '{print NF; exit}' table_data` ;i++ ))
	do
	   if ( awk NR==$i .col_datatype | grep -w primarykey > nothing )
	   then
		echo
		cut -f 1 -d "|" table_data | tr "\n" " "
		while [ 1 ]
		do
		echo
		echo "enter any number not exist at previous list "
		read num
		echo
		if (grep -w $num table_data)
		then
			echo " number exist "
		else
			echo $num >>fake_data
			break
		fi
		done
	   else
		echo
        	echo "enter data for column "$i " put NULL if no data"
		read data
		echo $data >> fake_data
	   fi
	done
	echo " " >> table_data
	awk 'BEGIN { ORS = " | " } { print }' fake_data >> table_data
	echo
	rm fake_data
	cat table_data
	cd ../
	else
		echo $tr_name not exist
	fi
}

select_table(){
	clear
	while [ 1 ]
	do
	echo
	echo -e "1) select Table Data"
	echo -e "2) select col data from Table"
	echo -e "3) select line data from Table"
	echo -e "4) select multi line data from Table"
	echo -e "5) EXIT"
	echo -en "Enter your choice = "
	read -n 1 num
	echo
	case $num in
	1) clear
		echo "Enter Table name"
		read trname
	   if [ -d "$trname" ]
       	   then
                   cd $trname
	           cat table_data
		   echo
		   cd ../
	   else
		echo $trname not exist
	   fi
	;;
	2) clear
		 echo "Enter Table name"
                read trname
           if [ -d "$trname" ]
           then
                 cd $trname
		echo "columns name at " $trname
		 head -1 table_data
		 echo "Enter columns number seperated by - "
		 read num1
		 cut -f $num1 -d "|" table_data 
                 cd ../
           else 
                echo $trname not exist
           fi
	;;
        3) clear
		echo "Enter Table name"
                read trname
           if [ -d "$trname" ]
           then
                 cd $trname
                echo "columns name at " $trname
                 head -1 table_data
                 echo "Enter word in the line you want to display"
                 read word
                 grep -wE "($word)" table_data
                 cd ../ 
           else 
                echo $trname not exist
           fi
        ;;
        4) clear
		echo "Enter Table name"
                read trname
           if [ -d "$trname" ]
           then
                 cd $trname
                echo "columns name at " $trname
                 head -1 table_data
                 echo "Enter search words seperated by | "
                 read word
                 grep -wE "($word)" table_data
                 cd ../ 
           else 
                echo $trname not exist
           fi
        ;;
	5) clear
		break
	;;
	*) $num not found
	esac
	done
}

Delete(){
        clear
        while [ 1 ]
        do
        echo
        echo -e "1) Delete Table Data"
        echo -e "2) Delete col data from Table"
        echo -e "3) Delete line data from Table"
        echo -e "4) Delete multi line data from Table"
        echo -e "5) EXIT"
        echo -en "Enter your choice = "
        read -n 1 num
        echo
        case $num in
	1) clear
		 echo "Enter Table name"
                read trname
           if [ -d "$trname" ]
           then
                   cd $trname
                   head -1 table_data > tmp && mv tmp table_date
                   echo
                   cd ../
           else
                echo $trname not exist
           fi
        ;;
	2) clear
		 echo "Enter Table name"
                read trname
           if [ -d "$trname" ]
           then
                 cd $trname
                echo "columns name at " $trname
                 head -1 table_data
                 echo "Enter columns name seperated by | "
                 read names
           if ( grep -wE "($names)" .col_datatype | grep -w primarykey > nothing )
	   then
		echo " can't delete col content primarykey"
	   else
		echo " check primary key done "
		echo " please enter column number to delete "
		read num1
                 cut --complement -f $num1 -d "|" table_data >tmp && mv tmp table_data
		 cat table_data 
	   fi
		cd ../
           else 
                echo $trname not exist
           fi
        ;;
        3) clear
		echo "Enter Table name"
                read trname
           if [ -d "$trname" ]
           then
                 cd $trname
                echo "columns name at " $trname
                 head -1 table_data
                 echo "Enter word in the line you want to display"
                 read word
                 sed /$word/d table_data >tmp && mv tmp table_data
		 cat table_data
                 cd ../ 
           else 
                echo $trname not exist
           fi
        ;;
        4) clear
		echo "Enter Table name"
                read trname
           if [ -d "$trname" ]
           then
                 cd $trname
                echo "columns name at " $trname
                 head -1 table_data
                 echo "Enter search words seperated by | "
                 read word
                 grep -vwE "($word)" table_data > tmp && mv tmp table_data
                 cat table_data
                 cd ../ 
           else 
                echo $trname not exist
           fi
        ;;
	5) clear
		break
	;;
	*) echo $num not found
	esac
	done
}

update(){
	clear
	while [ 1 ]
	do
	echo
	echo -e "1) update column name "
	echo -e "2) update data name"
	echo -e "3) EXIT"
	echo -en "Enter your choice = "
        read -n 1 num
        echo
        case $num in
	1) clear
		echo "Enter Table name"
              read trname
           if [ -d "$trname" ]
           then
                 cd $trname
                echo "columns name at " $trname
                 head -1 table_data
		echo "enter column name you want to change"
		read old_name
		echo "enter column new name"
		read new_name
		sed -i "s/$old_name/$new_name/g" table_data
                sed -i "s/$old_name/$new_name/g" .col_datatype
		head -1 table_data
		cd ../
           else 
                echo $trname not exist
           fi
        ;;
        2) clear
		echo "Enter Table name"
              read trname
           if [ -d "$trname" ]
           then
                 cd $trname
                echo "columns name at " $trname
                 head -1 table_data
		echo "enter name of column you want to make change at it "
		read colname
           if ( grep -wE "($colname)" .col_datatype | grep -w primarykey > nothing )
	   then
		echo "this col is primary key permission denied "
	   else
                echo "enter word you want to change"
                read old_name
                echo "enter new word"
                read new_name
                sed -i "s/$old_name/$new_name/g" table_data
                cat table_data
	   fi
		cd ../
           else 
                echo $trname not exist
           fi
        ;;
	3) clear
		 break
	;;
	*) $num not found
	esac
	done
}
createMainList
