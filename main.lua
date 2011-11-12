function love.load()
    img_player = love.graphics.newImage("player.png");
    img_enemy1 = love.graphics.newImage("enemy1.png");

    img_bullet = love.graphics.newImage("bullet.png");

    playerX = 250;
    playerY = 250;
    playerSpeed = 5;

    BULLET_MAX_COUNT = 100;
    bulletAlive = {};
    bulletX = {};
    bulletY = {};
    message = "test";
end

function love.update(dt)
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
        createBullet(playerX + 10,playerY - 15);
    end
end

function love.draw()
    love.graphics.draw(img_player,playerX,playerY);
    renderBullets();
    love.graphics.print(message,0,0);
end

function createBullet(x,y)
    for i=1,BULLET_MAX_COUNT do
        if bulletAlive[i] ~= false then 
            bulletAlive[i] = true;
            bulletX[i] = x;
            bulletY[i] = y;
            return 1;
        end
    end

    return 0;
end

function renderBullets() 
    for i=1,BULLET_MAX_COUNT do
        if bulletAlive[i] == true then
            love.graphics.draw(img_bullet,bulletX[i],bulletY[i]);
            message = "blargh";
        end
    end
end
