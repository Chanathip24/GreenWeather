-- AlterTable
ALTER TABLE `User` ADD COLUMN `resetPasswordToken` TEXT NULL,
    ADD COLUMN `updateAt` DATETIME(3) NULL,
    MODIFY `refreshToken` TEXT NULL;
