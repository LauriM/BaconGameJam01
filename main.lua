function love.load()
    img_player = love.graphics.newImage("player.png");
    img_enemy1 = love.graphics.newImage("enemy1.png");

    img_bullet = love.graphics.newImage("bullet.png");

    playerX = 250;
    playerY = 250;
    playerSpeed = 5;

    BULLET_MAX_COUNT = 100;
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
end

function love.draw()
    love.graphics.draw(img_player,playerX,playerY);
end
