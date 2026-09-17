const {getItem, getItems, addItem, deleteItem} = require('../controllers/itemController')

//Definizione degli item
const Item = {
  type: 'object',
  properties: {
     id: {type: 'string'},
    name: {type: 'string'},
    price: {type: 'number'}
  }
}


//Definizione delle options oggetti
 const getItemsRoutesOptions = {
    schema: {
        response: {
            200: {
                type: 'array',
                items: Item
            }
        },
        tags: ['item'],
    },
    handler: getItems,
}

const getItemRouteOptions = {
    schema: {
        response: {
            200: Item
        },
        tags: ['item'],
    },
    handler: getItem,
}

const postItemRoutesOptions = {
    schema: {
        body: {
            type: 'object',
            required: ['name'],
            properties: {
                name: {type: 'string'}
            },
        },
        response: {
            201: Item
        },
        tags: ['item'],
    },
    handler: addItem,
}

const deleteItemRouteOptions = {
    schema: {
        response: {
            200: {
                type: 'string', 
                description: "Item deleted"
            }
        },
        tags: ['item'],
    },
    handler: deleteItem,
}

function itemRoutes(fastify, options, done) {
    
    fastify.get('/items', getItemsRoutesOptions)

    fastify.get('/items/:id', getItemRouteOptions)

    fastify.post('/additems', postItemRoutesOptions)

    fastify.delete('/items/:id', deleteItemRouteOptions)
    
    done();
}

module.exports = itemRoutes