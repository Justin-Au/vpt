import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

describe('Database connection', () => {
  afterAll(async () => {
    await prisma.$disconnect();
  });

  it('should connect to the database', async () => {
    const result = await prisma.$queryRaw`SELECT 1`;
    expect(result).toBeDefined();
  });
});