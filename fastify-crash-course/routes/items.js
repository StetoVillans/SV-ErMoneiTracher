const {getItem, getItems} = require('../controllers/itemController')

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
        tags: ['user']
    },
    handler: getItems,
}

const getItemRouteOptions = {
    schema: {
        response: {
            200: Item
        }
    },
    handler: getItem,
}

function itemRoutes(fastify, options, done) {
    
    fastify.get('/items', getItemsRoutesOptions)

    fastify.get('/items/:id', getItemRouteOptions)
    
    done();
}

module.exports = itemRoutes