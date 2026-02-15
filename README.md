<div align="center">

![Truck Signs](./screenshots/Truck_Signs_logo.png)

# Signs for Trucks

![Python version](https://img.shields.io/badge/Pythn-3.8.10-4c566a?logo=python&&longCache=true&logoColor=white&colorB=pink&style=flat-square&colorA=4c566a) ![Django version](https://img.shields.io/badge/Django-2.2.8-4c566a?logo=django&&longCache=truelogoColor=white&colorB=pink&style=flat-square&colorA=4c566a) ![Django-RestFramework](https://img.shields.io/badge/Django_Rest_Framework-3.12.4-red.svg?longCache=true&style=flat-square&logo=django&logoColor=white&colorA=4c566a&colorB=pink)


</div>

## Table of Contents
* [Description](#description)
* [Quickstart](#quickstart)
* [How to build the image](#how-to-build-the-image)
* [Usage](#usage)
* [Screenshots of the Django Backend Admin Panel](#screenshots-of-the-django-backend-admin-panel)
* [Useful Links](#useful-links)



## Description

__Signs for Trucks__ is an online store to buy pre-designed vinyls with custom lines of letters (often call truck letterings). The store also allows clients to upload their own designs and to customize them on the website as well. Aside from the vinyls that are the main product of the store, clients can also purchase simple lettering vinyls with no truck logo, a fire extinguisher vinyl, and/or a vinyl with only the truck unit number (or another number selected by the client).

### Settings

The __settings__ folder inside the trucks_signs_designs folder contains the different setting's configuration for each environment (so far the environments are development, docker testing, and production). Those files are extensions of the base.py file which contains the basic configuration shared among the different environments (for example, the value of the template directory location). In addition, the .env file inside this folder has the environment variables that are mostly sensitive information and should always be configured before use. By default, the environment in use is the decker testing. To change between environments modify the \_\_init.py\_\_ file.

### Models

Most of the models do what can be inferred from their name. The following dots are notes about some of the models to make clearer their propose:
- __Category Model:__ The category of the vinyls in the store. It contains the title of the category as well as the basic properties shared among products that belong to a same category. For example, _Truck Logo_ is a category for all vinyls that has a logo of a truck plus some lines of letterings (note that the vinyls are instances of the model _Product_). Another category is _Fire Extinguisher_, that is for all vinyls that has a logo of a fire extinguisher. 
- __Lettering Item Category:__ This is the category of the lettering, for example: _Company Name_, _VIM NUMBER_, ... Each has a different pricing.
- __Lettering Item Variations:__ This contains a foreign key to the __Lettering Item Category__ and the text added by the client.
- __Product Variation:__ This model has the original product as a foreign key, plus the lettering lines (instances of the __Lettering Item Variations__ model) added by the client.
- __Order:__ Contains the cart (in this case the cart is just a vinyl as only one product can be purchased each time). It also contains the contact and shipping information of the client.
- __Payment:__ It has the payment information such as the time of the purchase and the client id in Stripe.

To manage the payments, the payment gateway in use is [Stripe](https://stripe.com/).

### Brief Explanation of the Views

Most of the views are CBV imported from _rest_framework.generics_, and they allow the backend api to do the basic CRUD operations expected, and so they inherit from the _ListAPIView_, _CreateAPIView_, _RetrieveAPIView_, ..., and so on.

The behavior of some of the views had to be modified to address functionalities such as creation of order and payment, as in this case, for example, both functionalities are implemented in the same view, and so a _GenericAPIView_ was the view from which it inherits. Another example of this is the _UploadCustomerImage_ View that takes the vinyl template uploaded by the clients and creates a new product based on it.


## Quickstart
Clone the repository from GitHub
```bash
git clone git@github.com:ibog1/truck_signs_api.git
```

Navigate to the folder
```bash
cd truck_signs_api
```

Create .env
```bash
touch .env
```
> [!CAUTION]
> The `.env` file contains dummy variables.

Generate a Django secret key:
```bash
python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
```

> [!NOTE]
> Paste the generated key into your `.env`.


Create Docker network

``` bash
docker network create truck-signs-net 
```

Start PostgreSQL container

``` bash
docker run -d \
  --name truck-signs-db \
  --network truck-signs-net \
  -e POSTGRES_DB=truck_signs \
  -e POSTGRES_USER=truck_user \
  -e POSTGRES_PASSWORD=<POSTGRES_PASSWORD> \
  postgres:13
```

Build backend image

``` bash
docker build -t truck-signs-app .
```

Run backend container

``` bash
docker run -d \
  --name truck-signs-app \
  --network truck-signs-net \
  -p 8020:8020 \
  --env-file truck_signs_designs/settings/.env \
  truck-signs-app
```

The API is available at:

    http://<YOUR_IP>:8020

The Django Admin interface is available at:

    http://<YOUR_IP>:8020/admin/


## Usage

#### Environment Configuration

The application is configured via environment variables provided through
an external `.env` file in the project root (loaded with `--env-file .env`).

Required variables include:

- `DOCKER_SECRET_KEY` – Django secret key used in the Docker environment.
- `DB_NAME` – Name of the PostgreSQL database (e.g. `truck_signs`).
- `DB_USER` – Database user (e.g. `truck_user`).
- `DB_PASSWORD` – Database password used by the PostgreSQL container.
- `DB_HOST` – Hostname of the database container (e.g. `truck-signs-db`).
- `DB_PORT` – Database port (usually `5432`).
- `DOCKER_ALLOWED_HOSTS` – Comma-separated list of allowed hosts (e.g. `<YOUR_IP>,localhost`).

Optional variables:

- `DOCKER_STRIPE_PUBLISHABLE_KEY`, `DOCKER_STRIPE_SECRET_KEY` – Stripe API keys (only needed if payment is enabled).
- `DOCKER_EMAIL_HOST_USER`, `DOCKER_EMAIL_HOST_PASSWORD` – SMTP credentials for sending emails.


<a name="screenshots"></a>

## Screenshots of the Django Backend Admin Panel

### Mobile View

<div align="center">

![alt text](./screenshots/Admin_Panel_View_Mobile.png)  ![alt text](./screenshots/Admin_Panel_View_Mobile_2.png) ![alt text](./screenshots/Admin_Panel_View_Mobile_3.png)

</div>
---

### Desktop View

![alt text](./screenshots/Admin_Panel_View.png)

---

![alt text](./screenshots/Admin_Panel_View_2.png)

---

![alt text](./screenshots/Admin_Panel_View_3.png)



<a name="useful_links"></a>
## Useful Links

### Postgresql Database
- Setup Database: [Digital Ocean Link for Django Deployment on VPS](https://www.digitalocean.com/community/tutorials/how-to-set-up-django-with-postgres-nginx-and-gunicorn-on-ubuntu-16-04)

### Docker
- [Docker Oficial Documentation](https://docs.docker.com/)
- Dockerizing Django, PostgreSQL, guinicorn, and Nginx:
    - Github repo of sunilale0: [Link](https://github.com/sunilale0/django-postgresql-gunicorn-nginx-dockerized/blob/master/README.md#nginx)
    - Michael Herman article on testdriven.io: [Link](https://testdriven.io/blog/dockerizing-django-with-postgres-gunicorn-and-nginx/)

### Django and DRF
- [Django Official Documentation](https://docs.djangoproject.com/en/4.0/)
- Generate a new secret key: [Stackoverflow Link](https://stackoverflow.com/questions/41298963/is-there-a-function-for-generating-settings-secret-key-in-django)
- Modify the Django Admin:
    - Small modifications (add searching, columns, ...): [Link](https://realpython.com/customize-django-admin-python/)
    - Modify Templates and css: [Link from Medium](https://medium.com/@brianmayrose/django-step-9-180d04a4152c)
- [Django Rest Framework Official Documentation](https://www.django-rest-framework.org/)
- More about Nested Serializers: [Stackoverflow Link](https://stackoverflow.com/questions/51182823/django-rest-framework-nested-serializers)
- More about GenericViews: [Testdriver.io Link](https://testdriven.io/blog/drf-views-part-2/)

### Miscellaneous
- Create Virual Environment with Virtualenv and Virtualenvwrapper: [Link](https://docs.python-guide.org/dev/virtualenvs/)
- [Configure CORS](https://www.stackhawk.com/blog/django-cors-guide/)
- [Setup Django with Cloudinary](https://cloudinary.com/documentation/django_integration)

