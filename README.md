# GreenWeather


![Flutter](https://img.shields.io/badge/Flutter-3.0-blue?logo=flutter)
![Express](https://img.shields.io/badge/Express.js-Backend-black?logo=express)
![Bun](https://img.shields.io/badge/Bun-JS_Runner-yellow?logo=bun)
![License](https://img.shields.io/github/license/Chanathip24/GreenWeather)

## 🌱 Description

GreenWeather is a weather forecast application built using Flutter for the frontend ,Bun (with Express.js) for the backend and Mysql for database. The application provides weather updates based on APIs and also allows users to report real-time weather conditions in their area to improve forecast accuracy.

Users who report weather data can earn points, compete on a leaderboard, and redeem rewards such as coupons or other benefits.

## 🚀 Features

- Real-time weather data from external APIs
- User-generated weather reports to enhance data accuracy
- Points system for user reports
- Leaderboard ranking users by contribution points
- Reward system with redeemable coupons

## 🧑‍💻 Tech Stack

| Layer     | Technology          |
|-----------|---------------------|
| Frontend  | Flutter             |
| Backend   | Bun + Express       |
| Database  | MySQL   |
| API       | OpenWeatherMap, WAQI |

## 📦 Setup and Installation - Frontend

Follow these steps to set up the Flutter frontend locally:

1. **Clone the repository**

   ```bash
   git clone https://github.com/Chanathip24/GreenWeather
   cd greenweather
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Create a `.env` file**

   Inside the root folder of the project (e.g., `greenweather/`), create a new `.env` file and add:

   ```env
   API_URL=your-backend-route
   POINT_REVIEW_REWARD = your point should the same with backend api
   ```

   Replace `your-backend-route` with your actual backend server URL.

4. **Run the application** on your emulator or device.

## Setup and Installation - Backend

1. **Navigate to the server folder**

   ```bash
   cd server
   ```

2. **Install dependencies**

   ```bash
   bun install
   ```

3. **Create a `.env` file**

   Inside `server/`, create a `.env` file and add the following configuration:

   ```env
   DATABASE_URL=your-database-connection-url-here
   PORT=3000
   SALT_ROUND=10
   JWT_KEY=your-secret-jwt-key-here
   WEATHER_API_KEY=your-api-key-OpenweathermapAPI
   WAQI_KEY=your-api-key-WAQIAPI
   POINT_REVIEW_REWARD = point-per-review
   ```

   Replace the placeholders with your actual configuration values.

4. **Migrate database**

   After setting `DATABASE_URL` in .env file you can migrate database into your db server.
   ```bash
   npx prisma migrate dev
   ```

   
5. **Start the backend server**

   ```bash
   bun run dev
   ```

   The backend will now be running on the specified `PORT`.

## Example `.env` file

```env
DATABASE_URL=mysql://user:password@localhost:3306/mydatabase
PORT=3000
SALT_ROUND=12
JWT_KEY=your-secure-random-jwt-key
WEATHER_API_KEY=your-api-key-OpenweathermapAPI
WAQI_KEY=your-api-key-WAQIAPI
POINT_REVIEW_REWARD = 15
```



# GreenWeather


![Flutter](https://img.shields.io/badge/Flutter-3.0-blue?logo=flutter)
![Express](https://img.shields.io/badge/Express.js-Backend-black?logo=express)
![Bun](https://img.shields.io/badge/Bun-JS_Runner-yellow?logo=bun)
![License](https://img.shields.io/github/license/Chanathip24/GreenWeather)

## 🌱 Description

GreenWeather is a weather forecast application built using Flutter for the frontend ,Bun (with Express.js) for the backend and Mysql for database. The application provides weather updates based on APIs and also allows users to report real-time weather conditions in their area to improve forecast accuracy.

Users who report weather data can earn points, compete on a leaderboard, and redeem rewards such as coupons or other benefits.

## 🚀 Features

- Real-time weather data from external APIs
- User-generated weather reports to enhance data accuracy
- Points system for user reports
- Leaderboard ranking users by contribution points
- Reward system with redeemable coupons

## 🧑‍💻 Tech Stack

| Layer     | Technology          |
|-----------|---------------------|
| Frontend  | Flutter             |
| Backend   | Bun + Express       |
| Database  | MySQL   |
| API       | OpenWeatherMap, WAQI |

## 📦 Setup and Installation - Frontend

Follow these steps to set up the Flutter frontend locally:

1. **Clone the repository**

   ```bash
   git clone https://github.com/Chanathip24/GreenWeather
   cd greenweather
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Create a `.env` file**

   Inside the root folder of the project (e.g., `greenweather/`), create a new `.env` file and add:

   ```env
   API_URL=your-backend-route
   POINT_REVIEW_REWARD = your point should the same with backend api
   ```

   Replace `your-backend-route` with your actual backend server URL.

4. **Run the application** on your emulator or device.

## Setup and Installation - Backend

1. **Navigate to the server folder**

   ```bash
   cd server
   ```

2. **Install dependencies**

   ```bash
   bun install
   ```

3. **Create a `.env` file**

   Inside `server/`, create a `.env` file and add the following configuration:

   ```env
   DATABASE_URL=your-database-connection-url-here
   PORT=3000
   SALT_ROUND=10
   JWT_KEY=your-secret-jwt-key-here
   WEATHER_API_KEY=your-api-key-OpenweathermapAPI
   WAQI_KEY=your-api-key-WAQIAPI
   POINT_REVIEW_REWARD = point-per-review
   ```

   Replace the placeholders with your actual configuration values.

4. **Migrate database**

   After setting `DATABASE_URL` in .env file you can migrate database into your db server.
   ```bash
   npx prisma migrate dev
   ```

   
5. **Start the backend server**

   ```bash
   bun run dev
   ```

   The backend will now be running on the specified `PORT`.

## Example `.env` file

```env
DATABASE_URL=mysql://user:password@localhost:3306/mydatabase
PORT=3000
SALT_ROUND=12
JWT_KEY=your-secure-random-jwt-key
WEATHER_API_KEY=your-api-key-OpenweathermapAPI
WAQI_KEY=your-api-key-WAQIAPI
POINT_REVIEW_REWARD = 15
```
** IMPORTANT **
   ผู้ใช้แอดมิน 1 คน - มีอีเมล admin@greenweather.com และรหัสผ่าน @Admin123
   ผู้ใช้ทั่วไป 10 คน - มีอีเมลในรูปแบบ user1@greenweather.com ถึง user10@greenweather.com และรหัสผ่านในรูปแบบ @User1pass ถึง @User10pass
   ของรางวัล 1 รายการ - "Eco Bottle" ที่มีราคา 10 แต้ม


