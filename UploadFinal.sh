#=====================================
#PHP EQUIVALENT
#curl_setopt($this->_ch, CURLINFO_HEADER_OUT, true);
#$result = curl_exec($this->_ch);
#$response = curl_getinfo($this->_ch, CURLINFO_HEADER_OUT);
#======================================
#======================================
#CALL FORMAT: ./UploadFinal.sh FileName
#======================================
FullFileName=$1
BaseURL=http://rapidgator.net/api/v2/

Hash=$(md5sum "$FullFileName" | cut -d ' ' -f 1)
echo $Hash
FileSize=$(stat -c%s "$FullFileName")
echo $FileSize
FileName=$(basename $FullFileName)
echo $FileName
#LOGIN REQUEST
LoginResponse=$(curl "$BaseURL"'user/login?login=YOUR_LOGIN&password=YOUR_PASSWORD'|grep -E 'response')
#echo $LoginResponse
Status=$(echo $LoginResponse| grep -m1  -oP '\s*"status"\s*:\s*\K[^,]+')
echo $Status
Token=$(echo $LoginResponse| grep -m1 -oP '\s*"token"\s*:\s*"\K[^"]+')
echo $Token

#if $Status -eq 200 then
	#UPLOAD REQUEST
	
	echo "$BaseURL"'file/upload?token='"$Token"'&name='"$FileName"'&hash='"$Hash"'&size='"$FileSize"
	#FileUploadResponse=$(curl '-header CURLOPT_HEADER:false -header CURLOPT_RETURNTRANSFER:true '"$BaseURL"'file/upload?token='"$Token"'&hash='"$Hash"'&size='"$FileSize"'&name='"$FileName"|grep -E 'response')
	FileUploadResponse=$(curl "$BaseURL"'file/upload?token='"$Token"'&hash='"$Hash"'&size='"$FileSize"'&name='"$FileName"|grep -E 'response')
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
	
	#FileResponse=$(echo '<form method="post" action='"$URL"' enctype="multipart/form-data">''<input type="file" name='"$FullFileName"'/>''</form>')
	
	#@RGBash.txt http:\/\/pr31.rapidgator.net\/upload\/api?uuid=rU4ZHNFWnesIJ9s0c3fp4vzteh44g4kc&sid=ce896f03943165a65f5599f7663ec148
	echo '-X POST -d ''@'"$FullFileName"' '"$URL"
	FileResponse=$(curl '-X POST -d ''@'"$FullFileName"' '"$URL")
	echo $FileResponse	
	#Warning: Couldn't read data from file "RGBash.txt
	#this makes an empty POST
	#curl: no URL specified!


	echo "$BaseURL"'file/upload_info?token='"$Token"'&upload_id='"$UploadID";
	FileUploadInfoResponse=$(curl "$BaseURL"'file/upload_info?token='"$Token"'&upload_id='"$UploadID"|grep -E 'response')
	echo $FileUploadInfoResponse
