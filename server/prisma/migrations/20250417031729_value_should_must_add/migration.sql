/*
  Warnings:

  - Made the column `value` on table `Reward` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE `Reward` MODIFY `value` VARCHAR(191) NOT NULL;
