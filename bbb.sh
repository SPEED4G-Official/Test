read -p "Email: " email
read -p "ID User: " iduser
read -p "Gói Đăng Kí: " goidangki
read -p "Tổng Thiết Bị: " tongthietbi
read -p "ID Telegram: " idtelegram
cp demo.sh demo1.sh
mv demo1.sh $iduser.sh
sed -i 's/taikhoan=""/taikhoan="$email"/g' $iduser.sh
sed -i 's/iduser=""/iduser="$iduser"/g' $iduser.sh
sed -i 's/idtelegram=""/idtelegram="$idtelegram"/g' $iduser.sh
sed -i 's/goidangki=""/goidangki="$goidangki"/g' $iduser.sh
sed -i 's/tongthietbi=""/tongthietbi="$tongthietbi"/g' $iduser.sh
