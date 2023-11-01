import aws as aws

resource dynamodb 'AWS.DynamoDB/GlobalTable@default'={
  properties: {
    TableName:'demotable'
    BillingMode: 'PAY_PER_REQUEST'
    AttributeDefinitions: [
      {
        AttributeName: 'order_id'
        AttributeType: 'S'
      }
      {
        AttributeName: 'quantity'
        AttributeType: 'N'
      }
    ]
    KeySchema: [
      {
        AttributeName: 'order_id'
        KeyType: 'HASH'
      }
      {
        AttributeName: 'quantity'
        KeyType: 'RANGE'
      }
    ]
    Replicas: [
     {
      Region: 'us-west-2'
     } 
    ]
  }
  alias: 'dynamodb'
}
