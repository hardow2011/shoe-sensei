<!-- PROJECT LOGO -->
<br />
<div align="center">
<!--   <a href="https://shoesensei.com"> -->
    <img src="https://github.com/user-attachments/assets/55edba10-f689-4f09-ac8a-c0b5f8d0af57" alt="Logo" width="80" height="80">
<!--   </a> -->

  <h3 align="center">Shoe Sensei</h3>

  <p align="center">
    Shoes Made Simple.
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li>
      <a href="#usage">Usage</a>
      <ul>
        <li><a href="#admin-subdomain">Admin subdomain</a></li>
        <li><a href="#shoe-filter-sort-and-pagination">Shoe filter, sort and pagination</a></li>
        <li><a href="#blog">Blog</a></li>
        <li><a href="#testing">Testing</a></li>
      </ul>
    </li>
    <li><a href="deployment-and-storage">Deployment and Storage</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

<div align="center">
  <img width="704" alt="image" src="https://github.com/user-attachments/assets/18598f14-6687-4afb-8bad-df3b1e1cbc7e" />
</div>

<br />

Shoe Sensei aims to provide a reliable shoe knowledge base to people seeking to find the right pair for their needs, in both English and Spanish.

It also incorporates a blog featuring articles explaining topics relevant to footwear. 

The project is built with Ruby on Rails, utilizing Turbo and custom JS for updating the filter without reloading the page. The frontend makes use of Bulma CSS for efficient styling. 

Additionally, a robust set of model and system tests has been implemented to maintain a reliable update cycle between new features. Shoe Sensei is deployed on Render and uses Active Storage with AWS for storing media.
The blog section in Shoe Sensei uses TinyMCE for a flexible text editor interface.

### Built With

