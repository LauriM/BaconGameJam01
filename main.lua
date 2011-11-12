angle = 0;

playerX = 250;
playerY = 250;
playerSpeed = 7;
playerTimer = 10;

BULLET_MAX_COUNT = 500;
bulletAlive = {};
bulletX = {};
bulletY = {};
bulletSpeedX = {}
bulletSpeedY = {}

ENEMY_MAX_COUNT = 250;
enemyAlive = {}
enemyType = {}
enemyX = {}
enemyY = {}

enemySpawnerBaseTime = 50;
enemySpawnerTime = 100;
enemySpawnerTimeRate = 1;

PI = 3.14159265

function love.load()
    img_player = love.graphics.newImage("player.png");
    img_enemy1 = love.graphics.newImage("enemy1.png");

    img_bullet = love.graphics.newImage("bullet.png");

    music = love.audio.newSource("baconBeatingMusic.mp3",mp3);
    love.audio.play(music);
end

function love.update(dt)
    --framelimit
    if dt < 1/60 then
        love.timer.sleep(1000 * (1/30 - dt))
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

    if love.keyboard.isDown(" ") then
        playerTimer = playerTimer - 1;
        if playerTimer < 0 then
            createBullet(playerX + 10,playerY - 15,0,-7);
            createBullet(playerX + 10,playerY - 15,5,-7);
            createBullet(playerX + 10,playerY - 15,-5,-7);
            playerTimer = 10;
        end
    end

    --update game

    enemySpawner();
    updateBullets();
    updateEnemies();
end

function getAngle(x1,y1,x2,y2)
    radian = math.atan((x2-x1)/(y2-y1));
    angle = (radian * (180 / PI));

    return radian;
end

function love.draw()
    renderBullets();
    renderEnemies();
    love.graphics.draw(img_player,playerX,playerY);
end

function updateEnemies()
    speed = 0;

    for i=1,ENEMY_MAX_COUNT do
        if enemyAlive[i] == true then
            if enemyType[i] == 1 then
                speed = 5;
            end

            enemyY[i] = enemyY[i] + speed;

            if enemyY[i] > 700 then
                enemyAlive[i] = false;
            end
        end
    end
end

function enemySpawner()
    enemySpawnerTime = enemySpawnerTime - enemySpawnerTimeRate;

    if enemySpawnerTime < 0 then
        enemySpawnerTime = enemySpawnerBaseTime;
        enemySpawnerBaseTime = enemySpawnerBaseTime - 100;
        createEnemy(math.random(0,800),-10,1);
    end
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
                if enemyAlive[q] == true then
                    if pointCollisionCheck(bulletX[i],bulletY[i],enemyX[q],enemyY[q],20,20) == true then 
                        enemyAlive[q] = false;
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
        end
    end
end

function createEnemy(x,y,type_t)
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


