read -p "ID User: " iduser
cookie=logined.cookie
local url=https://speed4g.me/api/v1/passport/auth/login
curl -s -i -X POST $url -d "email=telegram%40gmail.com" -d "password=nguyenvannghi" -c $cookie | head -1 | grep -q OK
local url=${v2_website}/api/v1/admin/server/manage/getNodes
curl -s -X GET $url -b $cookie | grep -E -o "$iduser" | sort -rn | wc -l > output.txt
a=$(cat output.txt)
b=$(($a/2))
echo "Số Thiết Bị Online: $b"
