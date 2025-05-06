# How to run ?

Create a .env file in the root directory and add the following variables:

```env
DB_NAME=
DB_USER=
DB_PASSWORD=
DB_HOST=

PORT=

JWT_SECRET=
```

Then run the following command to start the server:

```bash
docker compose up --build
```
This will build the Docker image and start the server. The server will be available at `http://localhost:3000`.