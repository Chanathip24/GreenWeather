/*
  Warnings:

  - You are about to drop the column `name` on the `User` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE `User` DROP COLUMN `name`,
    ADD COLUMN `fname` VARCHAR(191) NOT NULL DEFAULT 'Unknown',
    ADD COLUMN `lname` VARCHAR(191) NOT NULL DEFAULT 'User';
