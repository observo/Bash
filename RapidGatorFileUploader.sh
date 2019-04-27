#======================================
#CALL FORMAT: ./RapidGatorFileUploader.sh FileName
#./RapidGatorFileUploader.sh /c/xampp/xampp-control.log
#======================================
FullFileName=$1;
BaseURL=https://rapidgator.net/api/v2/;
#CHECK WHERE FILE EXISTS OR NOT
if [ -f "$FullFileName" ]; then
	FileSize=$(stat -c%s "$FullFileName");
	#echo "FileSize: $FileSize";	
	Hash=$(md5sum "$FullFileName" | cut -d ' ' -f 1);
	#echo "Hash: $Hash";
	FileName=$(basename $FullFileName);
	#echo "FileName: $FileName";
	#LOGIN REQUEST
	#curl -s REMOVES PROGRESS METER
	LoginResponse=$(curl -s "$BaseURL"'user/login?login=YOUR_LOGIN&password=YOUR_PASSWORD'|grep -E 'response')
	#echo "LoginResponse: $LoginResponse";
	Status=$(echo $LoginResponse| grep -m1  -oP '\s*"status"\s*:\s*\K[^,]+');
	#echo "Status: $Status";
	Token=$(echo $LoginResponse| grep -m1 -oP '\s*"token"\s*:\s*"\K[^"]+');
	#echo "Token: $Token";

	#UPLOAD REQUEST
	#echo "$BaseURL"'file/upload?token='"$Token"'&name='"$FileName"'&hash='"$Hash"'&size='"$FileSize";
	FileUploadResponse=$(curl -s "$BaseURL"'file/upload?token='"$Token"'&hash='"$Hash"'&size='"$FileSize"'&name='"$FileName"|grep -E 'response');
	#echo "FileUploadResponse: $FileUploadResponse";
	Details=$(echo $FileUploadResponse| grep -m1 -oP '\s*"details"\s*:\s*"\K[^",}]+');
	#CHECK IF NO ERROR ON FILE UPLOADING LIKE MORE THAN 5 COPIES
	if [ -z "$Details" ]; then
		FileID=null;
		FileID=$(echo $FileUploadResponse| grep -m1 -oP '\s*"file_id"\s*:\s*"\K[^"]+');
		#echo "FileID: $FileID";
		#CHECK IF ALREADY FILE UPLOADED OR NOT
		if [ -z "$FileID" ]; then
			UploadID=$(echo $FileUploadResponse| grep -m1 -oP '\s*"upload_id"\s*:\s*"\K[^"]+');
			#echo "UploadID: $UploadID";
			URL=$(echo $FileUploadResponse| grep -m1 -oP '\s*"url"\s*:\s*"\K[^"]+');
			#echo "URL: $URL";
			#File=$(echo $FileUploadResponse| grep -m1 -oP '\s*"file":\s*"\K[^"]+');
			#echo "File: $File";
			#URL=$(echo $FileUploadResponse| grep -m1 -oP '\s*"url"\s*:\s*"\K[^"]+');
			#echo "URL: $URL";
			State=$(echo $FileUploadResponse| grep -m1 -oP '\s*"state"\s*:\s*"\K[^",]+');
			#echo "State: $State";
			StateLabel=$(echo $FileUploadResponse| grep -m1 -oP '\s*"state_label"\s*:\s*"\K[^"]+');
			#echo "StateLabel: $StateLabel";
			#FileResponse=$(echo '<form method="post" action='"$URL"' enctype="multipart/form-data">''<input type="file" name='"file"'/>''</form>')
			FileUploadResponse=$(curl -s -F "type=file" -F "file=@$FullFileName" "{$URL}"|grep -E 'response');
			#echo "FileUploadResponse: $FileUploadResponse";
			#sleep 20;
			#echo "$BaseURL"'file/upload_info?token='"$Token"'&upload_id='"$UploadID";
			FileUploadInfoResponse=$(curl -s "$BaseURL"'file/upload_info?token='"$Token"'&upload_id='"$UploadID"|grep -E 'response');
			#echo "FileUploadInfoResponse: $FileUploadInfoResponse";
			UploadID=$(echo $FileUploadInfoResponse| grep -m1 -oP '\s*"upload_id"\s*:\s*"\K[^"]+');
			#echo "UploadID: $UploadID";
			URL=$(echo $FileUploadInfoResponse| grep -m1 -oP '\s*"url"\s*:\s*"\K[^"]+');
			#echo "URL: $URL";
			echo "$URL";
			#File=$(echo $FileUploadInfoResponse| grep -m1 -oP '\s*"file":\s*"\K[^"]+');
			#echo "File: $File";
			#URL=$(echo $FileUploadResponse| grep -m1 -oP '\s*"url"\s*:\s*"\K[^"]+');
			#echo "URL: $URL";
			State=$(echo $FileUploadInfoResponse| grep -m1 -oP '\s*"state"\s*:\s*"\K[^",]+');
			#echo "State: $State";
			StateLabel=$(echo $FileUploadInfoResponse| grep -m1 -oP '\s*"state_label"\s*:\s*"\K[^"]+');
			#echo "StateLabel: $StateLabel";
			exit;
		else
			UploadID=$(echo $FileUploadResponse| grep -m1 -oP '\s*"upload_id"\s*:\s*"\K[^"]+');
			#echo "UploadID: $UploadID";
			URL=$(echo $FileUploadResponse| grep -m1 -oP '\s*"url"\s*:\s*"\K[^"]+');
			#echo "URL: $URL";
			echo "$URL";
			File=$(echo $FileUploadResponse| grep -m1 -oP '\s*"file":\s*"\K[^"]+');
			#echo "File: $File";
			FileID=$(echo $FileUploadResponse| grep -m1 -oP '\s*"file_id"\s*:\s*"\K[^"]+');
			#echo "FileID: $FileID";
			FolderID=$(echo $FileUploadResponse| grep -m1 -oP '\s*"folder_id"\s*:\s*"\K[^"]+');
			#echo "FolderID: $FolderID";
			State=$(echo $FileUploadResponse| grep -m1 -oP '\s*"state"\s*:\s*"\K[^",]+');
			#echo "State: $State";
			StateLabel=$(echo $FileUploadResponse| grep -m1 -oP '\s*"state_label"\s*:\s*"\K[^"]+');
			#echo "StateLabel: $StateLabel";
			Status=$(echo $FileUploadResponse| grep -m1 -oP '\s*"status"\s*:\s*"\K[^",]+');
			#echo "Status: $Status";
			#FileUploadInfoResponse=$(curl "$BaseURL"'file/upload_info?token='"$Token"'&file_id='"$FileID"|grep -E 'response');
			#echo "FileUploadInfoResponse: $FileUploadInfoResponse";
			exit;		
		fi
	else
		echo "Details: $Details";
		exit;
	fi
else
	echo 'No file exists';
	exit;
fi	