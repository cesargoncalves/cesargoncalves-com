data "cloudflare_zone" "zone" {
  filter = {
    name = "cesargoncalves.com"
  }
}
