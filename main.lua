playerX = 250;
playerY = 250;
playerSpeed = 5;

BULLET_MAX_COUNT = 100;
bulletAlive = {};
bulletX = {};
bulletY = {};
bulletSpeedX = {}
bulletSpeedY = {}
message = "test";

function love.load()
    img_player = love.graphics.newImage("player.png");
    img_enemy1 = love.graphics.newImage("enemy1.png");

    img_bullet = love.graphics.newImage("bullet.png");

end

function love.update(dt)
    --framelimit
    if dt < 1/30 then
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
        createBullet(playerX + 10,playerY - 15,0,-10);
    end

    --update game

    updateBullets();
end

function love.draw()
    love.graphics.draw(img_player,playerX,playerY);
    renderBullets();
    love.graphics.print(message,0,0);
end

function updateBullets()
    for i=1,BULLET_MAX_COUNT do
        if bulletAlive[i] == true then
            bulletX[i] = bulletX[i] + bulletSpeedX[i];
            bulletY[i] = bulletY[i] + bulletSpeedY[i];
        end
    end
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
