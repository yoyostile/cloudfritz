# Cloudfritz

Use this little service in order to set your dynamic IP to a Cloudflare DNS record.  
Yes. You're sending your credentials via `GET` to me. That's retarded. But I promise I won't log anything. ❤️  

## Usage

Fill this into your Fritz Box Custom DynDNS. Also, replace `YOURZONE` with your zone. 💁‍♀️ 
Not your zone id, but zone name. Sth. like `r4r3.me`.
```
https://cloudfritz.r4r3.me/update?key=<pass>&email=<username>&zone=YOURZONE&domain=<domain>&ip=<ipaddr>&ipv6=<ip6addr>
```

![Like this](https://s3.r4r3.me/random/Screen%20Shot%202018-05-16%20at%2019.00.17.png)

## Private Usage

Use the docker image to start a new container, as simple as:
```bash
docker run -p 4567:4567 yoyostile/cloudfritz:latest
```
