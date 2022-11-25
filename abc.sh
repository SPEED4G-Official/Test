#!/bin/bash
taikhoan="telegram@gmail.com"
iduser="11947"
idtelegram="1069946169"
idtelegramadmin="1069946169"
goidangki="ADMIN"
tongthietbi="1000"
error_msg(){
	local msg=$1
	echo -e "[\033[1;31mERRO\033[0m] $(date +"%F %T.%4N") -- $(basename $0) $msg" && exit 1
}

info_msg(){
	local msg=$1
	echo -e "[\033[1;32mINFO\033[0m] $(date +"%F %T.%4N") -- $(basename $0) $msg"
}
check_login(){
	cookie=logined.cookie
	local url=https://speed4g.me/api/v1/passport/auth/login
	curl -s -i -X POST $url -d "email=telegram%40gmail.com" -d "password=nguyenvannghi" -c $cookie | head -1 | grep -q OK
	if [ $? -ne 1 ]; then
		error_msg "Đăng Nhập Thất Bại!"
	else
		info_msg "Đăng Nhập Thành Công!"
	fi
}

get_online(){
	local url=https://speed4g.me/api/v1/admin/server/manage/getNodes
	local online_status=$(mktemp online_status.XXX)
    curl -s -X GET $url -b $cookie | grep -E -o "$iduser" | sort -rn | wc -l > output.txt
    a=$(cat output.txt)
    b=$(($a/2))
    if [ $b -le $tongthietbi ]; then
		thietbi="Đang Sử Dụng: $b/$tongthietbi Thiết Bị"
    else
		thietbi="Đang Sử Dụng: $b/$tongthietbi Thiết Bị\n—————————————————————\n🆘 Cảnh Báo Bạn Đang Sử Dụng Quá Số Lượng Thiết Bị Cho Phép\n✅ Có Thể Do Trong Quá Trình Bạn Kết Nối, Đổi Server, Cập Nhật Nên Đã Vượt Quá Số Lượng Kết Nối\n✅ Nếu Tình Trạng Kéo Dài Vui Lòng Truy Cập Website Và Thay Đổi Liên Kết Gói Để Tránh Bị Khóa Tài Khoản"
	fi
	
    printf "𝙉𝙊𝙏𝙄𝙁𝙄𝘾𝘼𝙏𝙄𝙊𝙉\n—————————————————————\nEmail: $taikhoan\n—————————————————————\nID Tài Khoản: $iduser\n—————————————————————\nGói Đăng Kí: $goidangki\n—————————————————————\nGiới Hạn: $tongthietbi Thiết Bị\n—————————————————————\n$thietbi" >> $online_status
	send_telegram "$(cat $online_status)"
	if [ $? -ne 0 ]; then
		error_msg "Gửi Thông Tin Thất Bại!"
    else
		info_msg "Gửi Thông Tin Thành Công!"
	fi
	send_telegram_admin "$(cat $online_status)"
	if [ $? -ne 0 ]; then
		error_msg "Gửi Thông Tin Thất Bại!"
    else
		info_msg "Gửi ADMIN Thông Tin Thành Công!"
	fi
}

send_telegram(){
	local url=https://api.telegram.org/bot5819921822:AAFZyDTTukttT4kNBld8D4i3CdaWqngMj2k/sendMessage 
	curl -X POST $url -d "chat_id=$idtelegram" -d "text=$1" -d parse_mode=markdown &> /dev/null
}
send_telegram_admin(){
	local url=https://api.telegram.org/bot5819921822:AAFZyDTTukttT4kNBld8D4i3CdaWqngMj2k/sendMessage 
	curl -X POST $url -d "chat_id=$idtelegramadmin" -d "text=$1" -d parse_mode=markdown &> /dev/null
}
main(){
check_login
get_online
}

main $@ && exit 0
