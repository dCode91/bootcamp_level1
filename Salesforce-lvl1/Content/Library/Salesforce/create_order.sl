namespace: Salesforce
flow:
  name: create_order
  inputs:
    - username
    - password
    - lines
  workflow:
    - get_order:
        do:
          Salesforce.operations.get_order:
            - lines: '${lines}'
        publish:
          - id
          - account_name
          - contract_number
          - amount
          - start_date
          - next_lines
        navigate:
          - SUCCESS: Order_flow
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${next_lines}'
            - second_string: ''
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: MORE_LINES
    - Order_flow:
        do:
          Salesforce.Order_flow:
            - username: '${username}'
            - password: '${password}'
            - account_name: '${account_name}'
            - contract_number: '${contract_number}'
            - order_date: '${start_date}'
            - description: '${"order id "+id+" with amount "+amount}'
        publish:
          - order_number
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
  outputs:
    - id: '${id}'
    - account_name: '${account_name}'
    - contract_number: '${contract_number}'
    - start_date: '${start_date}'
    - amount: '${amount}'
    - next_lines: '${next_lines}'
  results:
    - MORE_LINES
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      Order_flow:
        x: 257
        'y': 87
      string_equals:
        x: 501
        'y': 62
        navigate:
          4de20366-5059-3269-692c-458523250082:
            targetId: b56d47b6-89a6-6986-df19-a47883175b27
            port: SUCCESS
          2a7bcb55-5946-6278-9f0d-6b15bb501bed:
            targetId: 296cec9b-9e88-8c8f-463c-56cf2d5d90f9
            port: FAILURE
      get_order:
        x: 47
        'y': 83
    results:
      MORE_LINES:
        296cec9b-9e88-8c8f-463c-56cf2d5d90f9:
          x: 650
          'y': 75
      SUCCESS:
        b56d47b6-89a6-6986-df19-a47883175b27:
          x: 474
          'y': 330
