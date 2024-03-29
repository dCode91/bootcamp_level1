namespace: Salesforce
flow:
  name: read_email_attachment
  inputs:
    - user: daniel@rpamf.onmicrosoft.com
    - secret
  workflow:
    - Get_Authorization_Token:
        do_external:
          18ff19e5-8484-4803-857e-4a2293b91eef:
            - loginAuthority: 'https://login.windows.net/rpamf.onmicrosoft.com/oauth2/token'
            - clientId: 4c800826-f5c8-44a1-b779-2f333099823d
            - clientSecret:
                value: '${secret}'
                sensitive: true
        publish:
          - authToken
        navigate:
          - success: List_Messages
          - failure: on_failure
    - List_Messages:
        do_external:
          90083ffe-8000-4ddf-b158-22898a5efdfa:
            - authToken: '${authToken}'
            - userPrincipalName: '${user}'
            - folderId: Inbox
            - topQuery: '1'
        publish:
          - message_json: '${document}'
        navigate:
          - success: get_message_id
          - failure: on_failure
    - get_message_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${message_json}'
            - json_path: '$.value[0].id'
        publish:
          - messageId: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: List_Attachments
          - FAILURE: on_failure
    - List_Attachments:
        do_external:
          40f50977-0b1c-4a43-bc37-6453f9a01a36:
            - authToken: '${authToken}'
            - userPrincipalName: '${user}'
            - messageId: '${messageId}'
        publish:
          - attachmentId
        navigate:
          - success: Get_Attachment
          - failure: on_failure
    - Get_Attachment:
        do_external:
          a5971b46-89e1-4f5a-bef8-ceca822b377f:
            - authToken: '${authToken}'
            - userPrincipalName: '${user}'
            - messageId: '${messageId}'
            - attachmentId: '${attachmentId}'
            - filePath: "C:\\temp"
        publish:
          - attachment_json: '${document}'
        navigate:
          - success: get_file_name
          - failure: on_failure
    - get_file_name:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${attachment_json}'
            - json_path: $.name
        publish:
          - file_name: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - file_name: '${file_name}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Get_Authorization_Token:
        x: 66
        'y': 124
      List_Messages:
        x: 54
        'y': 326
      get_message_id:
        x: 225
        'y': 120
      List_Attachments:
        x: 215
        'y': 322
      Get_Attachment:
        x: 386
        'y': 124
      get_file_name:
        x: 380
        'y': 324
        navigate:
          f1157713-1c44-1ac3-79d7-d067259eceff:
            targetId: ed019201-a1a4-679c-9598-b18409ddd093
            port: SUCCESS
    results:
      SUCCESS:
        ed019201-a1a4-679c-9598-b18409ddd093:
          x: 548
          'y': 329
