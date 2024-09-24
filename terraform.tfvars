moduleconfig = {
  bucket = [
    {
      name = "my-bucket-1"
      acl  = "private"
      tags = ["data", "backup"]
    },
    {
      name = "my-bucket-2"
      acl  = "public-read"
      tags = ["logs", "archive"]
    },
    {
      name = "my-bucket-3"
      acl  = "private"
      tags = ["app-data", "secure"]
    }
  ]
}
