if [[ $# -eq 0 ]];
then
    echo "Enter domain target "
    echo "ex: bash ~/script/hunt https://admin.snapp.ir snapp.ir"
    exit 1
fi
url=$1
target=$2
domainPath=`echo "$url" | unfurl domains | sed 's/\./_/g' `

if [ ! -d "~/recon/$target/$domainPath" ];then
        mkdir ~/recon/$target/$domainPath
fi
if [ ! -d "~/recon/$target/$domainPath/Vulnerability" ];then
        mkdir ~/recon/$target/$domainPath/Vulnerability
fi


echo -e "\e[1;32m[+] XSS ) \e[0m"
cat ~/recon/$target/$domainPath/Vulnerability/waybackurls.txt | grep -Ev "\.(jpeg|jpg|png|ico)$" | uro | gf xss > /tmp/xss.txt
cd ~/tools/Xssor.go
go run main.go  /tmp/xss.txt | grep -v "Nothing" >> ~/recon/$target/$domainPath/Vulnerability/XSS.txt
rm -rf  /tmp/xss.txt
cd -
echo""
