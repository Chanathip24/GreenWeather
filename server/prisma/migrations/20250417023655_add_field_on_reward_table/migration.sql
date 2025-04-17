/*
  Warnings:

  - Added the required column `total` to the `Reward` table without a default value. This is not possible if the table is not empty.
  - Added the required column `type` to the `Reward` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `Reward` ADD COLUMN `total` INTEGER NOT NULL,
    ADD COLUMN `type` VARCHAR(191) NOT NULL;
