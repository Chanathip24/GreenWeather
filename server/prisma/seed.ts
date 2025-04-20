import { PrismaClient, Role, PointType } from '@prisma/client';
import bcrypt from 'bcrypt';
import dotenv from 'dotenv';
dotenv.config();
const prisma = new PrismaClient();
const weatherOptions = ['Cloud', 'Clear', 'Rain', 'Haze', 'Mist'];

async function main() {
  const saltRounds = parseInt(process.env.SALT_ROUND || '10', 10);
  
  //add admin
  const hashedPassword = await bcrypt.hash(`@Admin123`, saltRounds);
  await prisma.user.create({
    data: {
      email: `admin@greenweather.com`,
      password: hashedPassword,
      fname: `Admin`,
      lname: `Admin`,
      points : 99999999,
      role: Role.ADMIN, // Changed from USER to ADMIN
    },
  });
  
  const users = [];
  // --- Create 10 users ---
  for (let i = 1; i <= 10; i++) {
    const hashedPassword = await bcrypt.hash(`@User${i}pass`, saltRounds);
    const user = await prisma.user.create({
      data: {
        email: `user${i}@greenweather.com`,
        password: hashedPassword,
        fname: `User${i}`,
        lname: `Lastname${i}`,
        role: Role.USER,
        points : i + i+10
      },
    });
    users.push(user);
  }

  // --- Create 1 reward (for all to redeem) ---
  const reward = await prisma.reward.create({
    data: {
      name: 'Eco Bottle',
      description: 'Reusable eco-friendly water bottle',
      cost: 10,
      type: 'VOUCHERS',
      imgUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqmzFhlGbO8aCnQyxRqlpg6AITfdmWphuQMg&s',
    },
  });
  const reward2 = await prisma.reward.create({
    data: {
      name: 'Amazon Gift Card',
      description: '',
      cost: 100,
      type: 'DIGITAL',
      imgUrl: 'https://seagm-media.seagmcdn.com/item_480/422.png',
    },
  });
  //type VOUCHERS , DIGITAL,FOOD

  for (const user of users) {
    // --- Create review ---
    const review = await prisma.review.create({
      data: {
        userId: user.id,
        main: weatherOptions[Math.floor(Math.random() * weatherOptions.length)],
        location: 'Bangkok',
        aqi: Math.floor(Math.random() * 100),
        rating: Math.floor(Math.random() * 5) + 1,
        detail: `Weather review by ${user.fname}`,
      },
    });
    
    // --- Add 10 points for review ---
    await prisma.pointTransaction.create({
      data: {
        userId: user.id,
        points: 10,
        type: PointType.ADD,
        reason: 'Review Submitted',
      },
    });
    
    // --- Create rewardValue ---
    const rewardValue = await prisma.rewardValue.create({
      data: {
        rewardId: reward.id,
        value: `REWARD-${user.fname.toUpperCase()}-${Math.floor(Math.random() * 1000)}`,
      },
    });
    
    // --- Redeem reward ---
    await prisma.redemption.create({
      data: {
        userId: user.id,
        rewardId: reward.id,
        rewardValueId: rewardValue.id,
      },
    });
    
    // --- Subtract 10 points for redemption ---
    await prisma.pointTransaction.create({
      data: {
        userId: user.id,
        points: 10,
        type: PointType.SUBTRACT,
        reason: 'Reward Redeemed',
      },
    });
    
    // --- Random like another user's review ---
    const otherUsers = users.filter((u) => u.id !== user.id);
    const likedUser = otherUsers[Math.floor(Math.random() * otherUsers.length)];
    const likedReview = await prisma.review.findFirst({
      where: { userId: likedUser.id },
    });
    
    if (likedReview) {
      await prisma.reviewLike.create({
        data: {
          userId: user.id,
          reviewId: likedReview.id,
        },
      });
    }
  }
  
  console.log('🌱 10 Users seeded with reviews, rewards, and likes!');
}

main()
  .catch((e) => {
    console.error('❌ Seed error:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });