data "template_file" "pact" {
  template = file("${path.module}/pact.json")
}