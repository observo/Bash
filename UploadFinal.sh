#=====================================
#PHP EQUIVALENT
#curl_setopt($this->_ch, CURLINFO_HEADER_OUT, true);
#$result = curl_exec($this->_ch);
#$response = curl_getinfo($this->_ch, CURLINFO_HEADER_OUT);
#======================================
#======================================
#CALL FORMAT: ./UploadFinal.sh FileName
#======================================
FileName=$1
BaseURL=http://rapidgator.net/api/v2/

Hash=$(md5sum "$FileName" | cut -d ' ' -f 1)
#echo $Hash
FileSize=$(stat -c%s "$FileName")
#echo $FileSize
FileName=$(basename $FileName)
#echo $FileName
#LOGIN REQUEST
LoginResponse=$(curl "$BaseURL"'user/login?login=YOUR_LOGIN&password=YOUR_PASSWORD'|grep -E 'response')
#echo $LoginResponse
Status=$(echo $LoginResponse| grep -m1  -oP '\s*"status"\s*:\s*\K[^,]+')
#echo $Status
Token=$(echo $LoginResponse| grep -m1 -oP '\s*"token"\s*:\s*"\K[^"]+')
#echo $Token

#if $Status -eq 200 then
	#UPLOAD REQUEST
	
	echo "$BaseURL"'file/upload?token='"$Token"'&name='"$FileName"'&hash='"$Hash"'&size='"$FileSize"
	FileUploadResponse=$(curl -H "CURLOPT_HEADER:false" -H "CURLOPT_RETURNTRANSFER:true" "$BaseURL"'file/upload?token='"$Token"'&hash='"$Hash"'&size='"$FileSize"'&name='"$FileName"|grep -E 'response')
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
	echo "$BaseURL"'file/upload_info?token='"$Token"'&upload_id='"$UploadID";
	FileUploadInfoResponse=$(curl "$BaseURL"'file/upload_info?token='"$Token"'&upload_id='"$UploadID"|grep -E 'response')
	echo $FileUploadInfoResponse
