if game.PlaceId == 6961824067 then
    local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
    local Window = OrionLib:MakeWindow({Name = "Shadow Menu(FTaP)", HidePremium = false, IntroText = "Shadow Menu FTaP", SaveConfig = true, ConfigFolder = "Shadow Menu"})

    local Tab = Window:MakeTab({
        Name = "Player",
        Icon = "http://www.roblox.com/asset/?id=4382301852",
        PremiumOnly = false
    })
    
    Tab:AddSlider({
        Name = "WalkSpeed",
        Min = 5,
        Max = 1000,
        Default = 5,
        Color = Color3.fromRGB(255, 255, 255),
        Increment = 1,
        ValueName = "Speed",
        Callback = function(Value)
            local player = game.Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("Humanoid") then
                -- Set the WalkSpeed directly
                player.Character.Humanoid.WalkSpeed = Value
            else
                warn("Player or player's character not found.")
            end
        end    
    })
    
    
    
    Tab:AddSlider({
        Name = "JumpPower",
        Min = 26,
        Max = 1000,
        Default = 5,
        Color = Color3.fromRGB(255,255,255),
        Increment = 1,
        ValueName = "JumpPower",
        Callback = function(Value)
            local player = game.Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.JumpPower = Value
            end
        end    
    })


    


    

   
    
    local Tab = Window:MakeTab({
        Name = "Scripts",
        Icon = "http://www.roblox.com/asset/?id=7909819471",
        PremiumOnly = false
    })

    Tab:AddButton({
        Name = "Infinite Yield",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()     
          end    
    })

    
    
    local Tab = Window:MakeTab({
        Name = "Binds",
        Icon = "rbxassetid://532132767",
        PremiumOnly = false
    })

    Tab:AddBind({
        Name = "Teleport",
        Default = Enum.KeyCode.Z,
        Hold = false,
        Callback = function()
            -- Получаем текущего игрока и его камеру
            local player = game.Players.LocalPlayer
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local mouse = player:GetMouse()
            
            -- Проверяем наличие всех необходимых компонентов
            if character and humanoid and mouse then
                -- Определяем позицию, куда телепортировать
                local targetPosition = mouse.Hit.p + Vector3.new(0, 5, 0) -- Добавляем вектор подъема
                
                -- Телепортируем игрока
                character:SetPrimaryPartCFrame(CFrame.new(targetPosition))
            else
                warn("Player, character, humanoid, or mouse not found.")
            end
        end
    })

    local flyForce = Vector3.new(0, 500, 0) -- Force of lift
    local flyDuration = 10 -- Flight duration in seconds (10 seconds)
    
    -- Function to enable flight
    local function enableFly(target)
        if target:IsA("Model") then
            local humanoid = target:FindFirstChildOfClass("Humanoid")
            local rootPart = target:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart then
                -- Create BodyVelocity for lift
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = flyForce
                bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                bodyVelocity.Parent = rootPart
        
                -- Remove BodyVelocity after a short duration
                game:GetService("Debris"):AddItem(bodyVelocity, flyDuration)
            else
                warn("Цель не имеет Humanoid или HumanoidRootPart.")
            end
        elseif target:IsA("BasePart") then
            -- Если цель - отдельная часть
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = flyForce
            bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
            bodyVelocity.Parent = target
        
            -- Remove BodyVelocity after a short duration
            game:GetService("Debris"):AddItem(bodyVelocity, flyDuration)
        else
            warn("Цель не является моделью или отдельной частью.")
        end
    end
    
    -- Add a key bind for flight
    Tab:AddBind({
        Name = "Fly",
        Default = Enum.KeyCode.F,
        Hold = false,
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    -- Исключаем локального игрока из целей мыши
                    local mouse = player:GetMouse()
                    mouse.TargetFilter = character
        
                    local target = mouse.Target
                    if target then
                        enableFly(target)
                    else
                        warn("Не найдена действительная цель.")
                    end
                else
                    warn("Персонаж игрока не имеет Humanoid.")
                end
            else
                warn("Игрок не имеет персонажа.")
            end
        end
    })
    

    


-- Функция для убийства цели
local function killTarget(target)
    if target:IsA("Model") then
        local humanoid = target:FindFirstChildOfClass("Humanoid")
        
        if humanoid then
            humanoid.Health = 0 -- Устанавливаем здоровье на 0 для убийства
        else
            warn("Target does not have Humanoid.")
        end
    else
        warn("Target is not a model.")
    end
end

Tab:AddBind({
    Name = "Kill",
    Default = Enum.KeyCode.G,
    Hold = false,
    Callback = function()
        local player = game.Players.LocalPlayer
        local mouse = player:GetMouse()
        
        mouse.TargetFilter = player.Character -- Исключаем локального игрока из таргетов
        
        local target = mouse.Target
        if target and target.Parent then
            local targetCharacter = target.Parent
            killTarget(targetCharacter)
        else
            warn("No valid target found.")
        end
    end    
})


local lastChatTime = 0
local chatCooldown = 5 -- Время в секундах между сообщениями

-- Функция для отправки сообщения в чат от имени игрока с проверкой на спам
local function chat(player, message)
    local currentTime = tick()
    if currentTime - lastChatTime >= chatCooldown then
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All", player.Name)
        lastChatTime = currentTime
    end
end

-- Функция для начала "ожога" цели с уменьшением здоровья по времени
local function burnTarget(target)
    if target:IsA("Model") then
        local humanoid = target:FindFirstChildOfClass("Humanoid")
        
        if humanoid then
            local damageAmount = 50 -- Количество урона
            local damageInterval = 0.1 -- Интервал в секундах

            -- Функция для применения урона
            local function applyDamage()
                if humanoid and humanoid.Health > 0 then
                    humanoid.Health = humanoid.Health - damageAmount
                    -- Отправляем сообщение в чат игроку, что его здоровье уменьшается
                    chat(game.Players.LocalPlayer, "bye,bye")
                    print(target.Name .. " has " .. humanoid.Health .. " health left.")
                end
            end

            -- Запускаем таймер, который будет применять урон каждые 2 секунды
            local damageTimer
            damageTimer = game:GetService("RunService").Stepped:Connect(function(_, deltaTime)
                damageInterval = damageInterval - deltaTime
                if damageInterval <= 0 then
                    applyDamage()
                    damageInterval = 2 -- Сброс таймера
                end
            end)

            -- Отключаем таймер после смерти цели или других условий
            humanoid.Died:Connect(function()
                if damageTimer then
                    damageTimer:Disconnect()
                end
                print(target.Name .. " has died.")
            end)
        else
            warn("Target does not have Humanoid.")
        end
    else
        warn("Target is not a model.")
    end
end

Tab:AddBind({
    Name = "Burn",
    Default = Enum.KeyCode.X,
    Hold = false,
    Callback = function()
        local player = game.Players.LocalPlayer
        local mouse = player:GetMouse()
        
        mouse.TargetFilter = player.Character -- Исключаем локального игрока из таргетов
        
        local target = mouse.Target
        if target and target.Parent then
            local targetCharacter = target.Parent
            burnTarget(targetCharacter)
        else
            warn("No valid target found.")
        end
    end    
})


end
OrionLib:Init()
