

ENTITY_DEFS = {
    ['player'] = {
        width = 16,
        height = 16,
        walkingSpeed = 100,
        animations = {
            ['walk-left'] = {
                frames = {67, 68, 69},
                interval = 0.15,
                texture = 'entities'
            },
            ['walk-right'] = {
                frames = {79, 80, 81},
                interval = 0.15,
                texture = 'entities'
            },
            ['walk-down'] = {
                frames = {55, 56, 57},
                interval = 0.15,
                texture = 'entities'
            },
            ['walk-up'] = {
                frames = {91, 92, 93},
                interval = 0.15,
                texture = 'entities'
            },
            ['idle-left'] = {
                frames = {67},
                texture = 'entities'
            },
            ['idle-right'] = {
                frames = {79},
                texture = 'entities'
            },
            ['idle-down'] = {
                frames = {55},
                texture = 'entities'
            },
            ['idle-up'] = {
                frames = {91},
                texture = 'entities'
            }
        }
    }
}

LEVELS_DEF = {
    [1] = {
        segments = 
        {
            {
                p1 = {LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                p2 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                width = LINE_WIDTH,
                face = 'down'
            },
            {
                p1 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                p2 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                width = LINE_WIDTH,
                face = 'left'
            },
            {
                p1 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                p2 = {LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                width = LINE_WIDTH,
                face = 'up'
            },
            {
                p1 = {LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                p2 = {LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                width= LINE_WIDTH,
                face = 'right'
            },
        },
        spiders = 0,
        timeLimit = 300,
        balls = 1,
        ballSpeed = 20,
    },    
    [2] = {
        segments = 
        {
            {
                p1 = {LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                p2 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                width = LINE_WIDTH,
                face = 'down'
            },
            {
                p1 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                p2 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                width = LINE_WIDTH,
                face = 'left'
            },
            {
                p1 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                p2 = {LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                width = LINE_WIDTH,
                face = 'up'
            },
            {
                p1 = {LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                p2 = {LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                width= LINE_WIDTH,
                face = 'right'
            },
        },
        spiders = 0,
        timeLimit = 35,
        balls = 2,
        ballSpeed = 40,
    },    
    [3] = {
        segments = 
        {
            {
                p1 = {LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                p2 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                width = LINE_WIDTH,
                face = 'down'
            },
            {
                p1 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                p2 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                width = LINE_WIDTH,
                face = 'left'
            },
            {
                p1 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                p2 = {LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                width = LINE_WIDTH,
                face = 'up'
            },
            {
                p1 = {LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                p2 = {LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                width= LINE_WIDTH,
                face = 'right'
            },
        },
        spiders = 0,
        timeLimit = 45,
        balls = 3,
        ballSpeed = 45,
    },    
    [4] = {
        segments = 
        {
            {
                p1 = {LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                p2 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                width = LINE_WIDTH,
                face = 'down'
            },
            {
                p1 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                p2 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                width = LINE_WIDTH,
                face = 'left'
            },
            {
                p1 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                p2 = {LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                width = LINE_WIDTH,
                face = 'up'
            },
            {
                p1 = {LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                p2 = {LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                width= LINE_WIDTH,
                face = 'right'
            },
        },
        spiders = 1,
        timeLimit = 60,
        balls = 3,
        ballSpeed = 45,
    },    
    [5] = {
        segments = 
        {
            {
                p1 = {LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                p2 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                width = LINE_WIDTH,
                face = 'down'
            },
            {
                p1 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                p2 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                width = LINE_WIDTH,
                face = 'left'
            },
            {
                p1 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                p2 = {LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                width = LINE_WIDTH,
                face = 'up'
            },
            {
                p1 = {LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                p2 = {LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                width= LINE_WIDTH,
                face = 'right'
            },
        },
        spiders = 1,
        timeLimit = 65,
        balls = 4,
        ballSpeed = 50,
    },    
    [6] = {
        segments = 
        {
            {
                p1 = {LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                p2 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                width = LINE_WIDTH,
                face = 'down'
            },
            {
                p1 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                p2 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                width = LINE_WIDTH,
                face = 'left'
            },
            {
                p1 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                p2 = {LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                width = LINE_WIDTH,
                face = 'up'
            },
            {
                p1 = {LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                p2 = {LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                width= LINE_WIDTH,
                face = 'right'
            },
        },
        spiders = 2,
        timeLimit = 75,
        balls = 4,
        ballSpeed = 50,
    },    
    [7] = {
        segments = 
        {
            {
                p1 = {LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                p2 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                width = LINE_WIDTH,
                face = 'down'
            },
            {
                p1 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                p2 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                width = LINE_WIDTH,
                face = 'left'
            },
            {
                p1 = {VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                p2 = {LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                width = LINE_WIDTH,
                face = 'up'
            },
            {
                p1 = {LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},
                p2 = {LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},
                width= LINE_WIDTH,
                face = 'right'
            },
        },
        spiders = 2,
        timeLimit = 90,
        balls = 5,
        ballSpeed = 60,
    },    
}