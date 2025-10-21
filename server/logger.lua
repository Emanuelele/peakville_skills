Logger = {}

Logger.Separator = function()
    print("^7========================================")
end

Logger.Error = function(msg)
    if Config.Debug and msg then
        Logger.Separator()
        print("^1[PEAKVILLE_SKILLS - ERROR] ^7" .. msg)
        Logger.Separator()
    end
end

Logger.Warning = function(msg)
    if Config.Debug and msg then
        Logger.Separator()
        print("^3[PEAKVILLE_SKILLS - WARNING] ^7" .. msg)
        Logger.Separator()
    end
end

Logger.Success = function(msg)
    if Config.Debug and msg then
        Logger.Separator()
        print("^2[PEAKVILLE_SKILLS - SUCCESS] ^7" .. msg)
        Logger.Separator()
    end
end

Logger.Info = function(msg)
    if Config.Debug and msg then
        Logger.Separator()
        print("^5[PEAKVILLE_SKILLS - INFO] ^7" .. msg)
        Logger.Separator()
    end
end

Logger.Init = function()
    Logger.Separator()
    print("^2[PEAKVILLE_SKILLS] ^7Initializing resource...")
    Logger.Separator()
end

Logger.FinishInit = function()
    Logger.Separator()
    print("^2[PEAKVILLE_SKILLS] ^7Resource initialized successfully!")
    Logger.Separator()
end
