-- CreateEnum
CREATE TYPE "role" AS ENUM ('Coach', 'Player', 'Analyst', 'Owner');

-- CreateTable
CREATE TABLE "user" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "roles" "role"[],
    "teamId" TEXT,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "team" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "ownerId" TEXT NOT NULL,

    CONSTRAINT "team_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sub_team" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "teamId" TEXT NOT NULL,

    CONSTRAINT "sub_team_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "player" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "nickname" TEXT,
    "dateOfBirth" TIMESTAMP(3) NOT NULL,
    "jerseyNumber" INTEGER NOT NULL,
    "height" DOUBLE PRECISION NOT NULL,
    "position" TEXT NOT NULL,
    "handedness" TEXT NOT NULL,
    "active" BOOLEAN NOT NULL,
    "notes" TEXT,
    "teamId" TEXT NOT NULL,
    "subTeamId" TEXT,

    CONSTRAINT "player_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "season" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "teamId" TEXT NOT NULL,

    CONSTRAINT "season_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "match" (
    "id" TEXT NOT NULL,
    "seasonId" TEXT NOT NULL,
    "opponent" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "matchType" TEXT NOT NULL,
    "setScores" JSONB NOT NULL,
    "finalScore" TEXT NOT NULL,

    CONSTRAINT "match_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "match_event" (
    "id" TEXT NOT NULL,
    "matchId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "data" JSONB NOT NULL,

    CONSTRAINT "match_event_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- AddForeignKey
ALTER TABLE "user" ADD CONSTRAINT "user_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "team"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sub_team" ADD CONSTRAINT "sub_team_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "team"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "player" ADD CONSTRAINT "player_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "team"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "player" ADD CONSTRAINT "player_subTeamId_fkey" FOREIGN KEY ("subTeamId") REFERENCES "sub_team"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "season" ADD CONSTRAINT "season_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "team"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "match" ADD CONSTRAINT "match_seasonId_fkey" FOREIGN KEY ("seasonId") REFERENCES "season"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "match_event" ADD CONSTRAINT "match_event_matchId_fkey" FOREIGN KEY ("matchId") REFERENCES "match"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
