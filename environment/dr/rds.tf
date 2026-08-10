resource "aws_db_instance" "replica" {

  provider = aws.dr

  identifier = "dr-db"

  replicate_source_db = module.rds.db_instance_identifier

  instance_class = "db.r6g.large"

  publicly_accessible = false

  storage_encrypted = true

  skip_final_snapshot = true
}