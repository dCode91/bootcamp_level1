namespace: Salesforce
flow:
  name: create_multiple_orders
  inputs:
    - lines
    - username
    - password
  workflow:
    - parse_header:
        do:
          Salesforce.operations.get_order:
            - lines: '${lines}'
        publish:
          - next_lines
        navigate:
          - SUCCESS: create_order
    - create_order:
        loop:
          for: 'i in range(0,10)'
          do:
            Salesforce.create_order:
              - username: '${username}'
              - password: '${password}'
              - lines: '${next_lines}'
          break:
            - SUCCESS
            - FAILURE
          publish:
            - id
            - account_name
            - contract_number
            - start_date
            - amount
            - next_lines
        navigate:
          - MORE_LINES: FAILURE
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      parse_header:
        x: 181
        'y': 114
      create_order:
        x: 468
        'y': 112
        navigate:
          3295d124-b0f9-473b-12bd-ac4d4a4b433d:
            targetId: 56bdcaef-325e-0ac6-5352-abd80103d8b8
            port: FAILURE
          3715b82b-5ea2-eaf4-3271-8d2d6dffb692:
            targetId: 56bdcaef-325e-0ac6-5352-abd80103d8b8
            port: MORE_LINES
          ce680f7b-342c-ff59-e671-da351962196a:
            targetId: 2de3d545-5bf4-23c0-a17c-1a3473b2ce26
            port: SUCCESS
    results:
      SUCCESS:
        2de3d545-5bf4-23c0-a17c-1a3473b2ce26:
          x: 687
          'y': 109
      FAILURE:
        56bdcaef-325e-0ac6-5352-abd80103d8b8:
          x: 543
          'y': 323
