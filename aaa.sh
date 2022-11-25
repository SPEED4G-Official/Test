read -p "Email: " email
read -p "ID User: " iduser
read -p "Gói Đăng Kí: " goidangki
read -p "Tổng Thiết Bị: " tongthietbi
read -p "ID Telegram: " idtelegram
cp demo.sh demo1.sh
mv demo1.sh $iduser.sh

sed -i "s|taikhoan=.*|taikhoan=\"${iduser}\"|" ./$iduser.sh
sed -i "s|iduser=.*|iduser=\"${iduser}\"|" ./$iduser.sh
sed -i "s|idtelegram=.*|idtelegram=\"${idtelegram}\"|" ./$iduser.sh
sed -i "s|goidangki=.*|goidangki=\"${goidangki}\"|" ./$iduser.sh
sed -i "s|tongthietbi=.*|tongthietbi=\"${tongthietbi}\"|" ./$iduser.sh
