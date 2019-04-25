#======================================
#CALL FORMAT: ./UploadFinal.sh FileName
#======================================
FileName=$1
Hash=$(md5sum "$FileName" | cut -d ' ' -f 1)
echo $Hash
FileSize=$(stat -c %s "$FileName")
echo $FileSize
#LOGIN REQUEST
#LoginResponse=$(curl 'https://rapidgator.net/api/v2/user/login?login=YOUR_LOGIN&password=YOUR_PASSWORD'|grep -E 'response')
echo $LoginResponse
Token=$(echo $LoginResponse| grep -m1 -oP '\s*"token"\s*:\s*"\K[^"]+')
echo $Token
Status=$(echo $LoginResponse| grep -m1  -oP '\s*"status"\s*:\s*\K[^,]+')
echo $Status
if [$Status==200]; then
	#UPLOAD REQUEST
	FileUploadResponse=$(curl 'https://rapidgator.net/api/v2/file/upload?token='"$Token"'&hash='"$Hash"'&size='"$FileSize"'&name='"$FileName"|grep -E 'response')
	echo $FileUploadResponse
	UploadID=$(echo $FileUploadResponse| grep -m1 -oP '\s*"upload_id"\s*:\s*"\K[^"]+')
	echo $UploadID
	URL=$(echo $FileUploadResponse| grep -m1 -oP '\s*"url"\s*:\s*"\K[^"]+')
	echo $URL
	State=$(echo $FileUploadResponse| grep -m1 -oP '\s*"state"\s*:\s*"\K[^,]+')
	echo $State
	StateLabel=$(echo $FileUploadResponse| grep -m1 -oP '\s*"state_label"\s*:\s*"\K[^"]+')
	echo $StateLabel
	Status=$(echo $FileUploadResponse| grep -m1 -oP '\s*"status"\s*:\s*"\K[^,]+')
	echo $Status
	Details=$(echo $FileUploadResponse| grep -m1 -oP '\s*"details"\s*:\s*"\K[^,}]+')
	echo $Details
	FileUploadInfoResponse=$(curl 'https://rapidgator.net/api/v2/file/upload_info?token='"$Token"'&upload_id='"$UploadID"|grep -E 'response')
	echo $FileUploadInfoResponse
