# phpMyAdmin Docker Lightweight

> Super lightweight and fully function phpMyAdmin Docker image, it includes webserver and everything needed to work out of the box.

<p align="center"><a href="https://github.com/beeyev/phpmyadmin-docker-lightweight/"><img src="https://github.com/beeyev/phpmyadmin-docker-lightweight/raw/master/docs/phpmyadmin-docker-lightweight-withbg.jpg"></a></p>

This project is built on top of the official phpMyAdmin fpm-alpine image, it includes Caddy webserver and extra dark themes.  
The image is automatically updated, so the latests phpMyAdmin version is always supported.

<details>
<summary>Extra themes included into the image ▼</summary>

`blueberry`

![](https://github.com/beeyev/phpmyadmin-docker-lightweight/raw/master/docs/theme-blueberry.png)


`BooDark`

![](https://github.com/beeyev/phpmyadmin-docker-lightweight/raw/master/docs/theme-BooDark.png)

</details>

## Docker repository
[Docker Hub](https://hub.docker.com/r/beeyev/phpmyadmin-lightweight)  
`docker pull beeyev/phpmyadmin-lightweight:latest`  
  
[GitHub Packages](https://github.com/beeyev/phpmyadmin-docker-lightweight/pkgs/container/phpmyadmin-docker-lightweight)  
`docker pull ghcr.io/beeyev/phpmyadmin-docker-lightweight:latest`

## How to use

Example: [`docker-compose.yml`](https://github.com/beeyev/phpmyadmin-docker-lightweight/raw/master/docker-compose.yml)

### Custom Configuration & environment variables

Follow the [official phpmyadmin documentation](https://github.com/phpmyadmin/docker#adding-custom-configuration)

## License

The MIT License (MIT). Please see [License File](https://github.com/beeyev/phpmyadmin-docker-lightweight/blob/master/LICENSE) for more information.

---
If you like this project, please consider giving me a ⭐  

![](https://visitor-badge.laobi.icu/badge?page_id=beeyev.phpmyadmin-docker-lightweight) [![Docker Pulls](https://img.shields.io/docker/pulls/beeyev/phpmyadmin-lightweight)](https://hub.docker.com/r/beeyev/phpmyadmin-lightweight)
