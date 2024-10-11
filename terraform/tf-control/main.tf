module "tf-azure-ade-demo" {
    source = "../modules/tf-azure-ade-demo"

    ade_owner               = var.ade_owner
    ade_location            = var.ade_location
    ade_ingress_prefix      = var.ade_ingress_prefix
}