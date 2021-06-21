-- Tabletop Simulator SmartMeeple™ Script By Alex_Sour
-- v1.0.0

-- License: You can use this for non-commercial purposes IF you:

-- 1. Ask me, you can contact me on Discord by Alex_Sour#1856
-- 2. Give credit

-- I can revoke this or modify these terms ANYTIME and for ANY REASON.

-- I retain ALL RIGHTS to this code and any related SmartMeeple™ content.

-- SmartMeeple™ is a trademark of Alex_Sour.

-- Tabletop Simulator is owned by Berserk Games. I am not affiliated with them in any way besides making UGC for the game.


hp = 100
food = 100
timer = 0.00
timer2 = 0.00
interval = 25

function onLoad()

    self.addContextMenuItem('Harm', harm, true)
    self.addContextMenuItem('Make Hungry', hunger, false)

    if self.getDescription() != nil then

        if self.getDescription() != '' then

            desc = self.getDescription()

            if desc:find('%d+') then

                lines = desc:gmatch('(%d+)')

                hp = tonumber(lines())
                food = tonumber(lines())

                printToAll(hp .. '% HP, ' .. food .. '% Food')

            else

                printToAll(hp .. '% HP, ' .. food .. '% Food')

            end

        end

    end

end

function  onUpdate()

    timer = timer + Time.delta_time

    timer2 = timer2 + Time.delta_time

    if timer >= interval then
        timer = 0.00
        food = food - 1
    end

    if food > 100 then
        food = 100
    end

    if hp > 100 then
        hp = 100
    end

    if hp <= 0 then
        printToAll('ded')
        self.destroy()
    end

    if timer2 >= 8.00 then

        timer2 = 0.00

        if food <= 0 then
            hp = hp - 1
        end

        if food >= 25 then
            hp = hp + 1
        end

    end

    if food < 0 then
        food = 0
    end

    self.setDescription(hp .. '% HP\n' .. food .. '% Food')

end

function harm()

    if tonumber(10) >= tonumber(hp) then

        printToAll('ded')
        self.destroy()

    else

        hp = hp - 10

        if maybe(50) then
            objectSay(self, 'ouch')
        else
            objectSay(self, 'ow')
        end

    end

end

function hunger()
    food = 10
end

function maybe(x)
    if 100 * math.random() < x then
        return true
    else
        return false
    end
end

function objectToHex(o)
    r = string.format('%x', o.getColorTint().r * 255)
    g = string.format('%x', o.getColorTint().g * 255)
    b = string.format('%x', o.getColorTint().b * 255)
    if #r == 1 then
        r = '0' .. r
    end
    if #g == 1 then
        g = '0' .. g
    end
    if #b == 1 then
        b = '0' .. b
    end
    return r .. g .. b
end

function objectSay(o,m)
    if o.getName() != nil and o.getName() != '' then
        printToAll('[' .. objectToHex(o) .. ']' .. o.getName() .. ':[-] ' .. m)
    else
        printToAll('[' .. objectToHex(o) .. ']' .. 'Citizen' .. ':[-] ' .. m)
    end
end

delay = 0

function onCollisionEnter(info)

    if delay > 0 then
        delay = delay - 1
        return
    end

    damage = math.floor(math.sqrt((info.relative_velocity[1] ^ 2)+(0)+(info.relative_velocity[3] ^ 2)))
    damager = math.abs(damage)
    damager2 = damager * 3

    if tonumber(damager2) >= 2 and tonumber(damager2) < tonumber(hp) then

        if delay <= 0 then

            if self.getName() != nil and self.getName() != '' then

                delay = 2
                if maybe(50) then
                    objectSay(self, 'ouch')
                else
                    objectSay(self, 'ow')
                end

            else
                delay = 2

                if maybe(50) then
                    objectSay(self, 'ouch')
                else
                    objectSay(self, 'ow')
                end

            end

        end

        hp = hp - damager2

    elseif tonumber(damager2) >= 2 and tonumber(damager2) >= tonumber(hp) then
        printToAll('ded')
        self.destroy()
    end

    if info.collision_object.hasTag('food') then
        food = food + 20
        delay = 2
        info.collision_object.destroy()
    end

    if info.collision_object.hasTag('stateFood') then
        food = food + 20
        delay = 2
        info.collision_object.setState(info.collision_object.getStateId() + 1)
    end

    if info.collision_object.hasTag('healthPotion') then
        food = food + 10
        hp = hp + 50
        delay = 2
        info.collision_object.setState(info.collision_object.getStateId() + 1)
    end

    if info.collision_object.hasTag('healthFruit') then
        food = food + 7
        hp = hp + 30
        delay = 2
        info.collision_object.destroy()
    end

    if info.collision_object.hasTag('underageHealthPotion') then
        delay = 2
        food = food + 10
        hp = hp + 100
        info.collision_object.setState(info.collision_object.getStateId() + 1)
    end

end
