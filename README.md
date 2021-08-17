# Merchants SE

## Installation

Build the image:
```sh
docker-compose build
```

Create the database:
```sh
docker-compose run web rake db:create
```

Run the migrations:
```sh
docker-compose run web rake db:migrate
```

Run the app:
```sh
docker-compose up
```


## Requirements:
- [x] PostgreSQL
- [x] Devise auth
- [x] API route to insert list of merchants
	- [x] authenticate requests using user email & api key
	- [x] cleanup merchants names
- [x] Validation rules for merchants -- the described 
- [x] Full-text search filter by merchant name
- [x] Filter by phone and website from extra fields
- [x] Integrate bootstrap and some css



To upload the csv file you must first sign in and get the api token.
Example using curl:
```sh
curl -X POST 'http://localhost:3000/users/sign_in' --data '{"email":"test@mail.md", "password": "qqqqqq"}'
```

If the credentials are correct you will get an auth token:
```json
{"token":"eyJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6InRlc3RAbWFpbC5tZCIsImV4cGlyYXRpb24iOjE2MjkxOTQ2OTZ9.8Je3EQyM0i-xmElkZBZuZN4j5AEG5_24GAoBCUUAm_0"}%
```

Then, with the received token you can make POST request to upload a csv file with merchants data.
```sh
curl -X POST -H 'Content-Type: multipart/form-data' -F file=@data.csv "http://localhost:3000/merchants" -H "Authorization: Bearer <token>"
```


## Bonus points:
- [ ] Unit tests (Rspec)
- [ ] Roles for users so they can(not) CRUD merchants depending on their role

