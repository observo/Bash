#======================================
#CALL FORMAT: ./FileBash.sh FileName
#./FileBash.sh /c/xampp/xampp-control.log
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
	
echo "$BaseURL"'file/upload?token='"$Token"'&name='"$FileName"'&hash='"$Hash"'&size='"$FileSize"
FileUploadResponse=$(curl "$BaseURL"'file/upload?token='"$Token"'&hash='"$Hash"'&size='"$FileSize"'&name='"$FileName"|grep -E 'response')
echo $FileUploadResponse
	
UploadID=$(echo $FileUploadResponse| grep -m1 -oP '\s*"upload_id"\s*:\s*"\K[^"]+')
echo $UploadID
URL=$(echo $FileUploadResponse| grep -m1 -oP '\s*"url"\s*:\s*"\K[^"]+')
echo $URL
FileID=$(echo $FileUploadResponse| grep -m1 -oP '\s*"file_id"\s*:\s*"\K[^"]+')
echo $FileID
#FolderID=$(echo $FileUploadResponse| grep -m1 -oP '\s*"folder_id"\s*:\s*"\K[^"]+')
$echo $FolderID
State=$(echo $FileUploadResponse| grep -m1 -oP '\s*"state"\s*:\s*"\K[^,]+')
echo $State
StateLabel=$(echo $FileUploadResponse| grep -m1 -oP '\s*"state_label"\s*:\s*"\K[^"]+')
echo $StateLabel
Status=$(echo $FileUploadResponse| grep -m1 -oP '\s*"status"\s*:\s*"\K[^,]+')
echo $Status
Details=$(echo $FileUploadResponse| grep -m1 -oP '\s*"details"\s*:\s*"\K[^,}]+')
echo $Details
if [[ -v $FileID ]]; then
	FileUploadInfoResponse=$(curl "$BaseURL"'file/upload_info?token='"$Token"'&file_id='"$FileID"|grep -E 'response')
	echo $FileUploadInfoResponse
else
	#FileResponse=$(echo '<form method="post" action='"$URL"' enctype="multipart/form-data">''<input type="file" name='"file"'/>''</form>')
	FileUploadResponse=$(curl -F "type=file" -F "file=@$FullFileName" "{$URL}"|grep -E 'response')
	echo $FileUploadResponse	
	State=$(echo $FileUploadResponse| grep -m1 -oP '\s*"state"\s*:\s*"\K[^,]+')
	echo $State
	StateLabel=$(echo $FileUploadResponse| grep -m1 -oP '\s*"state_label"\s*:\s*"\K[^"]+')
	echo $StateLabel
	sleep 20
	echo "$BaseURL"'file/upload_info?token='"$Token"'&upload_id='"$UploadID";
	FileUploadInfoResponse=$(curl "$BaseURL"'file/upload_info?token='"$Token"'&upload_id='"$UploadID"|grep -E 'response')
	echo $FileUploadInfoResponse
fi	