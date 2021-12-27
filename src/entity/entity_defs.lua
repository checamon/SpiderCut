

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
    },    
}