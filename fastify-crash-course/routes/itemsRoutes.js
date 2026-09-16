const {getItem, getItems, addItem} = require('../controllers/itemController')

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
        response: {
            201: Item
        },
        tags: ['item'],
    },
    handler: addItem,
}

function itemRoutes(fastify, options, done) {
    
    fastify.get('/items', getItemsRoutesOptions)

    fastify.get('/items/:id', getItemRouteOptions)

    fastify.post('/additems', postItemRoutesOptions)
    
    done();
}

module.exports = itemRoutes