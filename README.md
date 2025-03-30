
# GreenWeather

## Description

This project is a weather forecast application built using Flutter for Frontend. Backend we using bun as a runtime and we use Express as a backend framework.

## Setup and Installation Frontend
Follow these steps to set up the project locally:

1. **Clone the repository**

   ```bash
   git clone https://github.com/Chanathip24/GreenWeather
   cd greenweather
   ```

2. **Install dependencies**


   ```bash
   flutter pub get
   ```
3. Running Application on your emulator.

## Setup and Installation Backend

1. **Install dependencies**

   ```bash
   bun install
   ```


## Environment Variables

The project uses environment variables to manage sensitive data and configuration settings. To set up your environment variables, follow these steps:

1. **Create a `.env` file**

   Inside the root folder of the project (e.g., `server/`), create a new `.env` file. You can do this manually or by copying the template provided below.

2. **Add environment variables**

   Add the following configuration to the `.env` file:

   ```env
   DATABASE_URL=your-database-connection-url-here
   PORT=3000
   SALT_ROUND=10
   JWT_KEY=your-secret-jwt-key-here
   ```

   - **`DATABASE_URL`**: The URL to your database. Replace with your actual database connection URL (e.g., PostgreSQL, MySQL, etc.).
   - **`PORT`**: The port number your server will run on (default is `3000`).
   - **`SALT_ROUND`**: The number of rounds for bcrypt hashing (default is `10`, but you can adjust as needed).
   - **`JWT_KEY`**: The secret key used for signing JWT tokens. Make sure to use a secure, random value.

3. **Example `.env` file**:

   ```env
   DATABASE_URL=mysql://user:password@localhost:3306/mydatabase
   PORT=3000
   SALT_ROUND=12
   JWT_KEY=your-secure-random-jwt-key
   ```


## Running the Application

1. **Start the development server**

   Run the following command to start the server:

   ```bash
   bun run dev
   ```


   The application should now be running on the specified `PORT`.


