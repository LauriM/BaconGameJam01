gameState = 0; -- 0 = death, 1 = game 

enemyCount = 0;
desiredEnemyCount = 50;
desiredEnemyTypeMin = 1;
desiredEnemyTypeMax = 1;

playerX = 250;
playerY = 250;
playerSpeed = 7;
playerTimer = 10;
playerWeaponRate = 15;
playerRage = 0;
playerPoints = 0;

BULLET_MAX_COUNT = 500;
bulletAlive = {};
bulletX = {};
bulletY = {};
bulletSpeedX = {}
bulletSpeedY = {}

ENEMY_MAX_COUNT = 500;
enemyAlive = {}
enemyType = {}
enemyX = {}
enemyY = {}

enemySpawnerBaseTime = 50;
enemySpawnerTime = 100;
enemySpawnerTimeRate = 1;

PARTICLE_MAX_COUNT = 500;
particleLife = {}
particleX = {}
particleY = {}
particleSpeedX = {}
particleSpeedY = {}

PI = 3.14159265

startTime = 0;

function love.load()
    img_player = love.graphics.newImage("player.png");
    img_particle = love.graphics.newImage("particle.png");
    img_enemy1 = love.graphics.newImage("enemy1.png");
    img_enemy2 = love.graphics.newImage("enemy2.png");

    img_bullet = love.graphics.newImage("bullet.png");

    music = love.audio.newSource("baconBeatingMusic.mp3",mp3);
    gameState = 0;

    love.graphics.setCaption("REVENGE OF THE FLYING TRIANGLES OF DEATH");
end

function love.update(dt)
    if gameState == 1 then
        --framelimit
        if dt < 1/60 then
            love.timer.sleep(1000 * (1/30 - dt))
        end

        --Base difficulty
        time = getGameTime();--this prevents multitiple calculations of the time
        desiredEnemyCount = time * 2;
        desiredEnemyTypeMin = 1;
        desiredEnemyTypeMax = 1;--only spawn type 1 by default

        --special timings
        if time > 3 and time < 10 then
            desiredEnemyCount = 100;
        end

        if time > 27 and time < 35 then
            desiredEnemyTypeMax = 2;
        end

        if  time > 44 and time < 50 then
            desiredEnemyCount = 150;
        end

        if time > 68 then
            desiredEnemyTypeMin = -10
            desiredEnemyTypeMax = 2
        end

        if time > 100 then
            desiredEnemyTypeMin = -5
            desiredEnemyTypeMax = 2
        end

        if time > 100 then
            desiredEnemyTypeMin = 1
            desiredEnemyTypeMax = 2
        end

        --input
        if love.keyboard.isDown("right") then
            playerX = playerX + playerSpeed;
        end

        if love.keyboard.isDown("left") then
            playerX = playerX - playerSpeed;
        end

        if love.keyboard.isDown("up") then
            playerY = playerY - playerSpeed;
        end

        if love.keyboard.isDown("down") then
            playerY = playerY + playerSpeed;
        end

        if playerX < 0 then
            playerX = 0
        end

        if playerX > love.graphics.getWidth() then
            playerX = love.graphics.getWidth();
        end

        if playerY < 0 then
            playerY = 0
        end

        if playerY > love.graphics.getHeight() then
            playerY = love.graphics.getHeight();
        end

        if love.keyboard.isDown(" ") then
            playerTimer = playerTimer - 1;
            if playerTimer < 0 then
                createBullet(playerX + 10,playerY - 15,5,-7);
                createBullet(playerX + 10,playerY - 15,6,-7);
                createBullet(playerX + 10,playerY - 15,-5,-7);
                createBullet(playerX + 10,playerY - 15,-6,-7);
                playerTimer = playerWeaponRate;
            end
        end

        --update game

        enemySpawner();
        updateBullets();
        updateEnemies();
    else
        if love.keyboard.isDown("n") then
            --start the game
            gameState = 1
            love.audio.stop();
            love.audio.play(music);

            enemySpawnerBaseTime = 50;
            enemySpawnerTime = 100;
            enemySpawnerTimeRate = 1;
            playerX = 250;
            playerY = 500;
            playerPoints = 0;
            gameReset();

            startTime = love.timer.getTime();
        end
    end
end

function getAngle(x1,y1,x2,y2)
    radian = math.atan((x2-x1)/(y2-y1));
    angle = (radian * (180 / PI));

    return radian;
end

function love.draw()
    if gameState == 1 then
        renderParticles();
        renderBullets();
        renderEnemies();
        love.graphics.draw(img_player,playerX,playerY);
        love.graphics.print("POINTS: " .. playerPoints, 0, 0);
        love.graphics.print("Time: " .. getGameTime() .. "s",0,20);
        love.graphics.print("ENEMIESONSCREEN: " .. enemyCount,0,40);
    else
        love.graphics.print("PRESS 'n' TO START A NEW GAME", 150,150);
        if playerPoints > 0 then
            love.graphics.print("Latest score: " .. playerPoints .. " (" .. round(endTime - startTime) .. "s)",150,180);
        end

        love.graphics.draw(img_player,150,200);
        love.graphics.print("You are this",180,200);

        love.graphics.draw(img_enemy1,150,230);
        love.graphics.print("Shoot these",180,230);

        love.graphics.draw(img_enemy2,150,260);
        love.graphics.print("Dodge these",180,260);

        love.graphics.print("Arrows move, space shoots!",180,300);
    end
