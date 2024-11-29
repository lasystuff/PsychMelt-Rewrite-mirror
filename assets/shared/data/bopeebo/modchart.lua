function generateModchart()
    setPercent("sudden", 100, -1) -- This sets the "sudden" modifier to 100% for all players (-1)
    -- You can also use setValue("sudden", 1, -1); for the same effect
    -- When wanting to target all players, you can omit the -1 aswell, so it ends up as just setValue("sudden", 1)/setPercent("sudden", 100)
end