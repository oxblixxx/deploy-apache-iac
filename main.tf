module "vpc" {
  source = "./modules"
  # azs            = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  subnet_ids = [ "10.0.1.0/28", "10.0.2.0/28", "10.0.3.0/28" ]
}
