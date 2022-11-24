#!/bin/bash


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
	send_telegram "$(cat $online_status)"
	if [ $? -ne 0 ]; then
		error_msg "Send message to telegram failure!"
    else
		info_msg "Gửi Thông Tin Thành Công!"
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
		(*)
			exit 1
	esac
}

main $@ && exit 0
