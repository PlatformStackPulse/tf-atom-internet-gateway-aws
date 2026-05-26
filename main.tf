resource "aws_internet_gateway" "this" {
  count = module.this.enabled ? 1 : 0

  vpc_id = var.vpc_id

  tags = merge(module.this.tags, { Name = module.this.id })
}
