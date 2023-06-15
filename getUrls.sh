if [[ $# -eq 0 ]];
then
    echo "Enter domain target "
    echo "ex: bash ~/script/hunt https://admin.snapp.ir snapp.ir"
    exit 1
fi
url=$1
target=$2
domain=`echo "$url" | unfurl  domains `
domainPath=`echo "$url" | unfurl domains | sed 's/\./_/g' `

if [ ! -d "~/recon/$target/$domainPath" ];then
        mkdir ~/recon/$target/$domainPath
fi
if [ ! -d "~/recon/$target/$domainPath/Vulnerability" ];then
        mkdir ~/recon/$target/$domainPath/Vulnerability
fi

echo $url
echo $domain
echo $domainPath

echo -e "\e[1;32m[+] Gathering URLs.... ) \e[0m"
rm -rf /tmp/way.txt /tmp/gau.txt /tmp/katana.txt /tmp/hakrawler.txt /tmp/ggospider.txt /tmp/x8-params /tmp/params.txt  /tmp/xurl.txt
xurlfind3r -d $domain -o /tmp/xurl.txt
waybackurls $url | uro | tee -a /tmp/way.txt 
gau $url | uro | tee -a /tmp/gau.txt 
katana -u $url -o /tmp/katana.txt
gospider --site $url --other-source --include-other-source --depth 3 --user-agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Safari/605.1.15" --quiet --robots --sitemap --json | grep -v '\[url\]' | jq -r ".output" | grep -Eiv '\.(css|jpg|jpeg|png|svg|img|gif|mp4|flv|ogv|webm|webp |mov|mp3|m4a|m4p| ppt |pptx|scss|tif| tiff |ttf lott |woff|woff2|bmp|ico|eot|htc|swf|rtf|image)' | grep $url | sort -u > /tmp/ggospider.txt
echo "$url" | hakrawler | tee -a /tmp/hakrawler.txt
python3 ~/tools/ParamSpider/paramspider.py -d $url --level high  --quiet -o /tmp/params.txt
cd ~/tools/
./x8/target/release/x8 -u /tmp/params.txt -m 25 -O url --reflected-only -w ~/wordlist/parameter/param1 -o /tmp/x8-params
cd -
cat /tmp/way.txt /tmp/gau.txt  /tmp/xurl.txt  /tmp/katana.txt /tmp/hakrawler.txt /tmp/ggospider.txt /tmp/x8-params  /tmp/params.txt | sort -u  | grep "$url" | tee -a ~/recon/$target/$domainPath/Vulnerability/waybackurls.txt
rm -rf /tmp/way.txt /tmp/gau.txt /tmp/katana.txt /tmp/hakrawler.txt /tmp/ggospider.txt /tmp/x8-params /tmp/params.txt  /tmp/xurl.txt
echo ""
