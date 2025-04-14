/*
  Warnings:

  - You are about to drop the column `imageUrl` on the `Review` table. All the data in the column will be lost.
  - Added the required column `type` to the `PointTransaction` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `PointTransaction` ADD COLUMN `type` ENUM('ADD', 'SUBTRACT') NOT NULL;

-- AlterTable
ALTER TABLE `Review` DROP COLUMN `imageUrl`,
    ADD COLUMN `aqi` INTEGER NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE `User` MODIFY `fname` VARCHAR(191) NOT NULL DEFAULT 'Unknownfname',
    MODIFY `lname` VARCHAR(191) NOT NULL DEFAULT 'Unknownlname';
