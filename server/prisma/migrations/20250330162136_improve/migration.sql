/*
  Warnings:

  - You are about to drop the `WeatherReport` table. If the table is not empty, all the data it contains will be lost.

*/
-- AlterTable
ALTER TABLE `Review` ADD COLUMN `dislike` INTEGER NOT NULL DEFAULT 0,
    MODIFY `rating` INTEGER NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE `User` ADD COLUMN `refreshToken` VARCHAR(191) NULL;

-- DropTable
DROP TABLE `WeatherReport`;