* [![Ruby on Rails][RoR-logo]][RoR-url]
* [![Bulma][Bulma-logo]][Bulma-url]
* [![Render][Render-logo]][Render-url]
* [![Amazon S3][AmazonS3-logo]][AmazonS3-url]
* [TinyMCE](https://www.tiny.cloud/)

## Getting Started

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Prerequisites
* Install the libyaml-dev library
* Install the libpq-dev library
* Install the ruby-railties library
* Install the libvips42 library
* [Install Ruby version 3.2.2](https://github.com/rbenv/rbenv)
* [Install PostgreSQL](https://www.postgresql.org/download/)
* [Install node version 18.17.1 or higher](https://nodejs.org/en/download)
* [Install yarn](https://nodejs.org/en/download)

### Installation
1. Clone the repo
 ```sh
   git clone git@github.com:hardow2011/shoe-sensei.git
   ```
2. Install NPM packages
 ```sh
   npm install
   ```
3. Install bundle dependencies
 ```sh
   bundle install
   ```
Make sure the Postgre service is running

4. Create, migrate and seed the databases
 ```sh
   rails db:setup
   ```
5. Run the tests to make sure everything is running correctly
 ```sh
   rails test:all
   ```
6. Set up the cron jobs to periodically remove unattached images uploaded through TinyMCE.
```sh
whenever --update-crontab
```
### Start The Local Server
 ```sh
   bin/dev
   ```
This command starts the web server; the js and css watchers.

### Admin login
The admin login is:
```
url: admin.localhost:3000

email: admin@email.com

password: Adm!n123
```

<!-- USAGE EXAMPLES -->
## Usage

### Admin subdomain
The admin interface is completely separated in its own subdomain.

To access in local development, go to admin.localhost:3000

### Shoe filter, sort and pagination
Shoe Sensei provides a handy, custom-made shoe filter to assist interested parties in their search for the right footwear for the occasion.
<img width="704" alt="image" src="https://github.com/user-attachments/assets/dee4a979-524c-418d-9eb8-fdc1b1698d4f" />

The filter is comprised of:
1. Brand
2. Activity
3. Cushioning
4. Support
5. Additional filters

It also includes navigation buttons.

The filter is made storing custom jsonb attributes in the shoes tags columns in the PostgreSQL database.
Those tags are passed to `PagesController.filter_models` by url params, which are then processed by the [FilterPagination module](https://github.com/hardow2011/shoe-sensei/blob/main/app/helpers/filter_pagination.rb).

For example, the following request would return every shoe with the following characteristics:
1. Brand: Hoka
2. Activity: Road running or Trail running
3. Cushioning: Medium
```
filter_models?brand_ids%5B%5D=40&activities%5B%5D=road_running&activities%5B%5D=trail_running&cushionings%5B%5D=2&models_sorting=name
```

The `page` parameter can also be added to the request to paginate the results.
```
filter_models?page=1
```

Including when the request is already filtering shoes.
```
filter_models?brand_ids%5B%5D=40&activities%5B%5D=road_running&activities%5B%5D=trail_running&cushionings%5B%5D=2&page=1&models_sorting=name
```

The [FilterPagination module](https://github.com/hardow2011/shoe-sensei/blob/main/app/helpers/filter_pagination.rb) is also responsible for sorting the results by passing the `models_sorting` to the resquest.

### Blog

The blog section of Shoe Sensei is made with TinyMCE.

<img width="559" alt="image" src="https://github.com/user-attachments/assets/355e98fd-bf31-413a-88b6-3fb4ab20a57a" />
<br/>
<br/>
I decided to use TinyMCE instead of the default [Action Text](https://guides.rubyonrails.org/action_text_overview.html) because the latter is too limited in functionality.
TinyMCE is a feature-rich, flexible text editor with a vast amount of plugins, making it ideal for Shoe Sensei's use case.

Since Rails does not support TinyMCE's image uploads by default, I had to build my omw implementation.

Every time an image is pasted in the TinyMCE editor, it will be send by post request to `/admin/tinymce_assets` as specified by the config file [config/tinymce.yml](https://github.com/hardow2011/shoe-sensei/blob/main/config/tinymce.yml).
Once received by the controller, it will be uploaded to the AWS S3 bucket and the url will then be returned to the editor, which will display it in the page.

Now, **every time** an image is pasted, it is automatically uploaded to storage, whether or not the blog post ends up getting saved. This creates an issue, because the storage will progresively accumulate unused media, and storage is not free.

To remediate the issue, a [cron task](https://github.com/hardow2011/shoe-sensei/blob/main/config/schedule.rb) should run periodically to clean up the unattached files by executing the [cleanup:unnattached_files task](https://github.com/hardow2011/shoe-sensei/blob/main/lib/tasks/cleanup.rake).

### Testing

The development methodology used for building this project is **[Test-driven development (TDD)](https://en.wikipedia.org/wiki/Test-driven_development)**.

The tests were built before the code to be implemented; the tests indicate how to software ought to behave.

This approach to developing allows for a more future-proof app, and ensures that new features do not break parts of the code that were previously working.

Two types of tests were embedded in the code:
1. [Model Tests](https://github.com/hardow2011/shoe-sensei/tree/main/test/models) to ensure the models logic and functions work as intended.

2. [System Tests](https://github.com/hardow2011/shoe-sensei/tree/main/test/system) tverify the interaction with the system from the end user perspective.

### Internationalization

Shoe Sensei is available in both in English and Spanish.

<img width="539" alt="image" src="https://github.com/user-attachments/assets/133e2c78-ba9d-4cf4-b314-ea4a84b703c1" />
<br/>
<br/>
The English interface is available at the default route and /en.

The Spanish interface is available at /es.

[Locales](https://github.com/hardow2011/shoe-sensei/tree/main/config/locales) have been used extensively to acheive an easy-to-use implementation of i18n.

```ruby
es:
  language:
    prompt: Idioma
    english: English
    spanish: Español
  brands: Marcas
  all_brands: Todas las marcas
  ...
```

## Deployment and Storage

The web app, database and cache store are being held in [Render](https://render.com/).
The Active Storage images and stored in an AWS S3 bucket.

The production variables are stored in the credential files.

Every push to the main origin branch will be automatically deployed to Render.

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[RoR-logo]: https://img.shields.io/badge/Ruby%20on%20Rails-d40000?style=for-the-badge&logo=rubyonrails&logoColor=white
[RoR-url]: https://rubyonrails.org/

[Bulma-logo]: https://img.shields.io/badge/Bulma-00d1b2?style=for-the-badge&logo=bulma&logoColor=white
[Bulma-url]: https://bulma.io/

[Render-logo]: https://img.shields.io/badge/Render-0d0d0d?style=for-the-badge&logo=render&logoColor=white
[Render-url]: https://render.com/

[AmazonS3-logo]: https://img.shields.io/badge/Amazon%20S3-759c14?style=for-the-badge&logo=amazons3&logoColor=white
[AmazonS3-url]: https://aws.amazon.com/s3/
