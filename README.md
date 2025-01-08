<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://shoesensei.com">
    <img src="https://github.com/user-attachments/assets/55edba10-f689-4f09-ac8a-c0b5f8d0af57" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Shoe Sensei</h3>

  <p align="center">
    Shoes Made Simple.
</div>

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

## Getting Started

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Prerequisites
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
### Start The Local Server
 ```sh
   bin/dev
   ```
This command starts the web server; the js and css watchers. 

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