end

function getGameTime()
    return round(love.timer.getTime() - startTime,2);
end

function updateEnemies()
    speed = 0;
    enemyCount = 0;

    for i=1,ENEMY_MAX_COUNT do
        if enemyAlive[i] == true then
            enemyCount = enemyCount + 1;
            if enemyType[i] == 1 then
                speed = 5;
            end

            if enemyType[i] == 2 then
                speed = 9;
            end

            enemyY[i] = enemyY[i] + speed;

            if enemyY[i] > 700 then
                --kill bots out of bounds
                enemyAlive[i] = false;

                playerPoints = playerPoints + 10;
            end

            --hit on the player
            if pointCollisionCheck(playerX+10,playerY+10,enemyX[i],enemyY[i],20,20) == true then
                gameState = 0
                endTime = love.timer.getTime();
            end
        end
    end
end

function enemySpawner()
    if enemyCount < desiredEnemyCount then
        createEnemy(math.random(0,love.graphics.getWidth()),-10,math.random(desiredEnemyTypeMin,desiredEnemyTypeMax));
    end
    --[[
    enemySpawnerTime = enemySpawnerTime - enemySpawnerTimeRate;

    if enemySpawnerTime < 0 then
        num = math.random(1,6)

        if num < 6 then
            type = 1
        end

        if num > 5 and num < 7 then
            type = 2
        end

        enemySpawnerTime = enemySpawnerBaseTime;
        enemySpawnerBaseTime = enemySpawnerBaseTime - 100;
        createEnemy(math.random(0,800),-10,type);
    end
    ]]--
end

function updateBullets()
    for i=1,BULLET_MAX_COUNT do
        if bulletAlive[i] == true then
            bulletX[i] = bulletX[i] + bulletSpeedX[i];
            bulletY[i] = bulletY[i] + bulletSpeedY[i];

            if bulletY[i] < 0 then
                bulletAlive[i] = false;
            end

            if bulletY[i] > 700 then --TODO: add the real end of the screen value that is correct
                bulletAlive[i] = false;
            end

            --Collision on the ENEMIES THAT ARE EVIL AND BAD
            for q=1,ENEMY_MAX_COUNT do
                if enemyAlive[q] == true and enemyType[q] == 1 then
                    if pointCollisionCheck(bulletX[i],bulletY[i],enemyX[q],enemyY[q],20,20) == true then 
                        enemyAlive[q] = false;

                        --its a kill on enemy
                        for g=0,15 do
                            particleCreate(enemyX[q],enemyY[q]);
                        end
                    end
                end
            end
        end
    end
end

function pointCollisionCheck(x,y,x2,y2,sizeX,sizeY)
    if x > x2  and y > y2 then
        if x < (x2 + sizeX) and y < (y2 + sizeY) then
            return true;
        end
    end

    return false;
end

function createBullet(x,y,speedX,speedY)
    for i=1,BULLET_MAX_COUNT do
        if bulletAlive[i] ~= true then 
            bulletAlive[i] = true;
            bulletX[i] = x;
            bulletY[i] = y;
            bulletSpeedX[i] = speedX;
            bulletSpeedY[i] = speedY;
            do return end
        end
    end

    return 0;
end

function renderBullets() 
    for i=1,BULLET_MAX_COUNT do
        if bulletAlive[i] == true then
            love.graphics.draw(img_bullet,bulletX[i],bulletY[i]);
        end
    end
end

function renderEnemies() 
    for i=1,ENEMY_MAX_COUNT do
        if enemyAlive[i] == true then
            if enemyType[i] == 1 then
                love.graphics.draw(img_enemy1,enemyX[i],enemyY[i]);
            end

            if enemyType[i] == 2 then
                love.graphics.draw(img_enemy2,enemyX[i],enemyY[i]);
            end
        end
    end
end

function createEnemy(x,y,type_t)
    if type_t < 1 then
        type_t = 1;
    end
    for i=1,ENEMY_MAX_COUNT do
        if enemyAlive[i] ~= true then 
            enemyAlive[i] = true;
            enemyX[i] = x;
            enemyY[i] = y;
            enemyType[i] = type_t;
            do return end
        end
    end
    return 0;
end

function gameReset()
    for i=1,ENEMY_MAX_COUNT do
        enemyAlive[i] = false;
    end

    for i=1,BULLET_MAX_COUNT do
        bulletAlive[i] = false;
    end

    for i=1,PARTICLE_MAX_COUNT do
        particleLife[i] = -1;
    end
end

function particleCreate(x,y)
    for i=1,PARTICLE_MAX_COUNT do
        if particleLife[i] < 1 then
            particleLife[i] = math.random(100,250);
            particleX[i] = x;
            particleY[i] = y;
            particleSpeedX[i] = math.random(-5,5);
            particleSpeedY[i] = math.random(-5,5);
            do return end
        end
    end
end

function renderParticles()
    for i=1,PARTICLE_MAX_COUNT do
        if particleLife[i] > 0 then
            particleLife[i] = particleLife[i] - 1;
            particleX[i] = particleX[i] + particleSpeedX[i];
            particleY[i] = particleY[i] + particleSpeedY[i];
            love.graphics.draw(img_particle,particleX[i],particleY[i]);
        end
    end
end

function round(number, decimal)
	local multiplier = 10^(decimal or 0)
	return math.floor(number * multiplier + 0.5) / multiplier
end
