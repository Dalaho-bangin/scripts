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

echo -e "\e[1;32m[+] OPEN Redirec ) \e[0m"
python3 ~/tools/autoredirect/autoredirect.py -f  ~/recon/$target/$domainPath/Vulnerability/waybackurls.txt -s -n 5 -o ~/recon/$target/$domainPath/Vulnerability/OPEN_REDIRECT.txt
echo ""
