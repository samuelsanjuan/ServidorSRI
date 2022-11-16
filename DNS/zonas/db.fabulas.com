$TTL    3600
@       IN      SOA     ns.fabulas.com. ssanjuanandres.danielcastelao.org. (
                   2022161101           ; Serial
                         3600           ; Refresh [1h]
                          600           ; Retry   [10m]
                        86400           ; Expire  [1d]
                          600 )         ; Negative Cache TTL [1h]
;
@       IN      NS      ns.fabulas.com.
@       IN      MX      10 ssanjuanandres.danielcastelao.org.

ns      IN      A       172.29.0.101
oscuras    IN      A       172.29.0.80
brillantes	IN	A	172.29.0.80


pop     IN      CNAME   ns
www     IN      CNAME   etch
mail    IN      CNAME   etch
