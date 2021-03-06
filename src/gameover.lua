local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local json = require( "json" )
local utility = require( "utility" )
local myData = require( "mydata" )
local gameNetwork = require( "gameNetwork" )
local device = require( "device" )

local params
local newHighScore = false

local function handleButtonEvent( event )

    if ( "ended" == event.phase ) then
        local options = {
            effect = "crossFade",
            time = 500,
            params = {
                someKey = "someValue",
                someOtherKey = 10
            }
        }
        composer.gotoScene( "menu", options )
    end
    return true
end

local function showLeaderboard( event )
    if event.phase == "ended" then
        gameNetwork.show( "leaderboards", { leaderboard = {timeScope="AllTime"}} )
    end
    return true
end

local function postToGameNetwork()
    local category = "com.yourdomain.yourgame.leaderboard"
    if myData.isGPGS then
        category = "CgkIusrvppwDJFHJKDFg"
    end
    gameNetwork.request("setHighScore", {
        localPlayerScore = {
            category = category, 
            value = myData.settings.bestScore
        },
        listener = postScoreSubmit
    })
end
--
-- Start the composer event handlers
--
function scene:create( event )
    local sceneGroup = self.view

    params = event.params
        
    --
    -- setup a page background, really not that important though composer
    -- crashes out if there isn't a display object in the view.
    --
    local screen_adjustment = 0.4
    --local background = display.newRect( 0, 0, 570, 360 )
    -- local background = display.newImage("images/background3.jpg",true)
    -- background.xScale = (screen_adjustment  * background.contentWidth)/background.contentWidth
    -- background.yScale = background.xScale
    -- background.x = display.contentWidth / 2
    -- background.y = display.contentHeight / 2
    -- sceneGroup:insert( background )

    local gameOverText = display.newImage("images/gameOver.png", true)
    --gameOverText:setFillColor( 0 )
    gameOverText.x = display.contentCenterX
    gameOverText.y = 50
    sceneGroup:insert(gameOverText)

    local highScoreText = display.newText("Highscore: "..params.bestScore, 0, 0, "after_shok.ttf", 24)
    highScoreText:setFillColor( 1 )
    highScoreText.x = display.contentCenterX
    highScoreText.y = 100
    sceneGroup:insert(highScoreText)

    self.highScoreText = highScoreText
    
    local yourScoreText = display.newText("Your score: "..params.currentScore,0,0,"after_shok.ttf",24)
    yourScoreText:setFillColor(1)
    yourScoreText.x = display.contentCenterX
    yourScoreText.y = 150
    sceneGroup:insert(yourScoreText)

    self.yourScoreText = yourScoreText

    -- local leaderBoardButton = widget.newButton({
    --     id = "leaderboard",
    --     --label = "Play",
    --     defaultFile = "button/leaderboardButton.png",
    --     onEvent = showLeaderboard
    -- })
    -- leaderBoardButton.x = display.contentCenterX 
    -- leaderBoardButton.y = 225
    -- sceneGroup:insert( leaderBoardButton )

    local doneButton = widget.newButton({
        id = "button1",
        label = "Done",
        width = 100,
        height = 32,
        onEvent = handleButtonEvent
    })
    doneButton.x = display.contentCenterX
    doneButton.y = display.contentHeight - 40
    sceneGroup:insert( doneButton )
end

function scene:show( event )
    local sceneGroup = self.view

    params = event.params

    if event.phase == "did" then

        print("current score: ", params.currentScore)
        print("best score: ", params.bestScore)

        self.highScoreText.text = "Highscore: "..params.bestScore
        self.yourScoreText.text = "Your score: "..params.currentScore


        --
        -- Hook up your score code here to support updating your leaderboards
        --[[
        if newHighScore then
            local popup = display.newText("New High Score", 0, 0, native.systemFontBold, 32)
            popup.x = display.contentCenterX
            popup.y = display.contentCenterY
            sceneGroup:insert( popup )
            postToGameNetwork(); 
        end
        --]]
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    
    if event.phase == "will" then
    end

end

function scene:destroy( event )
    local sceneGroup = self.view
    
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene
