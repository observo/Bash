#=====================================
#PHP EQUIVALENT
#curl_setopt($this->_ch, CURLINFO_HEADER_OUT, true);
#$result = curl_exec($this->_ch);
#$response = curl_getinfo($this->_ch, CURLINFO_HEADER_OUT);
#======================================
#curl -i -X POST -H "Content-Type: multipart/form-data" -F "data=@$FullFileName" "$URL"
#======================================
#CALL FORMAT: ./UploadFinal.sh FileName
#======================================
FullFileName=$1
BaseURL=https://rapidgator.net/api/v2/

Hash=$(md5sum "$FullFileName" | cut -d ' ' -f 1)
#echo $Hash
FileSize=$(stat -c%s "$FullFileName")
#echo $FileSize
FileName=$(basename $FullFileName)
#echo $FileName
#LOGIN REQUEST
LoginResponse=$(curl "$BaseURL"'user/login?login=YOUR_LOGIN&password=YOUR_PASSWORD'|grep -E 'response')
#echo $LoginResponse
Status=$(echo $LoginResponse| grep -m1  -oP '\s*"status"\s*:\s*\K[^,]+')
#echo $Status
Token=$(echo $LoginResponse| grep -m1 -oP '\s*"token"\s*:\s*"\K[^"]+')
#echo $Token


#UPLOAD REQUEST
	
#echo "$BaseURL"'file/upload?token='"$Token"'&name='"$FileName"'&hash='"$Hash"'&size='"$FileSize"
#curl "$BaseURL"'file/upload?token='"$Token"'&hash='"$Hash"'&size='"$FileSize"'&name='"$FileName" -o pavel.txt
FileUploadResponse=$(curl "$BaseURL"'file/upload?token='"$Token"'&hash='"$Hash"'&size='"$FileSize"'&name='"$FileName"|grep -E 'response')
echo $FileUploadResponse
	
#"response":{"upload":{"upload_id":"rU4FyiLcjTzVCyj01dbg4bbncmw0k840","url":null,"file":{"file_id":"72a765050146482b09287c243cb2801f","mode":0,"mode_label":"Public","folder_id":"5034678","name":"RGBash.txt","hash":"03cc927a9aaf1f7c4fb2bd2075e5464e","size":222,"created":1556237732,"url":"http:\/\/rapidgator.net\/file\/72a765050146482b09287c243cb2801f\/RGBash.txt.html","nb_downloads":0},"state":2,"state_label":"Done"}},"status":200,"details":null}

UploadID=$(echo $FileUploadResponse| grep -m1 -oP '\s*"upload_id"\s*:\s*"\K[^"]+')
echo $UploadID
URL=$(echo $FileUploadResponse| grep -m1 -oP '\s*"url"\s*:\s*"\K[^"]+')
echo $URL
#FileID=$(echo $FileUploadResponse| grep -m1 -oP '\s*"file_id"\s*:\s*"\K[^"]+')
#echo $FileID
#FolderID=$(echo $FileUploadResponse| grep -m1 -oP '\s*"folder_id"\s*:\s*"\K[^"]+')
#$echo $FolderID
State=$(echo $FileUploadResponse| grep -m1 -oP '\s*"state"\s*:\s*"\K[^,]+')
echo $State
StateLabel=$(echo $FileUploadResponse| grep -m1 -oP '\s*"state_label"\s*:\s*"\K[^"]+')
echo $StateLabel
Status=$(echo $FileUploadResponse| grep -m1 -oP '\s*"status"\s*:\s*"\K[^,]+')
echo $Status
Details=$(echo $FileUploadResponse| grep -m1 -oP '\s*"details"\s*:\s*"\K[^,}]+')
echo $Details
	
#FileResponse=$(echo '<form method="post" action='"$URL"' enctype="multipart/form-data">''<input type="file" name='"$FullFileName"'/>''</form>')
	
#FileResponse=$(curl '-X POST -d ''@'"$FullFileName"' '"$URL")
#FileResponse=$(curl "-X" "POST" "-d" "@$FullFileName" "$URL")
#FileResponse=$(curl -k -X POST -H "Content-Type: multipart/form-data" -d "data=@{$FullFileName}" "$URL")
FileResponse=$(curl -k -d "--data-urlencode data=@{$FullFileName}" -X POST "$URL")
#FileResponse=$(curl -k -d "file@{$FullFileName}" -X POST "$URL")
echo $FileResponse	
	
echo "$BaseURL"'file/upload_info?token='"$Token"'&file_id='"$FileID";
FileUploadInfoResponse=$(curl "$BaseURL"'file/upload_info?token='"$Token"'&file_id='"$FileID"|grep -E 'response')
echo $FileUploadInfoResponse