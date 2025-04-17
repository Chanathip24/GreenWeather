/*
  Warnings:

  - You are about to drop the column `value` on the `Redemption` table. All the data in the column will be lost.
  - You are about to drop the column `value` on the `Reward` table. All the data in the column will be lost.
  - Added the required column `rewardValueId` to the `Redemption` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `Redemption` DROP COLUMN `value`,
    ADD COLUMN `rewardValueId` INTEGER NOT NULL;

-- AlterTable
ALTER TABLE `Reward` DROP COLUMN `value`;

-- CreateTable
CREATE TABLE `RewardValue` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `rewardId` INTEGER NOT NULL,
    `value` VARCHAR(191) NOT NULL,
    `isUsed` BOOLEAN NOT NULL DEFAULT false,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `RewardValue_value_key`(`value`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `RewardValue` ADD CONSTRAINT `RewardValue_rewardId_fkey` FOREIGN KEY (`rewardId`) REFERENCES `Reward`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Redemption` ADD CONSTRAINT `Redemption_rewardValueId_fkey` FOREIGN KEY (`rewardValueId`) REFERENCES `RewardValue`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
