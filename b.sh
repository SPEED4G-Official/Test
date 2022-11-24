#!/bin/bash

print_usage(){
	cat <<EOF

	Usage: 
		$(basename $0) [OPTION]
	
	Options:
		-o, --online		get online status
		-t, --traffic		get traffic status
		-h, --help		print script help
		-v, --version 		print script version

	Example:
		cp config.ini.example  config.ini
		vim config.ini

		chmod +x $(basename $0)
		$PWD/$(basename $0) -o
		$PWD/$(basename $0) -t

		echo "\$(crontab -l)\n59 7-23 * * * cd $PWD; bash $(basename $0) -o" | crontab
		echo "\$(crontab -l)\n59 23 * * * cd $PWD; bash $(basename $0) -t" | crontab

EOF
}

error_msg(){
	local msg=$1
	echo -e "[\033[1;31mERRO\033[0m] $(date +"%F %T.%4N") -- $(basename $0) $msg" && exit 1
}

info_msg(){
	local msg=$1
	echo -e "[\033[1;32mINFO\033[0m] $(date +"%F %T.%4N") -- $(basename $0) $msg"
}

read_config(){
	config=config.ini
	if [ ! -f $config ]; then
		error_msg "$config No such file."
	else
		source $config
		info_msg "Read $config success!"
	fi
}

check_login(){
	cookie=logined.cookie
	local url=https://speed4g.me/api/v1/passport/auth/login
	curl -s -i -X POST $url -d "email=telegram%40gmail.com" -d "password=nguyenvannghi" -c $cookie | head -1 | grep -q OK
	if [ $? -ne 1 ]; then
		error_msg "Login failure! Please check $config"
	else
		info_msg "Đăng Nhập Thành Công!"
	fi
}

get_online(){
    read -p "ID User: " iduser
    read -p "ID Telegram: " idtelegram
	local url=${v2_website}/api/v1/admin/server/manage/getNodes
	local online_status=$(mktemp online_status.XXX)
	#curl -s -X GET $url -b $cookie | grep -n "6808" > output.txt
    curl -s -X GET $url -b $cookie | grep -E -o "$iduser" | sort -rn | wc -l > output.txt
    a=$(cat output.txt)
    b=$(($a/2))
    echo "ID $iduser Đang Sử Dụng $b Thiết Bị" >> $online_status
    #cat $c > $online_status
	#curl -s -X GET $url -b $cookie | jq -r '.data | .[] | .name, .online' | \
	#	gawk '
		#	BEGIN{
	#			printf "%s %s\n\n", strftime("%Y-%m-%d %H:%M:%S"), "节点使用情况:"
	#		} 
	#		NR%2==1{
	#			printf "%s %s\n", "节点名称:", $0
	#		} 
	#		NR%2==0{
	#			if ($0=="null") online=0;
	#			else online=$0;
	#			printf "%s %s\n\n", "在线人数:", online
	#		}
	#	' > output.txt

	#if [ "$power_by" == 1 -o "$power_by" == true -o "$power_by" == True ]; then
	#	echo "ADMIN" >> $online_status
#	fi

	send_telegram "$(cat $online_status)"
	if [ $? -ne 0 ]; then
		error_msg "Send message to telegram failure!"
    else
		info_msg "Gửi Thông Tin Thành Công!"
	fi
}

get_traffic(){
	local url=${v2_website}/api/v1/admin/stat/getServerLastRank
	local traffic_status=$(mktemp traffic_status.XXX)

	curl -s -X GET $url -b $cookie | jq -r '.data | .[] | .server_name, .total' | \
		gawk '
			BEGIN{
				printf "%s %s\n\n", strftime("%Y-%m-%d %H:%M:%S"), "流量使用情况:"
			} 
			NR%2==1{
				printf "%s %s\n", "节点名称:", $0
			} 
			NR%2==0{
				printf "%s %.7f %s\n\n", "使用流量:", $0, "GB"
			}
		' > $traffic_status

	if [ "$power_by" == 1 -o "$power_by" == true -o "$power_by" == True ]; then
		echo "Power by zhuangzhuang" >> $traffic_status
	fi

	send_telegram "$(cat $traffic_status)"
	if [ $? -ne 0 ]; then
		error_msg "Send message to telegram failure!"
	else
		info_msg "Send message to telegram success!"
	fi
}

send_telegram(){
	local url=https://api.telegram.org/bot5615629431:AAGEuKPxE0N9z4Ci7gyaMZYpCyLL_6LTOsc/sendMessage 
	curl -X POST $url -d "chat_id=$idtelegram" -d "text=$1" -d parse_mode=markdown &> /dev/null
}

main(){
	version=v0.0.1
	update=2021-11-01
	trap "rm -rf *.cookie *status*; exit" EXIT INT
	if  [[ $(whereis "jq") == "jq:" ]]; then
            echo "jq is not installed,plaese run it after installation"
	    exit 1
	else
            echo "jq is  installed"
	fi
	case $1 in
		(-o|--online)
			read_config
			check_login
			get_online
			;;
		(-t|--traffic)
			read_config
			check_login
			get_traffic
			;;
		(-h|--help)
			print_usage
			exit 0
			;;
		(-v|--version)
			echo "$(basename $0) $version $update"
			;;
		(*)
			print_usage
			exit 1
	esac
}

main $@ && exit 0
