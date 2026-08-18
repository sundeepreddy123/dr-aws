resource "aws_s3_bucket" "research" {
  bucket = "research-center-documents"
}
# athena.tf

resource "aws_athena_database" "cloudtrail" {
  name   = "cloudtrail_audit"
  bucket = aws_s3_bucket.cloudtrail_logs.id
}
resource "aws_athena_named_query" "cloudtrail_table" {
  name      = "create_cloudtrail_table"
  database  = aws_athena_database.cloudtrail.name
  workgroup = "primary"

  query = <<-SQL
    CREATE EXTERNAL TABLE IF NOT EXISTS cloudtrail_audit.cloudtrail_logs (
      eventversion STRING,
      useridentity STRUCT<
        type:STRING,
        principalid:STRING,
        arn:STRING,
        accountid:STRING,
        accesskeyid:STRING,
        username:STRING,
        sessioncontext:STRUCT<
          attributes:STRUCT<
            mfaauthenticated:STRING,
            creationdate:STRING
          >
        >
      >,
      eventtime STRING,
      eventsource STRING,
      eventname STRING,
      awsregion STRING,
      sourceipaddress STRING,
      useragent STRING,
      requestparameters STRING,
      responseelements STRING,
      requestid STRING,
      eventid STRING,
      readonly STRING,
      resources ARRAY<STRUCT<
        arn:STRING,
        accountid:STRING,
        type:STRING
      >>,
      eventtype STRING,
      apiversion STRING,
      managementevent STRING,
      recipientaccountid STRING,
      eventcategory STRING
    )
    ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
    STORED AS INPUTFORMAT
      'com.amazon.emr.cloudtrail.CloudTrailInputFormat'
    OUTPUTFORMAT
      'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
    LOCATION
      's3://${aws_s3_bucket.cloudtrail_logs.bucket}/AWSLogs/${data.aws_caller_identity.current.account_id}/CloudTrail/';
  SQL
}